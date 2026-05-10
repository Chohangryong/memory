import json
from dataclasses import replace
from datetime import datetime, timezone
from hashlib import sha256
from pathlib import Path

from fastapi import APIRouter, Depends, Header, HTTPException, Request, status
from fastapi.responses import HTMLResponse
from sqlalchemy.orm import Session

from myautomation.config import get_settings
from myautomation.core.schedule_parser import parse_schedule_text
from myautomation.db.session import get_db
from myautomation.models.api import ApiResponse, HealthResponse, ScheduleCommandRequest
from myautomation.models.db import AutomationRun
from myautomation.services.google_calendar_cli import (
    CalendarCliError,
    create_calendar_event,
    delete_calendar_event,
    get_calendar_event,
    patch_calendar_event,
)
from myautomation.services.llm_schedule_parser import parse_schedule_text_smart
from myautomation.services.runs import (
    create_run,
    create_schedule_event,
    find_schedule_event_by_id,
    find_run_by_request_id,
    finish_run,
    update_schedule_event_calendar_result,
    update_schedule_event_details,
    update_schedule_event_status,
)
from myautomation.services.schedule_event_matcher import find_schedule_event_matches
from myautomation.services.schedule_update_parser import extract_update_target_title, parse_update_changes

router = APIRouter()


def require_auth(
    authorization: str | None = Header(default=None),
    x_myautomation_token: str | None = Header(default=None),
) -> None:
    settings = get_settings()
    token = settings.api_token
    if token is None:
        return
    if authorization != f"Bearer {token}" and x_myautomation_token != token:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Unauthorized")


@router.get("/health", response_model=HealthResponse)
def health() -> HealthResponse:
    return HealthResponse(ok=True, status="ok", message="MyAutomation API is running.")


@router.get("/dashboard", response_class=HTMLResponse)
def dashboard() -> HTMLResponse:
    path = Path(__file__).resolve().parents[1] / "web" / "dashboard.html"
    return HTMLResponse(path.read_text(encoding="utf-8"))


@router.get("/runs", dependencies=[Depends(require_auth)])
def list_runs(limit: int = 50, db: Session = Depends(get_db)) -> dict[str, object]:
    safe_limit = max(1, min(limit, 100))
    runs = db.query(AutomationRun).order_by(AutomationRun.started_at.desc()).limit(safe_limit).all()
    return {
        "ok": True,
        "runs": [
            {
                "id": run.id,
                "automation_name": run.automation_name,
                "source": run.source,
                "input_text": run.input_text,
                "status": run.status,
                "result_message": run.result_message,
                "started_at": run.started_at.isoformat() if run.started_at else None,
                "finished_at": run.finished_at.isoformat() if run.finished_at else None,
                "schedule_events": [
                    {
                        "id": event.id,
                        "google_event_id": event.google_event_id,
                        "title": event.title,
                        "start_at": event.start_at,
                        "end_at": event.end_at,
                        "timezone": event.timezone,
                        "location": event.location,
                        "status": event.status,
                    }
                    for event in run.schedule_events
                ],
            }
            for run in runs
        ],
    }


@router.post("/runs/{run_id}/retry", response_model=ApiResponse, dependencies=[Depends(require_auth)])
def retry_run(run_id: str, db: Session = Depends(get_db)) -> ApiResponse:
    source_run = db.get(AutomationRun, run_id)
    if source_run is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Run not found")
    if source_run.status not in {"not_executed", "calendar_error"}:
        return ApiResponse(
            ok=False,
            status="not_executed",
            message="실행 안 함: 재처리는 실패 또는 미실행 기록에서만 가능합니다.",
            data={"run_id": run_id, "status": source_run.status},
        )
    request_id = f"retry-{run_id}-{datetime.now(timezone.utc).strftime('%Y%m%d%H%M%S%f')}"
    payload = ScheduleCommandRequest(
        text=source_run.input_text,
        source="dashboard_retry",
        request_id=request_id,
    )
    return _handle_schedule_command(payload, db)


@router.post("/commands/schedule", response_model=ApiResponse, dependencies=[Depends(require_auth)])
def schedule_command(payload: ScheduleCommandRequest, db: Session = Depends(get_db)) -> ApiResponse:
    return _handle_schedule_command(payload, db)


@router.post("/commands/schedule/text", response_model=ApiResponse, dependencies=[Depends(require_auth)])
async def schedule_text_command(
    request: Request,
    x_request_id: str | None = Header(default=None),
    db: Session = Depends(get_db),
) -> ApiResponse:
    text = (await request.body()).decode("utf-8")
    request_id = x_request_id.strip() if x_request_id else None
    if not request_id:
        request_id = _fallback_text_request_id(text)
    payload = ScheduleCommandRequest(text=text, request_id=request_id)
    return _handle_schedule_command(payload, db)


def _fallback_text_request_id(text: str) -> str:
    bucket = int(datetime.now(timezone.utc).timestamp() // 60)
    digest = sha256(f"ios_shortcut\0{text.strip()}\0{bucket}".encode("utf-8")).hexdigest()[:32]
    return f"text-{bucket}-{digest}"


def _handle_schedule_command(payload: ScheduleCommandRequest, db: Session) -> ApiResponse:
    existing_run = find_run_by_request_id(db, payload.request_id)
    if existing_run is not None:
        return ApiResponse(
            ok=True,
            status="duplicate",
            message=existing_run.result_message or "이미 처리된 요청입니다.",
            run_id=existing_run.id,
            data={"request_id": payload.request_id},
        )

    run = create_run(
        db,
        automation_name="schedule",
        source=payload.source,
        request_id=payload.request_id,
        input_text=payload.text,
    )
    candidate = parse_schedule_text_smart(
        payload.text,
        requested_at=payload.requested_at,
        timezone=payload.timezone,
    )

    event = create_schedule_event(
        db,
        run_id=run.id,
        title=candidate.title,
        start_at=candidate.start,
        end_at=candidate.end,
        timezone_name=candidate.timezone,
        location=candidate.location,
        status="candidate",
        source_text=payload.text,
    )

    settings = get_settings()
    if candidate.intent in {"delete", "update"}:
        operation_candidate = candidate
        if candidate.intent == "update":
            operation_candidate = parse_schedule_text(
                payload.text,
                requested_at=payload.requested_at,
                timezone=payload.timezone,
            )
            target_title = extract_update_target_title(payload.text)
            if target_title:
                operation_candidate = replace(operation_candidate, title=target_title)
        return _handle_calendar_mutation(
            db=db,
            run=run,
            event=event,
            candidate=operation_candidate,
            original_candidate=candidate,
            payload=payload,
            settings=settings,
        )

    if candidate.needs_confirmation:
        message = _not_executed_message(candidate.reason)
        update_schedule_event_status(db, event, status="not_executed")
        finish_run(db, run, status="not_executed", message=message)
        return ApiResponse(
            ok=False,
            status="not_executed",
            message=message,
            run_id=run.id,
            data={"candidate": candidate.to_dict(), "schedule_event_id": event.id},
        )

    if settings.calendar_write_enabled and candidate.intent == "create" and candidate.start and candidate.end:
        try:
            calendar_result = create_calendar_event(
                cli_path=settings.calendar_cli_path,
                calendar_id=settings.calendar_id,
                title=candidate.title,
                start=candidate.start,
                end=candidate.end,
                timezone=candidate.timezone,
                location=candidate.location,
            )
        except CalendarCliError as exc:
            message = f"실패: Google Calendar 생성 중 문제가 생겼습니다. {exc}"
            update_schedule_event_status(db, event, status="calendar_error")
            finish_run(db, run, status="calendar_error", message=message)
            return ApiResponse(
                ok=False,
                status="calendar_error",
                message=message,
                run_id=run.id,
                data={"candidate": candidate.to_dict(), "schedule_event_id": event.id},
            )

        update_schedule_event_calendar_result(
            db,
            event,
            google_event_id=calendar_result.event_id,
            status="created",
        )
        message = _calendar_created_message(candidate.title, candidate.start, candidate.end, candidate.location)
        finish_run(db, run, status="created", message=message)
        return ApiResponse(
            ok=True,
            status="created",
            message=message,
            run_id=run.id,
            data={
                "candidate": candidate.to_dict(),
                "schedule_event_id": event.id,
                "google_event_id": calendar_result.event_id,
                "google_event_link": calendar_result.html_link,
            },
        )

    message = _created_message(candidate.title, candidate.start, candidate.end, candidate.location)
    finish_run(db, run, status="dry_run", message=message)
    return ApiResponse(
        ok=True,
        status="dry_run",
        message=message,
        run_id=run.id,
        data={"candidate": candidate.to_dict(), "schedule_event_id": event.id},
    )


def _handle_calendar_mutation(
    *,
    db: Session,
    run,
    event,
    candidate,
    original_candidate,
    payload: ScheduleCommandRequest,
    settings,
) -> ApiResponse:
    if not settings.calendar_write_enabled:
        message = "실행 안 함: Google Calendar 쓰기가 꺼져 있습니다."
        update_schedule_event_status(db, event, status="not_executed")
        finish_run(db, run, status="not_executed", message=message)
        return ApiResponse(
            ok=False,
            status="not_executed",
            message=message,
            run_id=run.id,
            data={"candidate": original_candidate.to_dict(), "schedule_event_id": event.id},
        )

    target_matches = find_schedule_event_matches(db, candidate)
    if len(target_matches) != 1 or float(target_matches[0].get("score", 0)) < 0.9:
        message = _not_executed_message("삭제/수정 대상이 정확히 하나로 확정되지 않았습니다.")
        update_schedule_event_status(db, event, status="not_executed")
        finish_run(db, run, status="not_executed", message=message)
        return ApiResponse(
            ok=False,
            status="not_executed",
            message=message,
            run_id=run.id,
            data={
                "candidate": original_candidate.to_dict(),
                "schedule_event_id": event.id,
                "target_matches": target_matches,
            },
        )

    match = target_matches[0]
    google_event_id = str(match["google_event_id"])
    target_event = find_schedule_event_by_id(db, str(match["schedule_event_id"]))
    update_schedule_event_calendar_result(db, event, google_event_id=google_event_id, status="matched_candidate")

    try:
        current = get_calendar_event(
            cli_path=settings.calendar_cli_path,
            calendar_id=settings.calendar_id,
            event_id=google_event_id,
        )
        if current.status != "confirmed":
            raise CalendarCliError("대상 Google Calendar 이벤트가 confirmed 상태가 아닙니다.")

        if candidate.intent == "delete":
            delete_calendar_event(
                cli_path=settings.calendar_cli_path,
                calendar_id=settings.calendar_id,
                event_id=google_event_id,
            )
            if target_event is not None:
                update_schedule_event_status(db, target_event, status="deleted")
            update_schedule_event_status(db, event, status="delete_executed")
            message = _calendar_deleted_message(str(match["title"]), str(match["start"]), str(match["end"]))
            finish_run(db, run, status="delete_executed", message=message)
            return ApiResponse(
                ok=True,
                status="delete_executed",
                message=message,
                run_id=run.id,
                data={
                    "candidate": original_candidate.to_dict(),
                    "schedule_event_id": event.id,
                    "target_matches": target_matches,
                    "google_event_id": google_event_id,
                },
            )

        changes = parse_update_changes(
            payload.text,
            target=candidate,
            requested_at=payload.requested_at,
            timezone=candidate.timezone,
        )
        if not changes.has_changes() or bool(changes.start) != bool(changes.end):
            message = _not_executed_message("수정할 새 시간이나 새 이름이 명확하지 않습니다.")
            update_schedule_event_status(db, event, status="not_executed")
            finish_run(db, run, status="not_executed", message=message)
            return ApiResponse(
                ok=False,
                status="not_executed",
                message=message,
                run_id=run.id,
                data={
                    "candidate": original_candidate.to_dict(),
                    "schedule_event_id": event.id,
                    "target_matches": target_matches,
                },
            )

        updated = patch_calendar_event(
            cli_path=settings.calendar_cli_path,
            calendar_id=settings.calendar_id,
            event_id=google_event_id,
            title=changes.title,
            start=changes.start,
            end=changes.end,
            timezone=candidate.timezone,
            location=changes.location,
        )
    except CalendarCliError as exc:
        message = f"실패: Google Calendar 실행 중 문제가 생겼습니다. {exc}"
        update_schedule_event_status(db, event, status="calendar_error")
        finish_run(db, run, status="calendar_error", message=message)
        return ApiResponse(
            ok=False,
            status="calendar_error",
            message=message,
            run_id=run.id,
            data={
                "candidate": original_candidate.to_dict(),
                "schedule_event_id": event.id,
                "target_matches": target_matches,
            },
        )

    if target_event is not None:
        update_schedule_event_details(
            db,
            target_event,
            title=updated.title,
            start_at=updated.start,
            end_at=updated.end,
            location=changes.location,
            status="created",
        )
    update_schedule_event_details(
        db,
        event,
        title=updated.title,
        start_at=updated.start,
        end_at=updated.end,
        location=changes.location,
        status="update_executed",
    )
    message = _calendar_updated_message(updated.title or str(match["title"]), updated.start, updated.end)
    finish_run(db, run, status="update_executed", message=message)
    return ApiResponse(
        ok=True,
        status="update_executed",
        message=message,
        run_id=run.id,
        data={
            "candidate": original_candidate.to_dict(),
            "schedule_event_id": event.id,
            "target_matches": target_matches,
            "google_event_id": google_event_id,
        },
    )


def _not_executed_message(reason: str | None) -> str:
    return f"실행 안 함: {reason or '요청을 더 명확히 확인해야 합니다.'}"


def _created_message(title: str, start: str | None, end: str | None, location: str | None) -> str:
    lines = [
        "일정 후보를 만들었습니다.",
        f"- 제목: {title}",
    ]
    if start and end:
        lines.append(f"- 일시: {start} ~ {end}")
    if location:
        lines.append(f"- 장소: {location}")
    return "\n".join(lines)


def _calendar_created_message(title: str, start: str | None, end: str | None, location: str | None) -> str:
    lines = [
        "완료: Google Calendar에 일정을 만들었습니다.",
        f"- 제목: {title}",
    ]
    if start and end:
        lines.append(f"- 일시: {start} ~ {end}")
    if location:
        lines.append(f"- 장소: {location}")
    return "\n".join(lines)


def _calendar_deleted_message(title: str, start: str | None, end: str | None) -> str:
    lines = [
        "완료: Google Calendar 일정을 삭제했습니다.",
        f"- 제목: {title}",
    ]
    if start and end:
        lines.append(f"- 일시: {start} ~ {end}")
    return "\n".join(lines)


def _calendar_updated_message(title: str, start: str | None, end: str | None) -> str:
    lines = [
        "완료: Google Calendar 일정을 수정했습니다.",
        f"- 제목: {title}",
    ]
    if start and end:
        lines.append(f"- 일시: {start} ~ {end}")
    return "\n".join(lines)

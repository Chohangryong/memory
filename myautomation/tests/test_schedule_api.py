from collections.abc import Generator
import os

from fastapi.testclient import TestClient
from sqlalchemy import create_engine
from sqlalchemy.orm import Session, sessionmaker
from sqlalchemy.pool import StaticPool

from myautomation.api.routes import require_auth
from myautomation.config import get_settings
from myautomation.db.session import get_db
from myautomation.main import create_app
from myautomation.models.db import Approval, AutomationRun, Base, ScheduleEvent
from myautomation.services.google_calendar_cli import CalendarCreateResult, CalendarEventResult


def make_client() -> tuple[TestClient, sessionmaker[Session]]:
    os.environ["OPENAI_API_KEY"] = ""
    os.environ["MYAUTOMATION_CALENDAR_WRITE_ENABLED"] = "false"
    get_settings.cache_clear()
    engine = create_engine(
        "sqlite://",
        connect_args={"check_same_thread": False},
        poolclass=StaticPool,
    )
    Base.metadata.create_all(bind=engine)
    testing_session = sessionmaker(bind=engine, autocommit=False, autoflush=False)
    app = create_app()

    def override_db() -> Generator[Session]:
        db = testing_session()
        try:
            yield db
        finally:
            db.close()

    app.dependency_overrides[get_db] = override_db
    app.dependency_overrides[require_auth] = lambda: None
    return TestClient(app), testing_session


def test_schedule_command_returns_dry_run_for_clear_create_request() -> None:
    client, testing_session = make_client()

    response = client.post(
        "/api/commands/schedule",
        json={
            "text": "내일 오후 3시에 강남에서 미팅 1시간 잡아줘",
            "source": "ios_shortcut",
            "timezone": "Asia/Seoul",
            "requested_at": "2026-05-10T19:30:00+09:00",
            "request_id": "ios-test-1",
        },
    )

    assert response.status_code == 200
    body = response.json()
    assert body["ok"] is True
    assert body["status"] == "dry_run"
    assert body["data"]["candidate"]["title"] == "미팅"
    assert body["data"]["candidate"]["start"] == "2026-05-11T15:00:00+09:00"
    assert body["data"]["candidate"]["end"] == "2026-05-11T16:00:00+09:00"
    assert body["data"]["candidate"]["location"] == "강남"

    with testing_session() as db:
        assert db.query(AutomationRun).count() == 1
        assert db.query(ScheduleEvent).count() == 1
        assert db.query(Approval).count() == 0


def test_schedule_command_does_not_execute_ambiguous_request() -> None:
    client, testing_session = make_client()

    response = client.post(
        "/api/commands/schedule",
        json={
            "text": "다음 주 회의 미뤄줘",
            "requested_at": "2026-05-10T19:30:00+09:00",
            "request_id": "ios-test-2",
        },
    )

    assert response.status_code == 200
    body = response.json()
    assert body["status"] == "not_executed"
    assert body["approval_id"] is None

    with testing_session() as db:
        assert db.query(AutomationRun).count() == 1
        assert db.query(ScheduleEvent).count() == 1
        assert db.query(Approval).count() == 0


def test_schedule_text_command_accepts_plain_text_shortcut_body() -> None:
    client, testing_session = make_client()

    response = client.post(
        "/api/commands/schedule/text",
        content="내일 오후 3시에 강남에서 미팅 1시간 잡아줘",
        headers={"content-type": "text/plain"},
    )

    assert response.status_code == 200
    body = response.json()
    assert body["ok"] is True
    assert body["status"] == "dry_run"
    assert body["data"]["candidate"]["title"] == "미팅"

    with testing_session() as db:
        assert db.query(AutomationRun).count() == 1
        assert db.query(ScheduleEvent).count() == 1


def test_schedule_text_command_uses_request_id_header_for_deduplication() -> None:
    client, testing_session = make_client()
    headers = {"content-type": "text/plain", "X-Request-Id": "shortcut-request-1"}

    first = client.post("/api/commands/schedule/text", content="내일 오후 3시에 미팅 잡아줘", headers=headers)
    second = client.post("/api/commands/schedule/text", content="내일 오후 3시에 미팅 잡아줘", headers=headers)

    assert first.status_code == 200
    assert second.status_code == 200
    assert second.json()["status"] == "duplicate"

    with testing_session() as db:
        assert db.query(AutomationRun).count() == 1
        assert db.query(ScheduleEvent).count() == 1


def test_schedule_text_command_deduplicates_without_request_id_header() -> None:
    client, testing_session = make_client()
    headers = {"content-type": "text/plain"}

    first = client.post("/api/commands/schedule/text", content="내일 오후 3시에 미팅 잡아줘", headers=headers)
    second = client.post("/api/commands/schedule/text", content="내일 오후 3시에 미팅 잡아줘", headers=headers)

    assert first.status_code == 200
    assert second.status_code == 200
    assert second.json()["status"] == "duplicate"

    with testing_session() as db:
        assert db.query(AutomationRun).count() == 1
        assert db.query(ScheduleEvent).count() == 1


def test_auth_accepts_shortcut_token_header(monkeypatch) -> None:
    client, _ = make_client()
    token = "shortcut-test-token"
    get_settings.cache_clear()
    monkeypatch.setenv("MYAUTOMATION_API_TOKEN", token)
    client.app.dependency_overrides.pop(require_auth, None)

    response = client.post(
        "/api/commands/schedule/text",
        content="내일 오후 3시에 미팅 잡아줘",
        headers={"X-MyAutomation-Token": token},
    )

    get_settings.cache_clear()
    assert response.status_code == 200


def test_schedule_command_deduplicates_request_id() -> None:
    client, testing_session = make_client()
    payload = {
        "text": "내일 오후 3시에 강남에서 미팅 1시간 잡아줘",
        "requested_at": "2026-05-10T19:30:00+09:00",
        "request_id": "ios-test-3",
    }

    first = client.post("/api/commands/schedule", json=payload)
    second = client.post("/api/commands/schedule", json=payload)

    assert first.status_code == 200
    assert second.status_code == 200
    assert second.json()["status"] == "duplicate"

    with testing_session() as db:
        assert db.query(AutomationRun).count() == 1
        assert db.query(ScheduleEvent).count() == 1


def test_list_runs_returns_recent_schedule_events() -> None:
    client, testing_session = make_client()
    with testing_session() as db:
        db.add(
            AutomationRun(
                id="run_dashboard",
                automation_name="schedule",
                source="test",
                request_id="dashboard-test",
                input_text="내일 오전 9시 테스트일정 추가",
                status="created",
                result_message="완료",
            )
        )
        db.add(
            ScheduleEvent(
                id="sched_dashboard",
                run_id="run_dashboard",
                google_event_id="google-dashboard-1",
                title="테스트일정",
                start_at="2026-05-11T09:00:00+09:00",
                end_at="2026-05-11T10:00:00+09:00",
                timezone="Asia/Seoul",
                location=None,
                status="created",
                source_text="내일 오전 9시 테스트일정 추가",
            )
        )
        db.commit()

    response = client.get("/api/runs")

    assert response.status_code == 200
    body = response.json()
    assert body["ok"] is True
    assert body["runs"][0]["id"] == "run_dashboard"
    assert body["runs"][0]["schedule_events"][0]["google_event_id"] == "google-dashboard-1"


def test_retry_run_reprocesses_not_executed_request() -> None:
    client, testing_session = make_client()
    with testing_session() as db:
        db.add(
            AutomationRun(
                id="run_retry",
                automation_name="schedule",
                source="test",
                request_id="retry-source",
                input_text="내일 오후 3시에 강남에서 미팅 1시간 잡아줘",
                status="not_executed",
                result_message="실행 안 함",
            )
        )
        db.commit()

    response = client.post("/api/runs/run_retry/retry")

    assert response.status_code == 200
    body = response.json()
    assert body["ok"] is True
    assert body["status"] == "dry_run"

    with testing_session() as db:
        runs = db.query(AutomationRun).order_by(AutomationRun.started_at.asc()).all()
        assert len(runs) == 2
        assert runs[1].source == "dashboard_retry"
        assert runs[1].request_id.startswith("retry-run_retry-")


def test_retry_run_rejects_successful_request() -> None:
    client, testing_session = make_client()
    with testing_session() as db:
        db.add(
            AutomationRun(
                id="run_success",
                automation_name="schedule",
                source="test",
                request_id="success-source",
                input_text="내일 오후 3시에 미팅 잡아줘",
                status="created",
            )
        )
        db.commit()

    response = client.post("/api/runs/run_success/retry")

    assert response.status_code == 200
    body = response.json()
    assert body["ok"] is False
    assert body["status"] == "not_executed"

    with testing_session() as db:
        assert db.query(AutomationRun).count() == 1


def test_schedule_command_creates_google_calendar_event_when_enabled(monkeypatch) -> None:
    os.environ["MYAUTOMATION_CALENDAR_WRITE_ENABLED"] = "true"
    os.environ["MYAUTOMATION_CALENDAR_ID"] = "test-calendar"
    os.environ["MYAUTOMATION_CALENDAR_CLI_PATH"] = "/usr/local/bin/gws"
    get_settings.cache_clear()
    client, testing_session = make_client()
    os.environ["MYAUTOMATION_CALENDAR_WRITE_ENABLED"] = "true"
    get_settings.cache_clear()
    calls = []

    def fake_create_calendar_event(**kwargs):
        calls.append(kwargs)
        return CalendarCreateResult(event_id="google-event-1", html_link="https://calendar.google.com/event")

    monkeypatch.setattr("myautomation.api.routes.create_calendar_event", fake_create_calendar_event)

    response = client.post(
        "/api/commands/schedule",
        json={
            "text": "내일 오후 3시에 강남에서 미팅 1시간 잡아줘",
            "timezone": "Asia/Seoul",
            "requested_at": "2026-05-10T19:30:00+09:00",
            "request_id": "ios-test-calendar-1",
        },
    )

    assert response.status_code == 200
    body = response.json()
    assert body["ok"] is True
    assert body["status"] == "created"
    assert body["data"]["google_event_id"] == "google-event-1"
    assert calls[0]["calendar_id"] == "test-calendar"
    assert calls[0]["title"] == "미팅"
    assert calls[0]["start"] == "2026-05-11T15:00:00+09:00"
    assert calls[0]["end"] == "2026-05-11T16:00:00+09:00"

    with testing_session() as db:
        event = db.query(ScheduleEvent).one()
        run = db.query(AutomationRun).one()
        assert event.status == "created"
        assert event.google_event_id == "google-event-1"
        assert run.status == "created"


def test_delete_request_executes_when_single_high_confidence_match(monkeypatch) -> None:
    client, testing_session = make_client()
    os.environ["MYAUTOMATION_CALENDAR_WRITE_ENABLED"] = "true"
    get_settings.cache_clear()
    with testing_session() as db:
        db.add(
            AutomationRun(
                id="run_existing",
                automation_name="schedule",
                source="test",
                request_id="existing",
                input_text="내일 오전 9시 테스트일정 추가",
                status="created",
            )
        )
        db.add(
            ScheduleEvent(
                id="sched_existing",
                run_id="run_existing",
                google_event_id="google-existing-1",
                title="테스트일정",
                start_at="2026-05-11T09:00:00+09:00",
                end_at="2026-05-11T10:00:00+09:00",
                timezone="Asia/Seoul",
                location=None,
                status="created",
                source_text="내일 오전 9시 테스트일정 추가",
            )
        )
        db.commit()

    def fake_get_calendar_event(**kwargs):
        return CalendarEventResult(
            event_id="google-existing-1",
            status="confirmed",
            title="테스트일정",
            start="2026-05-11T09:00:00+09:00",
            end="2026-05-11T10:00:00+09:00",
            html_link=None,
        )

    deleted = []

    def fake_delete_calendar_event(**kwargs):
        deleted.append(kwargs)

    monkeypatch.setattr("myautomation.api.routes.get_calendar_event", fake_get_calendar_event)
    monkeypatch.setattr("myautomation.api.routes.delete_calendar_event", fake_delete_calendar_event)

    response = client.post(
        "/api/commands/schedule",
        json={
            "text": "내일 오전 9시 일정 삭제해줘",
            "timezone": "Asia/Seoul",
            "requested_at": "2026-05-10T19:30:00+09:00",
            "request_id": "ios-test-delete-1",
        },
    )

    assert response.status_code == 200
    body = response.json()
    assert body["status"] == "delete_executed"
    assert body["data"]["target_matches"][0]["google_event_id"] == "google-existing-1"
    assert deleted[0]["event_id"] == "google-existing-1"

    with testing_session() as db:
        delete_event = db.query(ScheduleEvent).filter(ScheduleEvent.id != "sched_existing").one()
        existing_event = db.query(ScheduleEvent).filter(ScheduleEvent.id == "sched_existing").one()
        assert db.query(Approval).count() == 0
        assert delete_event.google_event_id == "google-existing-1"
        assert delete_event.status == "delete_executed"
        assert existing_event.status == "deleted"


def test_update_request_patches_when_single_high_confidence_match(monkeypatch) -> None:
    client, testing_session = make_client()
    os.environ["MYAUTOMATION_CALENDAR_WRITE_ENABLED"] = "true"
    get_settings.cache_clear()
    with testing_session() as db:
        db.add(
            AutomationRun(
                id="run_existing",
                automation_name="schedule",
                source="test",
                request_id="existing-update",
                input_text="내일 오전 9시 테스트일정 추가",
                status="created",
            )
        )
        db.add(
            ScheduleEvent(
                id="sched_existing",
                run_id="run_existing",
                google_event_id="google-existing-1",
                title="테스트일정",
                start_at="2026-05-11T09:00:00+09:00",
                end_at="2026-05-11T10:00:00+09:00",
                timezone="Asia/Seoul",
                location=None,
                status="created",
                source_text="내일 오전 9시 테스트일정 추가",
            )
        )
        db.commit()

    def fake_get_calendar_event(**kwargs):
        return CalendarEventResult(
            event_id="google-existing-1",
            status="confirmed",
            title="테스트일정",
            start="2026-05-11T09:00:00+09:00",
            end="2026-05-11T10:00:00+09:00",
            html_link=None,
        )

    patched = []

    def fake_patch_calendar_event(**kwargs):
        patched.append(kwargs)
        return CalendarEventResult(
            event_id="google-existing-1",
            status="confirmed",
            title="테스트일정",
            start="2026-05-11T13:00:00+09:00",
            end="2026-05-11T14:00:00+09:00",
            html_link=None,
        )

    monkeypatch.setattr("myautomation.api.routes.get_calendar_event", fake_get_calendar_event)
    monkeypatch.setattr("myautomation.api.routes.patch_calendar_event", fake_patch_calendar_event)

    response = client.post(
        "/api/commands/schedule",
        json={
            "text": "내일 오전 9시 테스트일정 오후 1시로 변경해줘",
            "timezone": "Asia/Seoul",
            "requested_at": "2026-05-10T19:30:00+09:00",
            "request_id": "ios-test-update-1",
        },
    )

    assert response.status_code == 200
    body = response.json()
    assert body["status"] == "update_executed"
    assert patched[0]["event_id"] == "google-existing-1"
    assert patched[0]["start"] == "2026-05-11T13:00:00+09:00"
    assert patched[0]["end"] == "2026-05-11T14:00:00+09:00"

    with testing_session() as db:
        existing_event = db.query(ScheduleEvent).filter(ScheduleEvent.id == "sched_existing").one()
        update_event = db.query(ScheduleEvent).filter(ScheduleEvent.id != "sched_existing").one()
        assert existing_event.start_at == "2026-05-11T13:00:00+09:00"
        assert existing_event.end_at == "2026-05-11T14:00:00+09:00"
        assert update_event.status == "update_executed"


def test_update_request_patches_title_when_single_high_confidence_match(monkeypatch) -> None:
    client, testing_session = make_client()
    os.environ["MYAUTOMATION_CALENDAR_WRITE_ENABLED"] = "true"
    get_settings.cache_clear()
    with testing_session() as db:
        db.add(
            AutomationRun(
                id="run_existing",
                automation_name="schedule",
                source="test",
                request_id="existing-update-title",
                input_text="내일 오전 9시 테스트일정 추가",
                status="created",
            )
        )
        db.add(
            ScheduleEvent(
                id="sched_existing",
                run_id="run_existing",
                google_event_id="google-existing-1",
                title="테스트일정",
                start_at="2026-05-11T09:00:00+09:00",
                end_at="2026-05-11T10:00:00+09:00",
                timezone="Asia/Seoul",
                location=None,
                status="created",
                source_text="내일 오전 9시 테스트일정 추가",
            )
        )
        db.commit()

    def fake_get_calendar_event(**kwargs):
        return CalendarEventResult(
            event_id="google-existing-1",
            status="confirmed",
            title="테스트일정",
            start="2026-05-11T09:00:00+09:00",
            end="2026-05-11T10:00:00+09:00",
            html_link=None,
        )

    patched = []

    def fake_patch_calendar_event(**kwargs):
        patched.append(kwargs)
        return CalendarEventResult(
            event_id="google-existing-1",
            status="confirmed",
            title="병원예약",
            start="2026-05-11T09:00:00+09:00",
            end="2026-05-11T10:00:00+09:00",
            html_link=None,
        )

    monkeypatch.setattr("myautomation.api.routes.get_calendar_event", fake_get_calendar_event)
    monkeypatch.setattr("myautomation.api.routes.patch_calendar_event", fake_patch_calendar_event)

    response = client.post(
        "/api/commands/schedule",
        json={
            "text": "내일 오전 9시 테스트일정을 병원예약으로 변경해줘",
            "timezone": "Asia/Seoul",
            "requested_at": "2026-05-10T19:30:00+09:00",
            "request_id": "ios-test-update-title-1",
        },
    )

    assert response.status_code == 200
    body = response.json()
    assert body["status"] == "update_executed"
    assert patched[0]["title"] == "병원예약"
    assert patched[0]["start"] is None
    assert patched[0]["end"] is None

    with testing_session() as db:
        existing_event = db.query(ScheduleEvent).filter(ScheduleEvent.id == "sched_existing").one()
        update_event = db.query(ScheduleEvent).filter(ScheduleEvent.id != "sched_existing").one()
        assert existing_event.title == "병원예약"
        assert existing_event.start_at == "2026-05-11T09:00:00+09:00"
        assert update_event.title == "병원예약"
        assert update_event.status == "update_executed"

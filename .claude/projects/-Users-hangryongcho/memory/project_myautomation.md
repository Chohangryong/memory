---
name: project_myautomation
description: 개인 일상 자동화 허브(~/myautomation). 자연어 일정→Google Calendar 등록. gws CLI OAuth 토큰 주기 만료(invalid_grant) 이슈 + /gws-reauth 스킬(Playwright 자동 동의)로 해결.
metadata: 
  node_type: memory
  type: project
  originSessionId: 99d2b650-2493-4981-bb3d-1df1b59a1b27
---

# myautomation (개인 일상 자동화 허브)

- **위치:** `~/myautomation` (Chohangryong/myautomation 추정). FastAPI + SQLite. iPhone Shortcut → Cloudflare Tunnel → `/api/commands/schedule`.
- **기능:** 자연어 일정 명령("6월11일 6시 모임 추가")을 파싱(`llm_schedule_parser`/`schedule_parser`) → `gws`(Google Workspace CLI) 서브프로세스로 Google Calendar 등록. todo도 지원.
- **DB:** `data/myautomation.db`. `automation_runs`(요청 로그, status=created/calendar_error/not_executed) + `schedule_events`(파싱된 title/start/end/tz/location + google_event_id, 실패건은 빈 event_id + status=calendar_error).
- **인증:** `gws` CLI(`~/.config/gws/`, 개인 계정 hrocho2@gmail.com, GCP project academy-gws-cli). 동의화면 "Testing" 상태라 **리프레시 토큰이 주기적으로 폐기됨(invalid_grant)** → 일정 등록이 calendar_error로 조용히 실패.

## 핵심 운영 지식: 일정 등록 안 될 때

증상 "오늘/일정 등록 안 됨" → 거의 항상 **gws OAuth 토큰 만료(invalid_grant 401)**. 파싱·과거일정 로직 문제 아님.
- 진단: `gws calendar events list --params '{"calendarId":"primary","maxResults":1}' --format json` → `invalid_grant`/401 확인. (앱 에러메시지가 "Using keyring backend: keyring"로 가려지는 건 `_summarize_cli_error`가 stderr 첫줄만 잘라서 — 미수정 보고버그)
- 해결: **`/gws-reauth` 스킬** (`~/.claude/skills/gws-reauth/`). 발동어 "구글 토큰 만료/재인증/캘린더 등록 안 됨".

## /gws-reauth 스킬 구조

- `scripts/reauth.sh [--no-open]` — 토큰 프로브(정상이면 멱등 종료) → `gws auth login` 백그라운드 → URL 추출 → (`--no-open`은 `OAUTH_URL=` 출력만, 아니면 `open`) → 콜백 대기 → 검증. `REAUTH_TIMEOUT`(기본180) 조절.
- `scripts/retry_failed.py` — **재인증 성공 후에만** 실행. `schedule_events` status=calendar_error + 빈 event_id 건을 캘린더 실조회 중복검사 후 재등록(과거일정 skip). 앱 서비스(`create_calendar_event`/`list_calendar_events`) 재사용.
- **Playwright 자동 동의(검증 완료 2026-05-31):** `--no-open` URL을 Playwright MCP로 navigate → 계정선택 → "미확인 앱 계속" → "모두 선택" → "계속" → Success 콜백. **동의 클릭까지 무인.** 단 Playwright 프로필(`~/Library/Caches/ms-playwright/`)에 Google 세션 必 — 최초 1회만 사람이 로그인(비번/패스키), 이후 영구 자동. Google이 가끔 "본인 확인" 재로그인 요구 시에만 1회 사람 개입.

## 안 한 것 / 다음 후보
- OAuth 동의화면 Production 게시(=7일 만료 차단)는 **검증 절차 부담으로 보류**(사용자 결정).
- 일일 launchd 자동감지+알림 프로브 보류(온디맨드 스킬만 먼저).
- `_summarize_cli_error` invalid_grant 명시 보고 개선 미적용.

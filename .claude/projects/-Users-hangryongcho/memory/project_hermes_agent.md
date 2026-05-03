---
name: Hermes Agent 설치 현황
description: NousResearch/hermes-agent 사용자 전역 설치 완료 (2026-05-03), hermes setup 미진행
type: project
originSessionId: 596c9e0c-0347-497f-850f-e03c0c51b3c8
---
# Hermes Agent

NousResearch/hermes-agent — Nous Research가 만든 self-improving AI 에이전트. Telegram/Discord/Slack 등 메시징 게이트웨이 + 스킬 자동 생성·자가개선 + 크론 스케줄링 지원. 본인 전용 팀으로 사용 목적.

## 설치 상태 (2026-05-03 완료)

**설치 방식:** curl one-liner (`scripts/install.sh`) — 사용자 전역 설치
- 클론 방식 대신 선택. 이유: 본체 코드 수정 불필요, 업데이트 `hermes update` 한 줄로 끝.

**경로:**
- 코드: `~/.hermes/hermes-agent/`
- 설정·데이터: `~/.hermes/` (config.yaml, .env, SOUL.md, sessions/, cron/, logs/, skills/)
- 명령어: `~/.local/bin/hermes` (PATH 등록 완료)

**번들 스킬:** 89개 자동 동기화 (`~/.hermes/skills/`)

**미해결:**
- `hermes setup` 미진행 — 모델/API 키/working directory 미설정. 사용자가 직접 터미널에서 `source ~/.zshrc && hermes setup` 실행 필요.
- Playwright Chromium 미설치 — 브라우저 툴 사용 시 `cd ~/.hermes/hermes-agent && npx playwright install chromium`.
- pyproject.toml `exclude-newer = "7 days"` 파싱 경고 (무해, 설치는 정상).

## 운영 의도

- **기존 프로젝트 파일 직접 조작 가능하게 working directory를 홈(`/Users/hangryongcho`)으로 잡을 예정.**
- 위험: `.ssh/`, `.aws/`, `.claude/`, `.gitconfig` 등 민감 파일 노출 가능. command approval 활성화 + 제외 패턴 설정 필요.
- 대안: `~/projects/` 같은 심볼릭 모음 폴더로 노출 범위 제한.

## Why
사용자가 "내 팀을 만들고 싶다"고 명시. 인스타 피드 생성기·heisenberg·cosmetics 등 기존 파이프라인과 별개로 메시징 인터페이스(Telegram 등)에서 호출 가능한 상시 에이전트가 필요.

## How to apply
- Hermes 관련 질문은 우선 `~/.hermes/config.yaml`, `.env`, `SOUL.md` 직접 확인.
- 본체 디버깅 필요 시 `~/.hermes/hermes-agent/` 코드 참조.
- 새 스킬 작성은 `~/.hermes/skills/` 하위에. 커스텀 스킬은 번들과 분리 폴더 권장.

---
name: heisenberg-agent project status
description: Current state of heisenberg-agent project — branches, phases completed, what's next
type: project
---

## Heisenberg Agent — 프로젝트 현황 (2026-04-01 최종)

### 프로젝트 요약
heisenberg.kr 회원제 기술 콘텐츠 수집 → LLM 구조화 분석 → ChromaDB/Notion 동기화 파이프라인.
SQLite가 SSOT. Python 3.11, Playwright, LiteLLM, APScheduler.

### Git 상태
- **main**: `18b017a` — feat/pipeline-improvements 머지 완료. origin/main push 완료.

### 완료된 모든 Phase

| Phase | 내용 | 상태 |
|---|---|---|
| 0–6 | Foundation ~ Live smoke | main 머지 완료 |
| 7-A | Ops hardening (launchd, .env, operations.md) | main 머지 완료 |
| sync-prod | Chroma/Notion hardening, schema SSOT, live smoke | main 머지 완료 |
| sync-hardening-batch1 | safe unlock, FIFO ordering, naive UTC 통일 | main 머지 완료 |
| pipeline-improvements | Batch 2 + 병렬 LLM, incremental sync, Notion 수정, retry hardening | main 머지 완료 (`18b017a`) |

### pipeline-improvements에서 완료된 항목
- Notion adapter transient retry (tenacity)
- Notion payload size 사전 검증
- collected_at payload key 정리
- SyncAgent target별 stats / 카운터 버그 수정
- LLM 병렬 호출 (analysis + summary + critique 동시)
- Incremental sync (변경분만 동기화)
- published_at dot format 파싱 + author 추출
- Notion 날짜 timezone offset 수정
- LLM transient error retry (exponential backoff)
- LLM 모델 변경: primary=gpt-5.4, fallback=claude-sonnet-4-6, fallback_2=gemini-3.0-pro
- prompt-bundle v2

### Batch 3 — 취소됨
sync health report, drift detection, dry_run, backpressure는 현재 불필요로 판단하여 진행하지 않음.

### 다음 작업
미정 — 사용자와 논의 필요.

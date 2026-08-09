---
name: heisenberg-agent key technical decisions
description: Important architectural and technical decisions made during development
type: project
---

## 주요 기술 결정 사항

### Selector v2
- heisenberg.kr의 실제 rendered DOM 기반 CSS selector profile
- `config/selectors/heisenberg.yaml`에서 관리
- v1 (추정 기반) → v2 (실제 캡처 HTML 기반) 전환 완료
- 주요 구조: `div.loop-list > div.content` (list), `div.single-content` (detail)
- section은 `content-block content-{kind} content-{tier}` 클래스 기반

### OpenAI Structured Output 호환
- Pydantic 모델에 `extra="forbid"` → `additionalProperties: false` 자동 생성
- `ensure_openai_strict_schema()` 후처리: 모든 object에 `additionalProperties: false` + `required = list(properties.keys())` 보정
- Pydantic 모델의 optional/required 의미는 변경하지 않음 — 후처리는 API 전송용 schema에만 적용

### Collector Dedupe
- discover 단계에서 canonical url 기준 dedupe (url 우선, slug fallback)
- dedupe → max_articles_per_cycle slice 순서 (dedupe가 먼저)
- save 단계 IntegrityError는 동일 (source_site, url) 기존 row 재조회 → absorbed/noop

### .env 로드
- `settings.py`의 `_project_root()`가 프로젝트 루트를 절대경로로 resolve
- editable install (`pip install -e .`) 전제 — `src/heisenberg_agent/settings.py`에서 3단계 상위

### v0.1.0 태그 정책
- 릴리스 태그는 찍은 시점 유지, 이후 docs 커밋으로 이동하지 않음

### Sync Production 안정화 설계 결정 (2026-03-23)
- **에러 분류 2계층**: adapter-level (transient retry) + job-level (backoff retry)
- **Chroma retry**: tenacity 3회, transient만 (OSError/ConnectionError/TimeoutError). Non-transient(ValueError, TypeError)은 즉시 실패
- **Chroma 에러 분류 순서**: ConnectionError → TimeoutError → OSError (subclass-first)
- **Notion 에러 분류**: status 속성 기반 (429→rate_limit, 5xx→server_error, 4xx→client_error), fallback으로 문자열 매칭
- **exhausted 상태**: max_attempts 도달 시 failed 대신 exhausted. find_pending_jobs에서 자동 제외. payload 변경 시 re-arm 가능
- **429 circuit breaker**: 한 notion job이 429 → 나머지 job은 defer (attempt_count 미증가, next_retry_at만 설정, locked_at=None)
- **re-arm 조건 (target별)**:
  - notion: analysis_id 변경 OR payload_hash 변경
  - vector: analysis_id 변경 OR embedding_version 변경 OR payload_hash 변경
  - job.payload_hash가 None이면 current_hash 있을 때 re-arm (backfill 대응)
- **payload_hash 갱신 시점**: mark_succeeded에서만. 부분 성공은 갱신하지 않음
- **ArticleEvent payload_json**: error_message 200자 truncate + "...(truncated)" 표시 + error_message_truncated=true 플래그. 상세는 structlog에만
- **exhausted 로그**: last_error_retryable (원래 retryable) + exhausted=true (terminal 상태) 분리

### Notion Sync 배치 2 설계 결정 (2026-03-23)
- **SSOT**: `config/notion_schema.yaml`이 property name/type의 단일 정의. adapter에 하드코딩 없음
- **운영 규칙**: yaml의 `name` 필드는 실제 Notion Data Source property 이름과 정확히 일치해야 함
- **Drift detection**: `test_schema_keys_match_payload_keys` — yaml keys == payload keys 자동 검증
- **parent 형태**: `parent.type = "data_source_id"` (database_id 아님). Notion API 2025-09-03 가이드 준수
- **NOTION_DATA_SOURCE_ID**: 런타임 필수 (notion.enabled=True일 때). 없으면 앱 기동은 정상, notion sync만 skip+warn
- **NOTION_PARENT_PAGE_ID**: 선택. DB/data source 자동 생성 시에만 사용
- **Notion body = viewer-only managed content**: 파이프라인이 전체 교체. 수동 메모는 article_annotations.user_memo에
- **replace_body**: delete all → append all (전체 replace). 비원자적
  - list: pagination (page_size=100, cursor 반복)
  - delete: 순차
  - append: 100개 이하 chunk 단위
- **payload_hash 갱신**: properties + body 둘 다 성공 후에만. property 실패 → body 미시도. body 실패 → hash 미갱신 → 다음 run에서 full replace 복구
- **nullable 처리**: nullable=true + None → property 생략 (Notion 기본값). nullable=false + falsy → 빈 문자열/빈 리스트 fallback

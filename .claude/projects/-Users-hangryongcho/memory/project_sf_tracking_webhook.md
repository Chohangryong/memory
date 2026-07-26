---
name: project-sf-tracking-webhook
description: "SFTRACKINGLITE 웹훅(RoutePushService) 전환 — 아누아 홍콩 실데이터 분석으로 상태 매핑 규칙 재정의, 스펙 문서 docx 산출"
metadata: 
  node_type: memory
  type: project
  originSessionId: 070f2fe2-e79e-44b1-a99d-e00c1d3047db
  modified: 2026-07-26T12:00:04.217Z
---

# SF Tracking 웹훅 전환 상태매핑 (2026-07-23~26 세션)

**리포**: `~/Documents/Playground/SFTRACKINGLITE` (Chohangryong/SFTRACKINGLITE). 단일파일 원형은 `~/Desktop/files/sf_tracking_tool.py`(_map_status).

**배경**: 기존 lite_status_mapper.py는 조회 API 기준 `(opCode, firstStatusCode, secondaryStatusCode)` 3-튜플 콤보 + 중국어 remark 분기. 회사 시스템이 웹훅(순펑 RoutePushService) 방식으로 신규 개발되어 수신 데이터 기준으로 규칙 재정의함.

**분석 데이터**: `~/Downloads/아누아홍콩 전체.xlsx` — 3,865행/90송장(2026-06-25~07-15). 컬럼: MAIL_NO, OP_CODE, ACCEPT_TIME, REMARK, REASON_CODE(전부 빈값). first/secondaryStatusCode 미수신.

**확정 결론 (기존 표기값 유지: SHIPPED/ARRIVED/COLLECTED/EXCEPTION/NO_ROUTE/UNKNOWN_OPCODE)**:
- opCode 단독 분기: 50/54/30/31/36/302/305/44/634/204→SHIPPED, 125/642→ARRIVED(픽업대기), 80/8000→COLLECTED(종결), 70→EXCEPTION
- **80은 remark 분기 폐지, 무조건 COLLECTED** — 웹훅은 사물함 투입이 125로 분리 수신(5건 전부 125→수시간 뒤 80 검증됨)
- **70은 구 규칙(SHIPPED)과 반대로 EXCEPTION** (사물함 만실/수취인 부재)
- 중복 75%(평균 4회 재수신) → 멱등키 `MAIL_NO+OP_CODE+ACCEPT_TIME+REMARK`, 정렬은 acceptTime(도착순서 신뢰금지), COLLECTED 후 역행금지
- reasonCode 예외조합: 8000+6=분실, 8000+2=폐기, 70+46=취소, 70+83/85=자가픽업전환, 99+2=반송, 33+83/85=픽업대기
- ARRIVED 후 80 수신율 12%뿐 → N일 경과 자동종결/알림 정책 미결
- 305는 공식표 미등재(홍콩 확장 코드 추정), remark상 SHIPPED

**공식 문서** (open.sf-express.com, 로그인 없이 열람 가능하나 JS SPA라 WebFetch 불가→Chrome 필요):
- RoutePushService 스펙: https://open.sf-express.com/Api/ApiDetails?level3=404&interName=路由推送接口-RoutePushService
- opCode 전체표(~150개): https://open.sf-express.com/developSupport/734349?activeIndex=589678
- firstStatusCode 자체가 상태분류(1=집하,2=운송중,3=배송중,4=수령,11=픽업대기,13=재배송대기) → SF와 협의해 필드 수신되면 opCode 매핑 불필요(1안). 단 반송/전송은 1급코드 "-"라 opCode 폴백 필수

**산출물**: `~/Downloads/SF_웹훅_상태처리_스펙.docx` (1안 firstStatusCode / 2안 opCode 매핑, 개발자 전달용). 생성 스크립트는 scratchpad(휘발).

**커밋**: SFTRACKINGLITE `4fdca04` docs/LITE_SF_STATUS_MAPPING_TABLE_ko.md (기존 조회API 매핑표 문서, 사용자/Codex 작성분). ⚠️ 원격에 병행 작업 존재 — `1a7e2f3` "Externalize lite mapping rules and refresh packaging" 등. 웹훅 매퍼 구현 시 이 외부화 작업과 충돌 여부 먼저 확인.

**다음 할 일**: 스펙 개발자 전달(완료 추정), 웹훅 매퍼 코드 구현 여부 미정(사용자가 "코드작업 불필요, 개발자 분기용"이라 함).

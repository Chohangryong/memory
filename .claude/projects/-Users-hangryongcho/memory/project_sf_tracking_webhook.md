---
name: project-sf-tracking-webhook
description: "SFTRACKINGLITE 웹훅(RoutePushService) 전환 — 아누아 홍콩 실데이터 분석으로 상태 매핑 규칙 재정의, 스펙 문서 docx 산출"
metadata: 
  node_type: memory
  type: project
  originSessionId: 070f2fe2-e79e-44b1-a99d-e00c1d3047db
  modified: 2026-07-26T12:23:19.487Z
---

# SF Tracking 웹훅 전환 상태매핑 (2026-07-23~26 세션)

**리포**: `~/Documents/Playground/SFTRACKINGLITE` (Chohangryong/SFTRACKINGLITE). 단일파일 원형은 `~/Desktop/files/sf_tracking_tool.py`(_map_status).

**배경**: 기존 lite_status_mapper.py는 조회 API 기준 `(opCode, firstStatusCode, secondaryStatusCode)` 3-튜플 콤보 + 중국어 remark 분기. 회사 시스템이 웹훅(순펑 RoutePushService) 방식으로 신규 개발되어 수신 데이터 기준으로 규칙 재정의함.

**분석 데이터**: v1=`~/Downloads/아누아홍콩 전체.xlsx`(3,865행/90송장, 06-25~07-15). **v2=`~/Downloads/아누아홍콩_TRACKING_260724.xlsx`(36,386행/781송장 전수, 06-25~07-24, 회사 시스템 수신 테이블 덤프)**. REASON_CODE 전부 빈값·first/secondaryStatusCode 미수신은 v2에서도 동일. v2 REMARK는 영문 위주.

**확정 결론 (기존 표기값 유지: SHIPPED/ARRIVED/COLLECTED/EXCEPTION/NO_ROUTE/UNKNOWN_OPCODE)**:
- opCode 단독 분기: 50/54/30/31/36/302/305/44/634/204→SHIPPED, 125/642→ARRIVED(픽업대기), 80/8000→COLLECTED(종결), 70→EXCEPTION
- **80은 remark 분기 폐지, 무조건 COLLECTED** — 웹훅은 사물함 투입이 125로 분리 수신(5건 전부 125→수시간 뒤 80 검증됨)
- **70은 구 규칙(SHIPPED)과 반대로 EXCEPTION** (사물함 만실/수취인 부재)
- 중복 75%(평균 4회 재수신) → 멱등키 `MAIL_NO+OP_CODE+ACCEPT_TIME+REMARK`, 정렬은 acceptTime(도착순서 신뢰금지), COLLECTED 후 역행금지
- reasonCode 예외조합: 8000+6=분실, 8000+2=폐기, 70+46=취소, 70+83/85=자가픽업전환, 99+2=반송, 33+83/85=픽업대기
- 305는 공식표 미등재(홍콩 확장 코드 추정), remark상 SHIPPED

**v2 전수 재검증 결과 (2026-07-26, 781송장 — 회사 시스템 구축용 스펙 v2 산출)**:
- 배경 변경: 우리 프로그램 대신 **회사 시스템에 구축**됨. 회사 시스템 매핑이 약해 스펙 문서로 지원하는 역할.
- 80=무조건 COLLECTED **확정**: 사물함/픽업점 80 322건 100% 125 선행, 중앙값 7.8h 후 수신(=고객 수령 시점)
- **v1 "125→80 도달 12%" 정정 → 실제 87%(327/374)**. 미도달은 전부 데이터컷 직전(7/21~24) 진행중 건 = 관측기간 착시. 자동종결 불필요, N일(5~7일) 지연알림으로 충분
- 8000: 690/690 전건 80 동반(단독 0), 시간차 중앙값 0h(동시), 10건은 80보다 선행 → acceptTime 정렬 근거
- **신규 실수신 opCode 4개 (v1 매핑만 쓰면 UNKNOWN, 월 ~70송장)**: 33=지연·보류 안내(EXCEPTION, 70과 겹침 2건뿐), 126=사물함 회수·픽업코드 무효(EXCEPTION, 38송장 중 37건 이후 125 재투입→해제 로직 필수), 99=전송중, 517=전송신청(둘다 EXCEPTION)
- EXCEPTION 해제 로직 필수: 70/33/126/99 후 대부분 정상종결(70 보유 33송장 중 29건 8000 도달)
- 중복률 74.4% (v1 75%와 일치)

**공식 문서** (open.sf-express.com, 로그인 없이 열람 가능하나 JS SPA라 WebFetch 불가→Chrome 필요):
- RoutePushService 스펙: https://open.sf-express.com/Api/ApiDetails?level3=404&interName=路由推送接口-RoutePushService
- opCode 전체표(~150개): https://open.sf-express.com/developSupport/734349?activeIndex=589678
- firstStatusCode 자체가 상태분류(1=집하,2=운송중,3=배송중,4=수령,11=픽업대기,13=재배송대기) → SF와 협의해 필드 수신되면 opCode 매핑 불필요(1안). 단 반송/전송은 1급코드 "-"라 opCode 폴백 필수

**산출물**: v1=`~/Downloads/SF_웹훅_상태처리_스펙.docx`(07-23). **v2=`~/Downloads/SF_웹훅_상태처리_스펙_v2.docx`(07-26, 섹션0 "v1 대비 변경 요약", 실수신 19개 opCode 매핑, 5-3 근거표 781송장 전수 수치, 7장 노출분리구조[고객=배송중 통합·내부=EXCEPTION+3일 미해제 알림, EXCEPTION 91송장 74% COLLECTED 도달·중앙값 0.9일 근거], 8장 의사결정 6항목[8-1 분실·폐기 reasonCode 빈값 리스크 최우선, 8-2 firstStatusCode 협의, 8-3 지연알림 N일, 8-4~6 기본값 운영])**. **v3=`~/Downloads/SF_웹훅_opCode_매핑표_v3.docx`(07-26, "opCode만 유효" 전제 최종 전달본 — 판정 의사코드, flat 매핑표 34행[실수신19+예비, 상태별 색상], 한계 3건[분실·폐기 감지불가/반송·전송 구분불가/취소·자가픽업 구분불가], 운영규칙·노출분리 요약, reasonCode/firstStatusCode는 향후확장 참고로 강등)**. 생성·분석 스크립트는 scratchpad(휘발).

**커밋**: SFTRACKINGLITE `4fdca04` docs/LITE_SF_STATUS_MAPPING_TABLE_ko.md (기존 조회API 매핑표 문서, 사용자/Codex 작성분). ⚠️ 원격에 병행 작업 존재 — `1a7e2f3` "Externalize lite mapping rules and refresh packaging" 등. 웹훅 매퍼 구현 시 이 외부화 작업과 충돌 여부 먼저 확인.

**다음 할 일**: v2 스펙 회사 시스템 개발자 전달, firstStatusCode 수신 SF 협의 여부 확인. 웹훅 매퍼 코드 구현은 불필요 확정(회사 시스템에 구축됨, 우리 프로그램 미사용).

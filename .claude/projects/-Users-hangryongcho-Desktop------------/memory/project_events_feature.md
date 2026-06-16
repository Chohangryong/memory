---
name: project_events_feature
description: "행사/이벤트 메뉴(/events) — 지도+목록 통합 UX(네이버식)·검색·현재위치·Kakao JS키 함정·서울 공공API 적재·검색어 저장 DB. \"행사\"·\"이벤트\"·\"/events\"·\"지도 통합\"·\"바텀시트\"·\"Kakao JS키\"·\"ERR_BLOCKED_BY_ORB\"·\"event_searches\"·\"현재 위치\" 첫참조."
metadata: 
  node_type: memory
  type: project
  originSessionId: 22b310a0-fa75-473a-ac8f-a8dcefd24948
---

부모로 "행사/이벤트" 메뉴(/events). FEATURE_EVENTS 게이트(Vercel Preview dev=1·운영 미설정). dev DB(lqqc) 적재. **2026-06-16 구현 완료 dev배포(지도+목록 통합·검색·현재위치). 운영(main) 미반영=오너 결정.**

## 핵심 설계 통찰 (보존)
- **공공 행사 API에 육아·영유아 전용 필터 없다** → 실시간 프록시❌, **배치 적재 + 부모로 자체 육아 태깅**⭕ (lib/events/tagging.ts).
- 컨셉 = "육아 행사 목록"이 아니라 "그 집 아이(나이·지역) 동반 가능 행사" 개인화(혜택매칭 child_age × user_child 월령 적용 가능). 연령매칭 정밀화(USE_TRGT 파싱)는 미착수 백로그.
- ⚠️샌드박스 함정: 외부 API curl은 **foreground에서만**(background task 네트워크 멈춤). 단건 짧은 명령으로.

## 데이터 소스·적재
- seoul_culture(culturalEventInfo OA-15486) 3915건·좌표100%, seoul_reservation(ListPublicReservationEducation OA-20497) 365건, tour_api(KorService2 searchFestival2, 키 없음 0). 키=.env.local SEOUL_OPENAPI_KEY·TOUR_API_KEY(값 미출력).
- 적재 경로: **GET** `/api/cron/events-ingest` (Authorization: Bearer CRON_SECRET, **GET임 — POST 405**). GitHub Actions cron(Vercel 2슬롯 소진 회피, .github/workflows/events-ingest.yml).
- 화면 노출: is_hidden=false AND (end_date>=today OR NULL) AND (is_pregnant OR is_infant OR is_family).
- ⚠️seoul_reservation X/Y는 **TM128 아님=이미 WGS84 위경도**(X=경도126.97·Y=위도37.57). adapter TODO 오인→좌표 미적재→지도 누락이었음. toCoord로 서울범위(lat37~38·lng126~128) 검증 후 lat=Y·lng=X.

## 🔴 Kakao 지도 SDK 키 함정 (재사용·중요)
- Kakao 지도 JS SDK는 **JavaScript 키** 필요. REST API 키 넣으면 `ERR_BLOCKED_BY_ORB`(Chrome) + SDK가 `{"errorType":"AccessDeniedError","message":"appKeyType is REST_API_KEY. but expected [NATIVE_APP_KEY, JAVASCRIPT_KEY]"}` 반환.
- 진단: `curl "https://dapi.kakao.com/v2/maps/sdk.js?appkey=KEY&autoload=false" -H "Referer: https://도메인/"` → JS코드(window.kakao=) 정상 / AccessDeniedError=키종류틀림 / domain mismatched=플랫폼 도메인 미등록(별개 문제).
- env=NEXT_PUBLIC_KAKAO_MAP_API_KEY(빌드타임 인라인→교체 후 **재배포 필수**, vercel redeploy 충분). 현재 Preview(dev)만 등록=운영 머지 시 **Production에 JS키+FEATURE_EVENTS 추가 필요** + Kakao 플랫폼에 bumoro.kr 도메인 등록.
- Kakao Developers→앱 키에 4종(네이티브/REST/JavaScript/Admin), 라벨 확인 필수(형식 유사).

## UI: 지도+목록 통합(네이버식, 2026-06-16)
- 목록/지도 토글 폐지 → 지도 풀 배경 + 드래그 바텀시트 3단 스냅(top비율 펼침0.12/중간0.52/접힘0.86, pointer이벤트).
- 시트 헤더: 검은 검색바(var(--ink)) + 필터칩6(전체/영유아/임산부/가족/무료/유료) + "이 지도 영역 N건" + 정렬(가까운순=지도중심 유클리드/날짜순).
- 지도 idle→getBounds→onBoundsChange. **네이버식: 지도엔 핀 전부, 목록만 bounds 필터**(검색 시 영역 무시·전체결과). 마커 클러스터러(minLevel6). 핀클릭→selectedId→카드 하이라이트+scrollIntoView. 카드탭=상세이동(단방향).
- 좌표없는 행사=목록하단 "위치 미정 N건" 접이식. 현재위치 FAB(◎ geolocation·HTTPS필수·권한거부 토스트·localhost는 Kakao 미등록이라 안뜸).
- 파일: components/events/{events-client(상태허브),events-map-view(window.kakao any+eslint-disable),events-bottom-sheet,event-card(selected prop)}. event-pin-sheet 삭제(시트가 대체). lib/events/region-map.ts에 SIDO_CODE_TO_NAME·SIGUNGU_CODE_TO_NAME(위치표시 "서울 강서구").

## 검색어 저장 DB
- event_searches(마이그 20260616000005): user_id(auth FK nullable·탈퇴 SET NULL)·query·result_count(0=미충족수요)·sido/sigungu·created_at. RLS INSERT anon/authenticated WITH CHECK(user_id IS NULL OR =auth.uid())=위조방지, SELECT 정책없음=service_role 분석전용.
- saveEventSearch 액션(app/events/actions.ts): 디바운스 확정 시 1회(키스트로크마다 X·lastSavedRef 중복방지)·실패 조용히 무시.

설계서 SSOT=docs/events/2026-06-15-events-feature-design.md. API명세·생애주기코드=[[reference_govt_welfare_apis]]. 게이트 패턴=[[project_checklist_v2_analysis]] 동형. [[project_nationwide_open]].

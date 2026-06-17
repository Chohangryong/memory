---
name: project_events_feature
description: "행사/이벤트 메뉴(/events) — 지도+목록 통합 UX(네이버식)·검색·현재위치·Kakao JS키 함정·서울 공공API 적재·검색어 저장 DB. \"행사\"·\"이벤트\"·\"/events\"·\"지도 통합\"·\"바텀시트\"·\"Kakao JS키\"·\"ERR_BLOCKED_BY_ORB\"·\"event_searches\"·\"현재 위치\" 첫참조."
metadata: 
  node_type: memory
  type: project
  originSessionId: 22b310a0-fa75-473a-ac8f-a8dcefd24948
---

부모로 "행사/이벤트" 메뉴(/events). FEATURE_EVENTS 게이트. **✅2026-06-17 운영(bumoro.kr) 공개 완료**(운영DB pfwr 마이그3+ingest 4278건+Production env+Kakao 도메인). dev=lqqc·운영=pfwr 둘 다 적재. 통합UX·검색·좋아요·인기순·지역필터·현재위치·새 로고 전부 운영반영.

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

## 2026-06-16~17 UX 대폭 개선 (전부 dev 배포·실측 완료, 운영 미반영=오너)
- ⚠️**지도=시트 위 가시영역만 차지**(sheetTop을 client로 리프트→mapHeight=sheetTop-56, EventsMapView relayout+bounds 재계산 rAF throttle). **이전 버그: 지도 풀스크린이라 getBounds가 시트 가림영역까지 포함→"지도 영역 N건"≠보이는 핀(14건인데 핀3개). 지도를 가시영역만으로=카운트 일치.** 사용자가 "지도 사이즈 줄여라"의 근본해법.
- ⚠️**시트/카드 배경 투명 버그**: var(--surface) **미정의 변수**(globals.css 없음)→투명(rgba 0,0,0,0)→다크모드 지도 비침. **실제 배경 변수=var(--card)**(라이트#FFF/다크#1E1E1E). events 전체 --surface→--card 교체.
- 다크모드 지도 타일: Kakao 네이티브 다크 미지원→.dark .bm-map-tiles{filter:invert(0.9) hue-rotate(180deg)}(globals.css). ⚠️Playwright headless는 GPU filter 못잡음(밝게 보임)→실기기 확인.
- 검색바: 검은바(라이트#1a1a1a) 사용자반려→라이트=var(--gray-100)/다크=#2c2c2c, 텍스트·placeholder·✕=모드변수(흰색 하드코딩 제거). placeholder "행사 검색"(기관 제거). 한글 IME 마지막글자 중복=controlled value 재설정 버그→**uncontrolled(defaultValue+ref, clear는 ref.value='')**.
- **좋아요+인기순**: event_likes(마이그 20260617000001, **PK(event_id,user_id)=중복방지**, RLS 공개SELECT·authenticated 본인 INSERT/DELETE). EventCard 우측 하트(🤍/❤️)+카운트, 옵티미스틱 토글(events-client onToggleLike, ensureClSession=익명세션 자동, 실패 롤백, Link내부라 preventDefault). fetchEvents가 event_likes 집계(like_count·liked, in() 조회 후 클라 count). 정렬 가까운순/날짜순 폐지→**인기순(like_count desc·동률 날짜순) 고정**, "🔥 인기순" 라벨.
- **지역 필터**: 서울25구 커스텀 드롭다운(native select 폐지=좌측정렬·focus글로우 문제). 칩순서 **전체→📍지역→영유아/임산부/가족/무료/유료**. '전체'칩=지역도 리셋(onChipChange 래퍼). 옵션=**실데이터 있는 구만**(availableGus=events distinct sigungu∩SEOUL_GU_CENTER). 선택→SEOUL_GU_CENTER[구] 좌표로 지도 panTo+setLevel(flyTo prop). 드롭다운 메뉴=**createPortal(document.body)**+버튼 getBoundingClientRect fixed(칩 가로스크롤·시트 transform 클립 회피). chipStyle 공통헬퍼·RegionOption.
- 현재위치 FAB ◎→**"📍 내 위치" pill**(흰배경·sky테두리·강한그림자, locating/권한거부 텍스트통합).
- ⚠️Playwright select/input 값변경=네이티브 setter+dispatchEvent. dev게이트 통과상태(쿠키). ?v=N 캐시우회. 라이트강제=다크토글 클릭. createClient 경로 lib/supabase/client.

## ✅ 2026-06-17 운영(bumoro.kr) 공개 완료
- 운영DB(pfwr) 마이그3 적용(events 20260615000008·event_searches 000005·event_likes 20260617000001, supabase link pfwrniqytvnlkhphnyid→query→link 복귀 lqqc) + ingest 4278건(seoul_culture3915·reservation363, 좌표100%).
- Production env: NEXT_PUBLIC_KAKAO_MAP_API_KEY(JS키)·FEATURE_EVENTS=1·SEOUL_OPENAPI_KEY·TOUR_API_KEY. ⚠️**함정: 운영 env에 SEOUL_OPENAPI_KEY 없어 첫 ingest 200 success인데 0건**(adapter 키없음 건너뜀)→키추가+vercel redeploy(런타임 env 반영)+재적재로 해결.
- 운영 ingest 수동=`gh workflow run events-ingest`(workflow_dispatch, .github/workflows/events-ingest.yml이 bumoro.kr 호출+GH Secret CRON_SECRET). 매일 KST06 자동.
- main머지(dev 전체)→push→운영배포. Kakao bumoro.kr 도메인 등록됨(지도 정상 로드 확인). 운영 스모크 OK(게이트통과·지도·카운트일치·좋아요).
- ⚠️dev→main 전체머지라 cl(준비물) 코드도 딸려옴=운영行(게이트로 보호).

## ✅ 새 헤더 로고 (2026-06-17 운영반영)
- nav.tsx 로고 SVG아이콘+"부모로"텍스트 → **부모로 워드마크 이미지**(public/bumoro-wordmark.png 라이트·bumoro-wordmark-dark.png 다크). 원본 PNG 흰배경→투명+여백trim(Pillow, lum<110 글자→다크용 흰색변환). class dark:hidden/hidden dark:block 분기. height26. dev→main 운영반영.

설계서 SSOT=docs/events/2026-06-15-events-feature-design.md. API명세·생애주기코드=[[reference_govt_welfare_apis]]. 게이트 패턴=[[project_checklist_v2_analysis]] 동형. [[project_nationwide_open]].

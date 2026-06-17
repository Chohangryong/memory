---
name: project_chaeggyeobogi
description: "준비물(구 챙겨보기·구 체크리스트 v2) — 신기획안 S-A~S-E **dev 배포완료(2026-06-15)**: 정보 블록렌더·메모탭·시기 타임라인 셸·챙김/고정(got/pin)·챙겨보기→준비물 라벨. 이전 S0~S5(챙겨보기)는 그 위 토대. \"준비물\"·\"챙겨보기\"·\"메모 탭\"·\"시기 타임라인\"·\"got/pin\"·\"고정한 소식\"·\"새소식N\"·\"정보 블록\"·\"검색 자동완성\"·\"내 정보 모달\"·\"cl_user_favorite\"·\"cl_user_memo\"·\"/cl\"·\"즐겨찾기\"·\"내 준비물\"·\"선배맘 뱃지\"·\"인기순 RPC\"·\"산모회복\"·\"익명 저장\"·\"loading.tsx\"·\"뷰 복원\"·\"sticky 헤더\"·\"카드 클릭 영역\"·\"고정하기\"·\"새 소식 배지\"·\"엑셀 추출\"·\"엑셀 업로드\"·\"AI 가이드\"·\"ADMIN_EMAILS\"·\"어드민 업로드\"·\"내 정보 출산후\"·\"fetchClNewsCountByItem\" 요청 시 첫참조."
metadata: 
  node_type: memory
  type: project
  originSessionId: 0eeec310-a927-4870-9a55-58a7caf4d2b8
---

체크리스트 v2(`/cl`)를 **클로드 디자인 아티팩트 "챙겨보기 ✨"**로 재설계(2026-06-13~14). 오너 결정=**v2 수정**(재구축 아님). 사용자–항목 축을 **완료체크/진행률 → 즐겨찾기(항목 구독)**로 대체, **단일 통합 피드**(검색·필터칩4·다중선택 담기)로 셸 전환.

> ⚠️ **2026-06-17 운영 상태**: 운영DB(pfwr)에 cl 마이그18개+콘텐츠시드45항목 적용 완료, cl 코드도 main(운영) 있음. **단 FEATURE_CHECKLIST_V2 미설정=운영 비공개("📋 준비물 준비 중")**. 오너가 events 운영공개하며 cl도 "올려" 했다가 "갈 곳이 없어, 비공개로" 지시→FEATURE_CHECKLIST_V2 제거+재배포로 비공개 복귀. **공개는 FEATURE_CHECKLIST_V2=1 Production + 재배포만 하면 즉시**(DB·시드·코드 준비됨). 커뮤니티는 FEATURE_CL_COMMUNITY 미설정=보류(출시검증 잔여, /cl/community→/cl 리다이렉트). cl 마이그 운영 적용=supabase link pfwr→`ls migrations|grep _cl_|_funnel_cl|sort` for-loop→link 복귀.

> ✅ **신기획안 대응 완료 — 준비물 S-A~S-E dev 배포(2026-06-15, push 35018f6, dev.bumoro.kr `<title>준비물`·/cl 200 실측·운영 무손상).** 결정=재구축 아닌 **확장**(테이블/라우트/플래그/event_name/식별자 불변, 한글 라벨만 변경). 프로토 `bumoro_chaegyeo.html`·SSOT `docs/superpowers/specs/2026-06-14-준비물-design.md`. 범위 제외=뉴스·브랜드·꿀정보(deals).
> - **S-A 마이그·모델**: stage 6→8(prep/pregnancy 추가, code `[a-z0-9_]+`)·category 7CODE(category_label에 CODE저장)·정보 하이브리드(summary필수+sources+body:Block[] 6종 qa/section/compare/table/steps/callout 닫힌 union, jsonb=마이그0)·cl_user_memo·cl_user_favorite got/pin·timing_text/search_kw 컬럼.
> - **S-B 정보 블록**: 항목 정보탭=6종 블록 렌더러(InfoBody·CompareBlock 추출·table sticky·텍스트전용 raw HTML 0)·구 sections/compare는 lift로 시각회귀0·어드민 body JSON.
> - **S-C 메모 탭**: storyEnabled 무관 항상노출·saveMemo(빈→DELETE·upsert·익명)·MEMO_MAX_LEN 500↔CHECK·initialMemo·debounce 600ms.
> - **S-H 홈 셸 재구성**: 카테고리그룹→**시기(stage) 타임라인 섹션**(dot·지금·접기·시기별 모두선택)·showAll(전체시기/⭐/검색 횡단)·**fitOk 숨김**(분만/수유 비매칭, ⚠️favOnly 뷰엔 미적용=담은항목 유지, 17b9e46)·검색 자동완성(splitHighlight XSS-safe)·카테고리 OR 바텀시트·내 정보 통합모달(시기/개월/분만/수유+stageHint)·lib/cl/home.ts·cl-search-autocomplete/cl-category-sheet/cl-myinfo-sheet. ClPillRow/ClFilterSheet 제거.
> - **S-D 챙김·고정**: favorites Set→`Map<FavState>` 승격·got(✓ dim)/pin(📌 "고정한 소식" 섹션·전시기 횡단)·"✓ 챙긴것" 칩(favOnly)·새소식N(cl_post 재소싱·전역 lastSeen·0데이터 미표시)·cl_got 계측(funnel CHECK 16종·on만)·pin⊂fav 불변식·favorite-state.ts.
> - **S-E 제거·라벨**: 📰기사 탭 제거(ItemDetailTab articles→info|community|memo·teamPosts prefetch 보존)·꿀정보 카피 제거·**챙겨보기→준비물**(nav 탭·홈H1·CSV명·사용법시트·coming-soon·metadata)·news '기사→소식'. 식별자/게이트 불변(정적가드 clLabel/clNewsCopy).
> - **마이그 000001~000007 dev DB(lqqc) 영구 적용·검증**(category_normalize는 dev 라벨 매핑→운영 적용 전 운영 distinct 재조회 필수). **이연(마이그 적용 후 dev 수동 E2E)**: 메모 저장·got/pin·새소식N 실동작. **재시드 추적**: 신규 마이그/테이블/컬럼 `13_DB운영_인수인계.md` 등록 follow-up.
> - **정합 검토(서브에이전트 2)**: A=GREEN·B High 1건(fitOk가 담은항목 숨김)→수정. 빌드 GREEN·vitest 553/60파일·tsc0.
> - **✅콘텐츠 시드 45항목 dev DB(2026-06-15 push d1040ce)**: 프로토 `bumoro_chaegyeo.html` `const DB.items` 45건→cl_item(생성기 `scripts/cl/gen_seed_from_prototype.js`·멱등 SQL `supabase/cl_seed_prototype_items.sql`·ON CONFLICT slug). 매핑=stage(planning→prep…2-3y→m24_36)·cat→item_type(admin/medical/supply/action/recovery)·priority must→required·fit→delivery/feeding·**info=summary+Q&A+팁+출처콜아웃**(⚠️sources는 {org,url https필수}라 생략·출처명은 callout info로 보존·**URL 항룡후속**). active45/구test3(checkup/diaper/pump) 비활성(가역). infoFromJsonb=parseClInfo 실패시 null이라 loose 스키마 통과 필수(생성기 clamp). 운영 미적용·재시드 추적대상.
> - **✅전체 시기 콘셉트 = 구현정합 확인**: 프로토 `showAll=allStages||star||search`와 동일·기본 현재시기 스코프/🔭전체시기 전횡단. **빠졌던 scope-note**("지금 OO 시기 보여드리고 있어요→🔭전체 시기 보기") 추가(8d3cb19). selectedStage·setAllStages.
> - **✅S-F 카테고리 색(2026-06-15 push b59be72)**: 미니배지 색축 item_type→7카테고리·globals 토큰 4쌍(vaccine/health/care/life 라/다크)·CATEGORY_STYLES·categoryBadge(cl-item-row·item-detail 재사용)·categoryDisplay(CSV만 — S-H가 select/그룹헤더 제거·cl-category-sheet가 이미 이모지+라벨)·**대비가드가 라이트 3쌍<3:1 잡아 hex조정**(vaccine#2B8A93·care#C05A82·life#4A8A64≥3.58). item_type enum 동결.
> - **✅S-G 퍼널·정리·게이트(2026-06-15 push 401c714, 개편 마지막 phase)**: dead code saveCheck/SaveCheckArgs/SupabaseClient import 제거(cl_user_check 테이블은 child_slot 재매핑이 써서 drop금지·휴면)·출시게이트 검증(noindex 다크십·정적가드 24그린·cl_got lockstep 코드↔dev CHECK)·13_DB운영_인수인계 **§9.5 신규객체 추적**(cl_user_memo·got/pin·timing/kw·cl_stage·cl_got·시드).
> - **🏁준비물 S-A~S-G dev 빌드·배포 완료**(593테스트·tsc0·build OK). S-I=프로토 45항목 시드 갈음. **운영(main) 미반영**=오너 결정(⚠️nav "준비물" 공유코드→main 머지 시 운영탭도 준비물이나 연결은 여전히 /checklist v1=라벨↔연결처 정합·출처 URL·콘텐츠 정식화=항룡).
> - 테스트 리포트 `docs/checklist-v2/test-reports/2026-06-15-준비물-S{A,B,C,D,E}-*.html`·플랜 `docs/superpowers/plans/2026-06-14-준비물-S{A,B,C,D,E,F,G,H,I}-*.md`.

> ## ✅ 준비물 dev 폴리시·기획안 정합 (2026-06-15 별세션, push 831c653~e5e78c2·**운영 미반영=오너**)
> 시드 후 dev.bumoro.kr 브라우저 E2E(playwright)로 발견·수정한 UX/정합 일괄. tsc0·593그린·운영무손상.
> - **익명 저장 부트스트랩(831c653)**: 직접진입 익명도 메모/즐겨찾기/got/pin 저장 가능 — `lib/cl/ensure-session.ts ensureClSession`(getUser→없으면 signInAnonymously 멱등)을 cl-client·item-detail-client 마운트에 추가. 가입 시 updateUser/linkIdentity가 같은 user_id 승계. **검증=[CLUP]ok·DB영속·reload "저장됨". "작성 중…"은 슬로우타이핑 레이스(테스트 아티팩트)지 버그 아님(외과적 디버깅으로 규명).**
> - **loading.tsx(`/cl/i/[itemId]`, a17db10)**: 동적라우트 로딩경계 부재→SSR(콜드2s) 완료까지 화면멈춤·back 무응답을 즉시 스켈레톤으로. 웜 TTFB 0.6→0.09s. [[project_tab_responsiveness]] "동적라우트=loading 경계" 동일근거.
> - **뷰 복원(14f4b4f)**: 카드 상세 갔다 뒤로 오면 cl-client 재마운트로 필터·스크롤 리셋 → `sessionStorage "bm_cl_view"`(allStages/favOnly/category/manualStage/scrollY) 저장·복원, 항목 렌더 후 1프레임 뒤 scrollTo.
> - **카드 클릭 영역 확대(90b3efe)**: 제목 span만 Link→이모지+제목+태그+요약 **전체 Link**(좌우 버튼 형제=중첩Link 회피).
> - **시기 헤더 잘림(90b3efe)**: label flex:1에 `minWidth:0` 부재→"지금" 배지 붙으면 좁은폰서 모두선택/▼ 잘림 → minWidth:0+overflow.
> - **시기 헤더 sticky(d59fe7e)**: 비-sticky MVP→`position:sticky top:64`(nav 65px 아래)·z9·하단보더. 스크롤 시 현재 시기 헤더 상단 고정.
> - **내 정보 시기=임신준비/임신중/출산후(90b3efe)**: legacy `pre_birth`("출산직전") 노출+"출산 후" 묶음 부재로 기획안과 달랐음 → prenatal에서 pre_birth 제외+"👶 출산 후" 버튼(개월수로 세분·postnatal stage 선택 시 활성). cl-myinfo-sheet.
> - **"즐겨찾기"→"내 준비물" 라벨(d59fe7e)**: 프로토 라벨. 칩·담기버튼·CTA·서브라인·토스트·사용법. **식별자(cl_user_favorite·saveFavorite) 불변.** clHelpSheet 테스트 "내 준비물"로 갱신.
> - **고정한 소식 재설계(e5e78c2)**: 작은헤더+풀카드→**강조 박스**(warning-soft→sky-soft 그라데이션·sky보더·16px둥근)+**컴팩트 행**(38px아이콘타일+이름+📌해제)+**"새 소식 N" 코랄배지**(`fetchClNewsCountByItem` 신규=fetchClNewsCount의 항목별=cl_post_tag→cl_post gt lastSeen). **고정항목은 시기 목록서 제외**(중복방지·stageGroups favOnly 필터). 프로토 pin-sec 동형. 검증=박스 gradient·컴팩트행·unpin.
> - **☆/📌 세로 스택(e5e78c2)**: 카드 우측 즐겨찾기·고정 버튼 좌우 한줄→세로(flexDirection column). 검증=📌위/★아래 vertical.
> - **고정하기(📌)=내 준비물 뷰에서만**(프로토 `inFav=filters.star` 확정): 일반 목록엔 안 보이는 게 **의도**(핀+고정한소식이 같은 뷰라야 즉시 피드백). cl-item-row `favView && onTogglePin`. **체크박스(카드 앞 선택)=현재(selectMode만) 유지 결정**(프로토는 상시노출이나 ☆/📌/✓ 과밀 회피).
> - **엑셀 추출·업로드 인계**: 어드민 일괄업로드=**`/admin/cl-items/upload`**(파서 `lib/cl/excel-parse.ts`·헤더 `CL_EXCEL_HEADERS` 17개·`worksheets[0]`·헤더이름기준 **순서무관**·slug UPSERT·행별검증·⚠️검증일은 텍스트 YYYY-MM-DD=날짜형셀 거부·카테고리 가운뎃점 `·` 정확히). **관리자=`ADMIN_EMAILS` env(쉼표)·`lib/admin.isAdminEmail`, hrocho2@gmail.com 이미 등록.** 산출(로컬·미커밋)=현재45항목 추출 `docs/checklist-v2/준비물_현재항목.xlsx`(코드→라벨·읽기순서·시트2 입력규칙·재업로드 정합)·`준비물_엑셀_AI가이드.md`(상대 AI용 컬럼/허용값/함정)·생성기 `scripts/cl/export_cl_items.js`·`gen_upload_template.js`. **Gmail `create_draft`=첨부 미지원→본문만**.
> - **다차원 리뷰 개선 25건 전부 반영(push 1745e7c~4fe73d8, E2E 재검증)**: `cl-improvement-review` 워크플로우(32에이전트·5차원 병렬+발견별 적대검증, 후보27→확인25). 주요: 인페이지 헤더 **비-sticky화**(글로벌 nav h-16·시기헤더 레이어 충돌 해소 — 시기헤더만 `top:64` sticky)·**고정한 소식 박스를 빈상태/필터 분기 밖으로**(소스=fitItems 모수·`!gotOnly` 게이트·검색/필터로 목록 0건이어도 유지)·**고정 시 카드가 시기목록서 안 사라지게 dedup 제거**(사용자 보고 버그·프로토 renderList는 pin 미제외=양쪽 노출)·카드 ☆/📌 36px 타일·⏰ 골드칩·접기/전체시기/검색 a11y(role·aria-label·tablist/aria-selected)·바텀시트 `role=dialog`+Esc·빈결과 '전체 보기' 리셋·`@keyframes pulse` 추가(스켈레톤 정지 해소)·상세 SSR fav/memo `Promise.all`·새소식 2쿼리체인→`fetchClNewsCountByItem` 단일통합(distinct total+per-item). **+후속2: `?child` dead param 제거·`fetchClFeed` itemId/viewerId 주입(slug 재조회·getUser 중복 제거).** E2E 9항목+엣지 PASS·스모크 200·tsc0·593그린. ⚠️채택 안 한 거짓양성2: child_slot 추가(설계상 자녀무관 유지)·등.

<details><summary>이전(챙겨보기 S0~S5, 준비물 토대) — 펼치기</summary>

**SSOT 문서(레포 내, 참조 필수):**
- 설계: `docs/superpowers/specs/2026-06-13-챙겨보기-design.md` (D1~D10 결정·갭맵·데이터모델)
- 아티팩트 캡처: `docs/checklist-v2/2026-06-13_챙겨보기_신규콘셉트_캡처.md`
- 플랜: `docs/superpowers/plans/2026-06-14-챙겨보기-S{1,2}-*.md`, `2026-06-13-챙겨보기-S0-foundation.md`
- 테스트 리포트: `docs/checklist-v2/test-reports/2026-06-1{3,4}-챙겨보기-S*.html`

**진행(전부 dev 브랜치·dev DB lqqc·운영 무손상, main merge 안 함):**
- **S0 완료**: 마이그 20260613000001 `cl_user_favorite`(own-row RLS·익명허용·UNIQUE) · 000002 `cl_item.priority`(required/optional)+`item_type='recovery'`(산모회복) · 000003 funnel CHECK +3종(cl_favorite/cl_news_view/cl_export). lib/cl 타입 recovery.
- **S1 완료**: 어드민 `/admin/cl-items` priority 라디오·산모회복 select·엑셀 `필수여부` 16열·export 라운드트립. dev.bumoro.kr E2E 통과.
- **S2 완료(2026-06-14 push 49b0ba5)**: `/cl` 단일피드 — progress 폐기·`annotateMatch`(✨전체노출+매칭, 거름망 숨김 폐기)·`saveFavorite`/`saveFavoritesBulk`·검색·필터칩4·다중선택·`cl_stage` 5단계(m12_24·m24_36)·Nav 라벨 "챙겨보기". **dev.bumoro.kr 브라우저 E2E로 디자인·프로세스 아티팩트 일치 실측**(☆토글 DB insert/delete·다중담기 DB n=5·필터·검색).
- **S3 완료(2026-06-14 push 7f6f87f)**: 항목상세(`/cl/i`) — done CTA→즐겨찾기 CTA·정보/📰기사(team)/커뮤니티(member) 3탭·인기순 RPC `cl_feed_popular`(SECURITY DEFINER·REVOKE·자기반응제외, 마이그 20260614000002)·**선배맘 뱃지 D7**(작성자 자녀연령 **service_role(adminDb) 파생** — user_child own-row RLS라 뷰어가 못 읽음, `N년차`/`예비맘`/null 문자열만 환원=PII가드, hide_senior_badge 토글)·🚩신고("🚩 이 정보가 잘못됐나요?"). dev E2E(3탭·즐겨찾기 CTA DB토글). T7 rate-limit 중단됐으나 작업 완성돼 커밋.
- **S4 완료(2026-06-14 push 02da240)**: 내 소식 `/cl/news` — 즐겨찾기 항목들의 신규 기사·후기 시간순 집계 인앱 피드(발송없음)·읽음=localStorage `bm_cl_news_seen`(첫방문 배지없음·재방문 NEW)·1급 빈상태·`fetchClNews`(favorite×cl_post_tag×cl_post·키셋·빈IN가드)·`assembleFeedItems` export·진입점=홈 헤더 🔔. **⚠️적대검증 blocker→오너결정: 내 소식은 커뮤니티 글 집계라 FEATURE_CL_COMMUNITY에 묶음**(게이트=V2+커뮤니티 둘 다·카드목적지 `/cl/community/p/[postId]`·진입점 communityEnabled 조건). `?tab=story` no-op 폐기. dev E2E 전항목(카드·NEW재방문·빈상태). cl_news_view 퍼널=headless 봇필터로 DB row 안 생김(코드 발화는 확인). 마이그 0건(S0 선등록).
- **회귀검토 완료(2026-06-14)**: cl S0~S3가 기존 구조 무파손(verdict safe·breaker 0). 이번 세션 블라스트반경=공유파일 2개(nav 라벨·funnel 추가)+cl격리. 기존페이지(온보딩/결과/마이/정책/로그인) 코드 무변경·브라우저 실측 정상. cl↔온보딩/마이/인증 결합은 **이전 작업분**(graceful). DB advisors=새 취약점0(기존 anon-auth·service_role 패턴 답습).
- **S5 완료(2026-06-14 push fa2d613)**: 디자인정합·전체받기 — **전체받기=CSV 다운로드**(오너확정, UTF-8 BOM=엑셀호환·신규라이브러리0=exceljs는 어드민전용 모바일번들회피·클라 Blob·lib/cl/export-csv.ts 순수함수·7컬럼·track cl_export)·📥전체받기+❓사용법(바텀시트) 헤더·**거름망 헤더아이콘 제거→본문칩 일원화**(결정A 헤더4아이콘 포화)·산모회복 --purple 하드코딩hex fallback 제거(§6.1 bare var)·다크대비 점검(변경0, 텍스트대비 충분)·ESLint set-state-in-effect 정리(cl 신규분만, feed/write-client는 S2자산 범위밖). dev E2E: CSV BOM 바이트 [239,187,191] arrayBuffer실측·7컬럼·즐겨찾기Y·❓시트·다크렌더. ⚠️blob.text()는 BOM제거하니 검증은 arrayBuffer로.
- **S6~7 남음**: S6 퍼널재정의(cl_check→cl_favorite 의미이전·OMTM·docs/analytics SSOT) / S7 출시게이트(제재차단·배치·카카오락아웃 E2E·운영공개). 오너후속: ✨맞춤vs💗산모회복 --purple 색공유(아티팩트는 직교)·supply/action fallback hex+#fff→--white 전역·⏰리치텍스트(info.deadline_text 콘텐츠필드)·선배맘뱃지 dev실측(회원글 생긴뒤).

**핵심 결정/주의:**
- 다자녀: favorite은 user×item(child_slot 없음). 자녀전환 칩 **유지**(거름망·기준자녀=막내). ✨맞춤 = 비매칭도 노출+배지(아티팩트, v2 숨김 폐기). 시기 5단계 확장(콘텐츠 없으면 빈 시기).
- D10: 라벨만 "챙겨보기", 라우트 `/cl`·플래그 `FEATURE_CHECKLIST_V2`·href `/checklist` **rename 금지**(운영 SSOT·분석 연쇄).
- funnel: DB CHECK는 S0에서 15종이나 코드 allowlist는 S2에서 cl_favorite만 동기화 — cl_news_view/cl_export 발화는 S4/S5에서 allowlist와 함께(미동기 시 isValidEvent 무음드롭).
- ⚠️ 후속버그: ⏰는 deadline_anchor/days 파생만(리치 자유텍스트=info.deadline_text 필드 S3) · "부모님님" 이중 님(닉네임 가드) · cl_user_check 휴면(정식 drop 후속).
- 워크플로우 방식: ultracode. plan/build 모두 워크플로우(코드매핑→초안→적대검증 / 직렬구현→사후검증). 적대 검증이 S0~S2 빌드차단·테스트차단·funnel 비대칭을 매번 선제 적발. dev DB 적용은 linked=lqqc 게이트. 콘텐츠 시드 export 백업(006c70e).
- E2E: dev.bumoro.kr는 2단 게이트(/_dev_login `_dev_auth` + Supabase 어드민 `sb-lqqc-auth-token`). gstack browse 쿠키 임포트(`cookie-import-browser chrome --domain dev.bumoro.kr`, goto 선행 필요, 서버 재시작 시 재임포트). ⚠️ browse 좌표클릭은 작은 버튼(22px ☆) 빗맞힘 → JS .click()로 검증.

</details>

관련 [[project_checklist_v2_analysis]](구 v1 폐기·하이브리드 커뮤니티 설계 배경) · [[reference_bumoro_infra]] · [[feedback_stage_test_html]] · [[project_db_handover]](재시드 추적).

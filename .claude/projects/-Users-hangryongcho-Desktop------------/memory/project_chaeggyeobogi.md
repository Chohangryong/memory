---
name: project_chaeggyeobogi
description: "챙겨보기(구 체크리스트 v2 재설계) — 아티팩트 기반 단일피드·즐겨찾기 전환. S0~S5 dev 완료, S6~7 남음. \"챙겨보기\"·\"즐겨찾기\"·\"단일피드\"·\"cl_user_favorite\"·\"내 소식\"·\"/cl/news\"·\"전체받기 CSV\"·\"선배맘 뱃지\"·\"인기순 RPC\"·\"산모회복\"·\"priority 필수선택\" 요청 시 첫참조."
metadata: 
  node_type: memory
  type: project
  originSessionId: 0eeec310-a927-4870-9a55-58a7caf4d2b8
---

체크리스트 v2(`/cl`)를 **클로드 디자인 아티팩트 "챙겨보기 ✨"**로 재설계(2026-06-13~14). 오너 결정=**v2 수정**(재구축 아님). 사용자–항목 축을 **완료체크/진행률 → 즐겨찾기(항목 구독)**로 대체, **단일 통합 피드**(검색·필터칩4·다중선택 담기)로 셸 전환.

> 🚧 **다음 액션(2026-06-14 /clear 직전 PENDING): 기획자 새 최종 기획안 대응.** 현 S0~S5를 일부/상당 뒤엎어야 할 수 있음. 새 기획안 **미수령** — 받는 즉시: ①정독·캡처 ②현 SSOT(`2026-06-13-챙겨보기-design.md`)+구현과 **델타 대조**(변경/살릴것/버릴것/신규) ③영향·비용·DB 분석 ④뒤엎기 전 계획 제안→승인→워크플로우. **현 S0~S5는 `fa2d613`로 보존(안전 재설계 가능)·운영 무손상.** 상세 인수인계 = `docs/checklist-v2/2026-06-14_챙겨보기_현황_및_신기획안_대응계획.md`.

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

관련 [[project_checklist_v2_analysis]](구 v1 폐기·하이브리드 커뮤니티 설계 배경) · [[reference_bumoro_infra]] · [[feedback_stage_test_html]].

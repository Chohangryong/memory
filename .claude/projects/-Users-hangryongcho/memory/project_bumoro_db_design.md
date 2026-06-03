---
name: project-bumoro-db-design
description: "부모로 DB설계+프론트 MVP (~/Desktop/부모로데이터베이스설계/, Chohangryong/bumoro 리포). bumoro-project와 별개. Supabase+Next.js16. 수기검토 261건 마이그레이션: 1단계 update_url_only 58 + deactivate 61 dev+prod 완료(06-02). 2~5단계(정보수정18·유지13·보류13·신규1) dev+prod 완료(06-03, mig004~007, slug기준 변환됨). ⚠️매칭함정: household_type 하드필터인데 온보딩은 일반/한부모뿐→multi_child 넣으면 매칭0(다자녀는 birth_order_min). income median만 필터됨. dev·prod UUID 상이→slug기준. 백일돌컷=서울아이(양천 거짓), yongsan paused, seongdong-unwed=냉난방비. **금액표시(06-03 A·C·B1):** amount_aggregation per_birth=출생아당합산(의도된설계,flip금지)/per_application단일/range_only. lib/amount.ts mode(exact/capped='최대N'/range/none), amount_text상한키워드검사. parse_breakdown정규식 brittle→명시맵migration백필. A가드레일 dev+PR#1대기(main직접푸시 차단), C(mig008 아이돌봄/재산세 데이터오류→range_only) B1(mig009 첫만남 첫째200/둘째+300 등 7건) dev+prod완료. B2태아수=같은날짜자녀 도출 미착수(per_fetus enum필요)"
metadata: 
  node_type: memory
  type: project
  originSessionId: 7dddfe09-d24f-498c-afa2-e434c75160ba
---

# 부모로 DB설계 + 프론트 MVP

**⚠️ 이 프로젝트는 `~/bumoro-project/` (Chohangryong/bumoro-project)와 완전히 별개입니다.**

- **이 프로젝트:** `~/Desktop/부모로데이터베이스설계/` → 리포 `Chohangryong/bumoro`
- **다른 프로젝트:** `~/bumoro-project/` → 리포 `Chohangryong/bumoro-project` (기존 설계·ADR·GRILL-LOG)

둘은 폴더도 리포도 다르고, 이 메모리는 `부모로데이터베이스설계` 폴더 작업만 기록합니다.

---

## 카드 금액 표시 시스템 (2026-06-03 — A·C·B1 작업)

**문제:** breakdown 없는 정책의 `amount_max`(상한)가 카드에 확정액처럼 맨숫자로 찍혀 **과대표시**. 사용자 지적.

**핵심 설계 사실 (다음 세션 혼동 방지):**
- `amount_aggregation` enum: `per_birth`(출생아당 **합산** — 나이창 충족 born 자녀별 금액 합산, **의도된 설계** spec 2026-05-30, 버그 아님) / `per_application`(child_count 기준 **단일 tier**) / `range_only`("조건별 차등", total=null). ⚠️ 출산축하금을 per_birth→per_application로 "flip"하면 안 됨(설계 되돌림). codex도 확인.
- `lib/amount.ts:resolveAmountDisplay`가 표시 **mode** 반환: `exact`(breakdown매칭/검증된 단일정액) / `capped`(amount_max 상한 추정→**"최대 N"** 강제) / `range`("조건별 차등") / `none`(amount_text). `amountHeadline(mode,total,text,fmt)` 공통 헬퍼. mode 판정은 DB숫자만 아니라 **amount_text 상한키워드(최대·한도·본인부담·차등 등)까지 검사**(min==max라도 "최대 X"면 capped). codex 리뷰 반영.
- `generate_seed.py:parse_breakdown` 정규식이 brittle — "{첫째|둘째}[아]? 숫자 만원"·"셋째/넷째 이상"만 매칭. "둘째 이상"·"첫째·둘째"·"세 자녀"·연령(0세/1세)은 **미매칭** → 자동추출 7건뿐. 나머지는 **명시 맵 migration으로 백필**(codex 권고: 정규식 단독 < 명시 맵 + 검증).

**작업 단계 (A·C·B1 완료 / B2 미착수):**
- **A 가드레일**(코드 `787059b`, 8파일): mode/capped "최대" 라벨. 전 표시면(card·modal·tracking·home) 통일. 테스트38·빌드 통과. → **dev 반영 + PR #1(dev→main) 머지 대기**(main 직접푸시는 안전정책 차단됨). DB변경 없음.
- **C 데이터오류**(mig `008`): 아이돌봄 max=649만(중위소득 오입력)·동작재산세 max=900만(환급총통계 오입력) → range_only. **dev+prod 적용 완료**.
- **B1 정확액 백필**(mig `009`): 출생순서 7건 breakdown 명시맵. **첫만남 첫째200만/둘째+300만**, 강남·광진·성동·금천·구로 출생축하금, 강동 다자녀장려금. aggregation 불변. **dev+prod 적용 완료**. ⚠gwangjin(나이창0~18mo)은 합산 엣지 flag.
- **B2 태아수**(mig `010`enum+`011`data, code `aad777c`): **dev 완료, prod 미반영**. 규칙=출생(예정)일 동일 자녀 2+=다태아(`fetusCount()` 같은날짜 그룹 최대크기, 신규입력 없음). `per_fetus` enum 추가(breakdown birth_order를 태아수 tier로 재해석), pregnancy_due_date를 전 표시면 전달(미출생 쌍둥이). 3건: 건강보험진료비 단태100/다태140, 서대문 임신축하 30/60/90, 엄마아빠택시 12/24만. 자영업자출산급여=다태 표현 모호로 제외. 부모급여(연령차등)·세액공제(row혼재)=설계상 보류(D).
- **prod 반영 완료(2026-06-03)**: PR #1(dev→main) 머지(merge commit `8d32240`, Vercel success)로 A+B2 코드 bumoro.kr 배포. prod DB에 008·009·010·011 전부 적용·검증. 링크 dev 복귀. ⚠️교훈: per_fetus 정책은 **코드 먼저 배포→DB(011) 나중** 순서 필수(구코드는 per_fetus를 per_application으로 오해해 childCount를 태아수로 오독). main 직접푸시는 차단되나 `gh pr merge`(PR플로우)는 허용됨.

**구코드도 breakdown·range_only는 이미 처리** → prod DB만 반영해도 첫만남 200/300·데이터오류 "조건별차등"은 PR머지 전에도 라이브 적용됨. PR머지가 추가하는 건 "최대" 라벨뿐.

## 카드 UI/콘텐츠 정비 (2026-06-03 후속, dev+prod 완료)

금액 표시(A·B·C·B2) 후 카드 가독성·콘텐츠 전면 정비. 모두 git 커밋 + prod 반영(mig 008~020, 코드는 PR로 main 머지).

- **값 토큰** (`lib/amount-tokens.ts`): 숫자 금액 없는 서비스/현물 정책 헤드라인을 긴 amount_text 대신 짧은 토큰으로(24px 거대화 방지). `valueToken(policy)` = 검토확정 맵 110건(slug→토큰) + 키워드 폴백. ⚠️"무료" 접두어는 제거함(강남 놀이터 1천원 등 유료 정책 오인) → 중립 라벨: 대여·시설 이용·돌봄 지원·접종 지원·검진 지원·교실·강좌·현물 지급·할인·감면·보험 지원·교육·정보·조건별 차등·지원. 무료/유료/회비는 요약·모달이 정확히 안내. 카드는 칩박스 아닌 액센트 plain 텍스트(현금 숫자와 통일).
- **용어사전 적용** (`lib/glossary.ts`): `simplify(text)` 정규식맵(다태아→쌍둥이 이상, 단태아→아이 1명 출산, 본인부담금→내가 내는 비용, 미숙아→이른둥이, 통상임금→평균 월급 등). 기존엔 모달 description만 적용됐는데 **카드·모달·추적·홈의 title/summary/amount_text까지 전 표시면 적용**(DB 원문 유지, 표시 시 순화). DB엔 "다태아" 등 원문 보존.
- **toBullets** (`lib/glossary.ts`): 행정 원문(자격요건·신청방법) run-on을 불릿으로. 분할=헤더(지원 제외:)·마커(*○▪)·파이프(|)·인라인 ' - '·문장끝(한글/숫자/괄호+마침표+공백, URL은 마침표 뒤 공백없어 안깨짐). 각 줄 앞 리스트마커(- · •) 제거(•와 - 이중표시 방지). 모달 InfoRow + 금액영역(긴 amount_text)에 적용.
- **모달 중복제거**: `amount_text==description`(84건)이면 모달 금액영역서 amount_text 생략(상세영역서 1회만).
- **카드 콘텐츠 정비**(mig 012 high118·015 med40·013 token20): summary 없어 raw description이 잘려 노출되던 것 등 친근체 요약 부여 + 제목 단축. 원문 대조 verify 워크플로로 사실오류 교정(매달→4개월·산모계좌→현금·지어낸 금액/연령 제거 등). active summary 누락 0 달성. ⚠️"빈약 자격요건"(영유아·임산부 등) 상당수는 공식 출처도 단순=정상(보강 불필요).
- **데이터 정정**: 008(아이돌봄 max=중위소득·동작재산세 max=환급총통계 오입력→range_only), 014(newlywed-housing slug오명명, 실체=육아기 단축급여), 016(자영업자 출산급여 다태=서울추가분 단태90/다태170 per_fetus, A+B통합 중복 C=paused, 코덱스 웹검색), 018·020(예술인·동작 검사류·다태아보험·유아학비 등 "…" 잘림 11건 정부24·동작보건소·umppa 크롤링 보강→truncated 0).
- 병렬세션 작업(별개): mig 017(cached_child_count 이중카운팅 트리거 제거+백필) · 019(promote_due_births cron). cron은 Vercel env(CRON_SECRET·SUPABASE_SERVICE_ROLE_KEY) 설정해야 활성.
- ⚠️**배포 교훈**: dev migration 적용 후 prod 누락 드리프트 주의(018 예술인이 prod 미반영이었음→재적용). 코드먼저→DB나중(per_fetus 오독 방지). main 직접푸시 차단→`gh pr merge`. prod 적용 후 항상 `supabase link` dev 복귀.
- **검증**: 라이브 bumoro.kr `?data=<base64 OnboardingData>`로 로그인 없이 결과페이지 SSR 렌더(공개) → 값 토큰·불릿·순화 실측. 로컬 `npm run dev`+Playwright로 모달 클릭 확인.

## 현황 (2026-06-02)

**Supabase dev:** lqqcufhfnyubxumryhws (bumoro-dev, Singapore) — 현재 linked
**Supabase prod:** pfwrniqytvnlkhphnyid (bumoro_MVP, Tokyo)
**브랜치:** dev

### 완료

- DB 19테이블 (17 스키마 + median_income_standard + user_benefit_tracking), RLS 전체
- 122건 정책 Supabase 적재 + 검증
- Next.js 16 프론트: 랜딩 + 온보딩 + 결과 + 로그인 + /my 대시보드 + /my/profile
- 이메일+구글 로그인 (Supabase Auth), 로그아웃 API route
- 중위소득 DB 테이블 (2026 보건복지부 고시, 연도 fallback)
- 혜택 저장/상태 추적 (saved→applied→received)
- 다크 모드 (Material Design 기반)
- glossary.ts 법정 용어 순화
- 신청 URL 31건 공식 페이지 교체
- 온보딩 정보 DB 저장 → 프로필 있으면 /result 바로 이동

### 수기검토 DB 마이그레이션 (2026-06-02)

수기검토 시트(261건) 기반 단계별 적용 중.
**원천 시트:** Google Sheets `1r3oATYQKT6aAnUtmhW510bFQ3q7uKTC4danHYo0tc1E` (수기검토 최종본, 39컬럼). 컬럼: 최종DB액션(2)/policy_id(3)/slug(4)/정책명(5)/최종공식URL(15)/최종신청URL(16)/현재출처URL(35) 등. ⚠️셀에 `|` 포함시 마크다운 파싱 컬럼밀림 발생 → 정규식 URL 추출로 보정.

| 액션 | 건수 | 상태 |
|---|---|---|
| `update_url_only` | 58 unique | ✅ **dev+prod 적용 완료 (2026-06-02)** |
| `deactivate_review` | 61 unique | ✅ **dev+prod paused 적용 완료 (2026-06-02)** |
| `update_url_and_policy_fields_review` | 18건(시트 최종본) | ✅ **dev+prod 완료 (2026-06-03, mig 004)** |
| `dedupe_or_scope_review` | 13건 | ✅ **전건 '유지'(중복 0) — dev+prod 보강 (mig 005)** |
| `insert_new_policy_review` | 2건 | ✅ **광진 백일돌컷 등록(dev+prod) / 양천 skip(허위) (mig 007)** |
| `hold_url_manual_check` | 3건 | ✅ **크롤링 확정 후 dev+prod (mig 006)** |
| `no_change` | ~45건 | — |

> **2~5단계 dev+prod 적용 완료(2026-06-03):** mig 004(정보수정18)·005(유지13보강)·006(보류URL3)·007(yongsan paused+광진신규). **최초 UUID 기준으로 작성→dev 적용 후, 재시드/ prod 호환 위해 canonical_slug 기준으로 in-place 변환(commit 654f720)** → dev 드라이런 + prod 드라이런/적용/검증 완료, link dev 복귀. prod 사전점검: 기존 34슬러그 존재·광진신규 0·category service·region 11215 확인 후 적용. 상세 교훈은 본문 하단 '2~5단계 교훈' 참조.

**⚠️ dev/prod UUID 상이:** seed가 `gen_random_uuid()`라 같은 정책도 dev와 prod의 `policy.id`(UUID)가 **다름**. → 환경 간 마이그레이션은 반드시 **`canonical_slug` 기준**으로 작성(UNIQUE 보장). UUID 기준 SQL을 prod에 돌리면 0건 매칭 조용한 no-op. (이번 update_url_only도 UUID→slug 재작성 후 적용)

**주의:** `policy_source`에 `updated_at` 컬럼 **없음** → `last_synced_at` 사용. WHERE에 `source_type = 'manual'` 필수(한 정책에 source_type별 다중 row).

**적용 내역(2026-06-02):**
- URL: migration `20260602000001_fix_url_only_slug_based.sql`. 58건 중 57건이 루트도메인/깨진값(예 `dongjak-care-mom='33'`)→실제 상세페이지로 교체. nhis 임신·출산진료비는 사이트개편으로 레거시 `wbmac0212.html`(모바일깨짐)→`/nhis/policy/wbhada13900m01.do`로 교체. 58개 URL 전수 생존점검 통과(죽은링크 0). dongjak-care-mom(dccic pno=051001=동작맘)·songpa(spscc board wr_id=740) 사용자 확인 완료.
- 비활성화: migration `20260602000002_deactivate_review_paused.sql`. deactivate_review 61건 `service_status` active→`paused`(일시중단, 종료 아님 — 현행운영 확인불가라 보존+숨김, 재확인시 active 복귀). 프론트는 `service_status='active'`만 노출하므로 목록에서 제외됨. `service_status` enum = active/paused/discontinued.

### 운영 런북 (마이그레이션 재사용 절차) — 나머지 액션도 동일 패턴

CLAUDE.md 규칙: DB 정정은 **반드시 `supabase/migrations/*.sql`로 기록**(재시드시 보존), idempotent하게.

1. **시트 파싱** → 액션별 행 추출. slug(영문 kebab) 기준으로 dedupe. URL은 col15(공식), `|` 밀림시 정규식 `https?://[^\s|\\]+`로 복구.
2. **slug 기준 SQL 작성**(UUID 금지 — dev/prod 상이). `WHERE canonical_slug IN (...)`. `policy`는 `updated_at=NOW()`(트리거), `policy_source`는 `last_synced_at=NOW()` + `AND source_type='manual'`.
3. **dev 검증**(현재 link=dev): 슬러그 존재/현재값 SELECT로 대조 → 변경건수 확인.
4. **dev 적용**: `supabase db query --linked -f <migration>.sql` → 결과 SELECT 재검증.
5. **prod 적용**(사용자 명시 승인 필수, AskUserQuestion): `supabase link --project-ref pfwrniqytvnlkhphnyid` → 적용 → 검증 → **반드시 dev 복귀** `supabase link --project-ref lqqcufhfnyubxumryhws`.
   - ⚠️ `--project-ref`는 `db query`에서 미지원. 반드시 `supabase link`로 전환 후 `--linked`.
   - ⚠️ prod 쓰기는 분류기가 막을 수 있음 → AskUserQuestion으로 prod 타겟 명시 승인받으면 통과.
6. **URL 생존 검증**(선택): 실브라우저(Playwright)로 확인. WebFetch는 frameset/iframe·EUC-KR·JS SPA(plus.gov.kr/bokjiro/gov.kr)에서 **오탐** 잦음 → 의심시 Playwright로 재확인.

**적용 완료 migration:** `20260602000001_fix_url_only_slug_based.sql`(URL 58), `20260602000002_deactivate_review_paused.sql`(paused 61), `20260603000001_fill_dongjak_prenatal_helper.sql`(임신맘도우미 16필드), `20260603000002_reactivate_fill_3_dongjak.sql`(태교·백일·영어놀이터 재활성화+채움).

**⚠️ deactivate_review 오분류 교훈(2026-06-03):** 61건 paused 중 3건(태교패키지·백일축하용품·영어놀이터)이 실제론 현행 운영이었음. 시트가 "현행 확인불가"로 분류한 이유는 출처URL이 뉴스/모음사이트(heraldcorp/servedream/welfarehello)였기 때문. **2026 동작구 공식 전단(dongjak.go.kr 게시판 nttId=10736744, 첨부 JPG/PDF 'Best 17')**이 현행 증명 → active 복구 + 공식URL 교체 + 빈필드 채움. 교훈: deactivate를 `discontinued` 아닌 `paused`로 한 게 복구 쉽게 함. 정정 시 **공식 전단/정부24가 secondary aggregator보다 우선**.

**첨부 PDF/이미지 추출법:** dongjak.go.kr 게시글 첨부는 `cmmn/file/fileDown.do?atchFileId=...&fileSn=N`로 curl 다운. JPG는 Read로 직접 OCR, PDF는 `sips -s format png` 또는 `qlmanage -t -s 2000`(고해상도)로 변환 후 Read. plus.gov.kr(정부24)·bokjiro는 SPA라 Playwright 렌더 후 innerText 추출(WebFetch는 빈 셸).

**원천교차검증:** PDF 'Best 17'(동작 임신출산지원 종합전단)로 동작구 정책 38개 대조 완료. 보육인프라(IB·키즈카페·24시간어린이집·육아센터·체험프로그램)는 부모로 범위 밖.

**매칭엔진 동작(검증완료 2026-06-03):** `lib/queries/policies.ts` `buildRegionCodes(region_code)` → 시군구 사용자는 `["KR", 앞2자리(시도), 5자리(시군구)]` 3계층 조회. 즉 **서울시 sido_wide 공통정책이 자치구민에게 정상 노출**(다자녀 요금감면=공영주차장/행복카드/하수도료는 seoul-* sido_wide active로 이미 커버, 동작 중복 happy-card는 discontinued가 맞음). 매칭 필수필드: `policy_life_stage`(없으면 매칭 0) + `policy_household_type`(있으면 세대유형 필터) + `birth_order_min`/`child_age_*`. ⚠️ **life_stage 누락 주의**: dongjak 재산세감면이 `infant_0_36m`만 연결돼 3세초과 다자녀 가구에 안 보이던 버그를 강남(infant_0_36m+child_3y_plus)과 대조해 발견·교정(`20260603000003`). active로 켜기 전 반드시 life_stage 커버리지 + summary/contact 완전성 점검할 것.

**추가 deactivate 오분류 정정(2026-06-03):** `dongjak-multi-child-property-tax-exemption`(재산세 100%감면)도 deactivate 배치에서 잘못 paused→active 복구+내용보강. migration `20260603000003`. 누락 실혜택 후보 2건은 **출처 약해 보류**: 기형아검사(보건소 전용페이지 없음, 임산부등록 초기검사엔 미포함, 전단 02-820-9477만)/동작 시설요금감면(체육시설·구민대학 분산, 통합출처 없음).

### 2~5단계 교훈 (2026-06-03) — ⚠️ 매칭엔진 함정

**`lib/queries/policies.ts` 매칭 규칙(검증 완료, 신규/수정 전 필독):**
- **household_type = 하드 필터**(181~188행): 정책에 `policy_household_type`가 있으면 사용자 세대유형이 그 코드여야만 노출, 아니면 `return false`. **그런데 온보딩 세대유형 선택지는 `일반`/`한부모`(+임신준비)뿐**(`components/onboarding/step-family.tsx`, HOUSEHOLD_TYPE_MAP: 한부모→single_parent/다문화→multicultural/다자녀→multi_child). 즉 **multi_child·multicultural을 policy_household_type에 넣으면 그 정책은 누구에게도 안 보임(매칭 0)**. ⇒ 다자녀 정책은 `household_type` 쓰지 말고 **`birth_order_min`**(child_count로 매칭)으로만. (workflow가 dobong-childcare/insurance·ep-postpartum에 multi_child 추가 제안했으나 전면 폐기함.) single_parent만 실제 동작.
- **income 매칭(200·330행): `median_income_percent`만 필터링됨**(threshold 초과 시 제외). `recipient_required`/`health_insurance_based`/`requires_review`는 **필터 안 됨**(needs_verification 플래그만). ⇒ income 타입을 median→recipient로 바꾸면 소득 필터가 사라져 노출이 넓어짐(정확성↑ vs 정밀도↓ 트레이드오프). dobong-atopy는 공식상 median 근거 없어 recipient로 정정, seongdong-unwed는 median 63%가 한부모 복지급여기준과 일치해 유지.
- **`requires_pregnancy`는 매칭에서 미사용**(life_stage=pregnancy가 담당) → true/false 바꿔도 매칭 무영향(표시/메타용).

**크롤링으로 확정한 데이터(공식출처+정부24, Playwright 사이트검색):**
- gov 사이트 deep-link는 통합검색 폼(action+searchTerm/searchQuery 파라미터)을 JS로 채워 POST하면 찾힘(WebFetch/WebSearch 실패 시). jongno=`Main.do?menuNo=401428`, seongdong 가사돌봄=`sd.go.kr/main/contents.do?key=4188`(※key=4489는 '아픈아이 병원동행'=딴 정책), gangbuk=`menuNo=400146`(표준 HTTPS, :18000 포트 금지).
- guro-0age amount_max=70만 **확정**(구로보건소 key=1332: 기본50/다자녀70만, 정부24엔 금액 누락). dobong-insurance 연령=84월(입양7세). gangnam-dad=96월(육아휴직 만8세, 법령파생). gangnam-birth=12월 유지(연령 아닌 신청기한 파생).
- **seongdong-unwed-parent-utility 실체=`미혼모·미혼부 냉난방비 지원`**(현금, 1~2월·7~8월 월2.5만, 정부24 303000000307)이지 '공공요금 감면' 아님 → 제목 정정.
- **yongsan-postpartum-copay → paused**: 용산 공식사이트(통합검색·게시판·보건소 전메뉴) 재확인해도 '본인부담금 90%환급(소득무관)' 자체사업 없음(광진은 전용페이지 실재해 대조됨). 서울시 통합 본인부담금 지원은 수급/차상위(소득기준 O)라 DB의 '소득무관'과 불일치. 현행 확인 시 active 복구.
- **백일·돌컷='서울아이백일돌컷'(서울시 통합, seoultoy.or.kr, 8거점 자치구 센터 운영, 서울 거주 영아 대상)**. 광진은 거점 1곳이라 사용자 결정으로 `gwangjin-100day-dol-photo`(sigungu 11215, category=service, 촬영공간 무료대여) 신규 등록. **양천은 거점 아님 → 시트의 양천 항목은 광진 URL 복붙한 허위 → skip**.

**신규 INSERT 패턴(mig 007):** FK는 code 기준 subquery(`(SELECT id FROM category WHERE code='service')`, region code='11215', life_stage code IN(...))로 dev/prod UUID 상이 회피. policy는 `ON CONFLICT (canonical_slug) DO NOTHING`, M:N은 PK로 ON CONFLICT, policy_eligibility는 unique 없어 `NOT EXISTS`로 idempotent. category 코드: cash/voucher/service/childcare/discount/tax_benefit/information.

**드라이런 기법:** 적용 전 `sed 's/^COMMIT;/ROLLBACK;/'`로 임시본 만들어 `db query --linked -f`로 돌리면 데이터 변경 없이 에러/FK 검증 가능.

### 기타 남은 것

- Vercel 배포 / 구글 OAuth 프로덕션 전환 / 체크리스트·이벤트·재테크 실기능 / 실사용자 테스트

---
name: project-bumoro-db-design
description: "부모로 DB설계+프론트 MVP (~/Desktop/부모로데이터베이스설계/, Chohangryong/bumoro 리포). bumoro-project와 별개. Supabase+Next.js16. 수기검토 261건 DB 마이그레이션 진행: update_url_only 58 + deactivate_review 61(paused) dev+prod 완료(2026-06-02). 남음: update_url_and_policy 29/dedupe 20/insert 4/hold 3. ⚠️dev·prod UUID 상이→slug기준 마이그레이션, supabase link 전환 런북"
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
| `update_url_and_policy_fields_review` | 29건 | ⏳ 미적용 |
| `dedupe_or_scope_review` | 20건 | ⏳ 수동 판정 필요 |
| `insert_new_policy_review` | 4건 | ⏳ 미적용 |
| `hold_url_manual_check` | 3건 | 🔴 보류 |
| `no_change` | ~45건 | — |

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

### 남은 수기검토 액션 (미적용)

- `update_url_and_policy_fields_review` 29건 — URL + 본문(summary/amount_text/application_method_text/raw_target_text) 동시 수정. 시트 col11~14가 최종값.
- `dedupe_or_scope_review` 20건 — 중복 통합/scope 충돌. 수동 판정 필요(review_status `needs_merge` 활용 가능).
- `insert_new_policy_review` 4건 — 신규 policy row 추가.
- `hold_url_manual_check` 3건 — 대체 URL 필요, 보류.

### 기타 남은 것

- Vercel 배포 / 구글 OAuth 프로덕션 전환 / 체크리스트·이벤트·재테크 실기능 / 실사용자 테스트

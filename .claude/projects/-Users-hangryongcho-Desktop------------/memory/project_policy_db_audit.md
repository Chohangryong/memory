---
name: policy-db-audit
description: "정책 DB 검증 2차(2026-05-28). rules-first validator + Scrapling URL fetch. 사용자 1:1 검토 후 5건만 매칭 패치(dev+운영 반영). 데이터 오염·child_age 오류·is_hidden 컬럼 등 follow-up 다수."
metadata: 
  node_type: memory
  type: project
  originSessionId: e9b40002-b12c-4796-b150-5fcca00c19f1
---

## 2026-05-26 1차 audit (커밋 aabea82)
- seed_policies.sql 122건 검증, slug 18건/discontinued 16건/eligibility 6건/URL 36건 수정
- generate_seed.py slug 배열 순서 밀림 원인
- 현재 active 100건 / discontinued 22건 (2026-05-28 기준 변동: 100/22)
- ON CONFLICT SET 절에 detail_url, service_status, confidence 등 누락 시 재실행 시 미갱신 — 반드시 포함

## 2026-05-28 2차 재검증 (서울 다른 구 확장 전)

**방법:** rules-first validator (정규식·키워드·구조 패턴) + Scrapling StealthyFetcher URL 검증. raw_target_text/raw_eligibility_text 정답지, 없으면 description fallback 시 신뢰도 한 단계 강등.

**산출물:** `scripts/validate_policies/`, `docs/validation/*-2026-05-28.md`, `docs/validation/policy-validation-patch.sql`, `docs/superpowers/specs/2026-05-28-policy-data-validation-design.md`, `docs/superpowers/plans/2026-05-28-policy-data-validation.md`.

**결과:**
- 매핑 이슈 84건 (high 20 / medium 61 / low 3) 검출
- URL 검증 active 100건: ok=92, stale=6, redirect=1, fail=1
- 사용자 1:1 검토 후 high 20건 중 **5건만 적용** (15건 거부 또는 follow-up)
- dev + 운영 DB 모두 동일 패치 적용 완료
- 51개 app 테스트 + 18개 validation 테스트 + 4개 사용자 케이스 시뮬레이션 통과

**적용된 5건 (매핑 보정):**
1. `dongjak-newborn-insurance-premium` → +multi_child (둘째이상 신생아 보험료)
2. `national-child-allowance` → -pregnancy (아동수당, 만 9세 미만)
3. `national-child-influenza-vaccination` → +child_3y_plus, +infant_0_36m (생후 6개월~13세)
4. `national-childcare-allowance` (유아학비 3~5세) → +child_3y_plus, -infant_0_36m
5. `national-women-scientist-career-return` → -pregnancy (복귀 시점 정책)

**Why (1:1 검토에서 발견된 validator 약점):**
- "child_age_min>0 + pregnancy" 룰의 false positive 7건 발생 — 실제로는 임신 시기부터 적용되는 출산/육아 정책이 많은데 child_age 데이터가 잘못 저장돼 있어서 룰이 잘못 발동
- "수급자/차상위" 키워드 매핑이 우대 등급 안내를 자격 요건으로 잘못 잡음 (3건 false positive)
- "19세 미만 환아"의 19세가 산모(teen_mom)가 아니라 환자 아이 — 컨텍스트 무시한 매칭

**Follow-up (별도 작업 필요):**
1. **`policy.is_hidden BOOLEAN` 컬럼 추가** + 환아/특수대상 정책(`dongjak-metabolic-screening`) hidden=TRUE 처리. matching 쿼리에 `is_hidden=FALSE` 필터 추가.
2. **slug↔정책명 데이터 오염 row 재시드 (5건)**:
   - `national-infant-0-1-daycare-subsidy` (실제 데이터: 행복출산 통합서비스)
   - `national-maternity-leave-benefit` (실제: 교사근무환경개선비)
   - `national-work-family-balance-subsidy` (실제: 출산전후휴가급여)
   - 그 외 description vs raw_target_text 불일치 의심 정책 식별 필요
3. ~~**child_age 데이터 오류 보정 (5건)**~~ ✅ 2026-05-29 완료 (커밋 7284d35, dev+운영 반영):
   - `national-artist-freelancer-maternity-benefit`: child_age_min=3 → NULL (피보험 3개월이 잘못 매핑)
   - `national-child-allowance`: [204,540] → [0,107] (만 9세 미만)
   - `national-parental-leave-benefit`: [3,None] → [0,96] (만 8세 이하)
   - `national-postoffice-mom-baby-insurance`: [204,540] → [0,0], parent_age=[17,45] (가입나이가 부모 나이로 들어감)
   - `seoul-self-employed-maternity-benefit`: child_age_min=3 → NULL
   - **교훈:** 어제(05-28) 아동수당 마이그레이션(20260528000001)이 커밋엔 "dev/prod 보정 완료"라 적혔으나 실제로는 **운영만 적용·dev 누락**. 이 프로젝트는 마이그레이션 추적 테이블(supabase_migrations.schema_migrations) 없음 → `db query -f` 직접 실행 방식이라 마이그레이션 파일 존재 ≠ 적용. 적용 여부는 항상 현재 값 SELECT로 양쪽 DB 확인할 것.
   - seed는 NOT EXISTS 가드라 재시드로 기존 row 미갱신 → 데이터 오류는 반드시 직접 UPDATE. seed 수정만으론 운영 반영 안 됨.
4. **validator 룰 개선**: "child_age_min>0 + pregnancy" 룰 비활성화 또는 정교화. "수급자/차상위" 룰을 income_criteria_type만 보고 매칭하도록.
5. **medium 61건 / low 3건**: 이번 패치 대상 아님. 사용자 직접 판단용 리포트로만 보존.
6. **life_stage 메타 정합성(2026-05-30 발견, 나중 처리)**: `life_stage` 테이블 `pregnancy_prep`=age_min/max [-9,0], `pregnancy`=[0,0]. 직관상 임신중(pregnancy)이 [-9,0]이어야 자연스러운데 두 단계 값이 바뀐 듯. 단 `computeUserLifeStages`(lib/queries/policies.ts:133)는 이 age 컬럼 미사용(daysSinceBirth로 code 직접 매핑) → **매칭 무영향, 순수 메타**. residency_scope(122건 전부 NULL)도 동일하게 미사용 컬럼. 정합성 차원 정리만 필요(우선순위 낮음).
7. **amount_breakdown 미사용 → 과대표시(2026-05-30 발견, 별도 프론트 작업)**: `policy.amount_breakdown`에 출생순서별 금액(`[{birth_order, amount}]`, 예 출산축하금 첫째30만~넷째200만)이 구조화돼 있으나, 표시 코드(`benefit-card.tsx:57`, summary-cards, benefit-modal, tracking-card)가 `amount_max`(최댓값)만 사용. → 사용자 자녀가 첫째여도 넷째 기준 최댓값 노출(첫째 실제 30만원인데 200만원 표시). **출생순서 차등 지원 정책 전부 영향.** 사용자 `birth_order`로 정확 금액(또는 "첫째30만~넷째200만" 범위) 계산하도록 표시 로직 개선 필요.
8. **slug prefix ↔ 실제 scope 불일치(2026-05-30, 별도)**: `dongjak-*` prefix인데 실제론 전국/서울 사업인 정책 다수(동작구 보건소가 집행만). 예: `dongjak-preconception-health-check`=2024 보건복지부 전국 가임력검사. 이번 audit에서 **region scope(policy_region)는 national/sido로 바로잡되, canonical_slug는 ON CONFLICT 키라 변경 위험 → slug 자체 정정은 별도 follow-up**. 확인된 전국/서울 사업: 가임력검사(전국). 난임·백일해·정난관·아토피도 사업주체 확인 중.

## 2026-05-30 3차: original_url 오연결 전수 audit (완료, dev+운영, 커밋 40236c2~3b8f0de)
- **근본원인**: `generate_seed.py` SLUG_MAP 번호↔slug 오매핑 → 일부 정책 original_url/raw_target이 인접 정책 것으로 밀림. (SLUG_MAP 자체 정정은 #8 별도 follow-up)
- **검출법**: SLUG_MAP이 오염원이라 조인키로 못 씀 → **title↔엑셀 '혜택명' 매칭**(100% 성공) + Scrapling 크롤 확정. 도구 `scripts/validate_policies/audit_original_url.py`, `crawl_ambiguous.py`. 정답지 `data/validation/bumoro_122_source.json`(엑셀 export).
- **교정**: original_url 4건(아동수당 WLF00001171/가정양육 WLF00003253/부모급여 WLF00004657/육아휴직 work24) + 결측 raw_target 11건(동작구 보건소·구청 공식안내 WebFetch로 채움) + scope 재판정(가임력·난임→national, 정난관→서울11 sido_wide) + 신생아건강보험 birth_order=2·+multi_child·전용url200288 + cash[0,12]·북스타트[0,95] child_age + 아토피·북스타트 +child_3y_plus + cash-gift 중복 discontinued.
- **미사용 컬럼 확인**(채워도 매칭 무관): residency_scope(전건 NULL)·parent_age(필터없음)·requires_pregnancy/birth(코드없음)·life_stage.age. 매칭 실사용: region·life_stage·child_age·birth_order·income.
- **잔여**: 동작맘(url="33" 깨짐) + 태교패키지·영어놀이터·유축기·가족센터 공식안내 미확인(별도). amount_breakdown 미사용 과대표시(#7). slug prefix↔scope 불일치(#8).

**기타 1차 audit에서 미완료:**
- #44 (신생아 건강보험료 지원) URL 미확인 — 2차에서도 확인 안 됨
- 2025년 언급 정책 8건의 2026년 계속 시행 여부 별도 확인 필요

**How to apply:**
- 매핑 검증 재실행 시 `scripts/validate_policies/` 도구 활용 (TDD 테스트 + ON CONFLICT 안전 SQL builders)
- 자동 SQL 적용 금지. 항상 사용자 1:1 검토 후 high 등급만 패치 (validator는 false positive 다수)
- raw_target_text vs description vs 정책명(title) 셋 다 비교 필수 — slug 데이터 오염 정책이 5건 이상

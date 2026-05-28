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
3. **child_age 데이터 오류 보정 (5건)**:
   - `national-artist-freelancer-maternity-benefit`: child_age_min=3 → NULL (피보험 3개월이 잘못 매핑)
   - `national-child-allowance`: [204,540] → [0,107] (만 9세 미만)
   - `national-parental-leave-benefit`: [3,None] → [0,96] (만 8세 이하)
   - `national-postoffice-mom-baby-insurance`: [204,540] → [0,0], parent_age=[17,45] (가입나이가 부모 나이로 들어감)
   - `seoul-self-employed-maternity-benefit`: child_age_min=3 → NULL
4. **validator 룰 개선**: "child_age_min>0 + pregnancy" 룰 비활성화 또는 정교화. "수급자/차상위" 룰을 income_criteria_type만 보고 매칭하도록.
5. **medium 61건 / low 3건**: 이번 패치 대상 아님. 사용자 직접 판단용 리포트로만 보존.

**기타 1차 audit에서 미완료:**
- #44 (신생아 건강보험료 지원) URL 미확인 — 2차에서도 확인 안 됨
- 2025년 언급 정책 8건의 2026년 계속 시행 여부 별도 확인 필요

**How to apply:**
- 매핑 검증 재실행 시 `scripts/validate_policies/` 도구 활용 (TDD 테스트 + ON CONFLICT 안전 SQL builders)
- 자동 SQL 적용 금지. 항상 사용자 1:1 검토 후 high 등급만 패치 (validator는 false positive 다수)
- raw_target_text vs description vs 정책명(title) 셋 다 비교 필수 — slug 데이터 오염 정책이 5건 이상

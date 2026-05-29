---
name: seed-reseed
description: 재시드 절차 — seed_policies.sql 단독 실행 금지(정정 원복). seed + migrations 전부 순차 적용. DB 정정은 반드시 마이그레이션 파일로 기록. 지역확장 검증은 policy-region-audit skill.
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 4d3488a3-b6a3-4ee1-82b3-07485af10a53
---

`seed_policies.sql`은 **초기 상태**이고, 이후 데이터 정정은 `supabase/migrations/`에 누적된다.

**Why:** seed에는 옛 값이 그대로 박혀 있다 — 동작구 정책 region이 KR+11+11590 3개씩(상위지역 잉여), 잘못된 detail_url/household_type 등. 마이그레이션이 이를 정정한다. **seed만 재실행하면 모든 정정이 원복된다.**

**How to apply:**
- 전체 재시드: ① `db query --linked -f seed_policies.sql` → ② `for f in supabase/migrations/*.sql; do db query --linked -f "$f"; done`(파일명=시간순) → ③ 현재 운영 DB와 핵심 정책 대조 검증.
- **DB 데이터 정정 시 반드시 `supabase/migrations/`에 SQL 파일로 기록**(직접 `db query`만 하고 파일 안 만들면 재시드 누락). idempotent(UPDATE/ON CONFLICT/DELETE)하게.
- ⚠️ 과거 일부 정정이 마이그레이션 밖(직접 query)에 있어 `seed + migrations`가 불완전할 수 있음 → 재시드 후 검증 필수. (완전 동기화 검증 = 임시 DB에 seed+migrations 적용 후 dev diff — 미완 follow-up)
- 지역 확장 시 정책 데이터 검증·교정은 `policy-region-audit` skill 사용(정답지 교차검증·scope 판정·household 전용/포함·미사용 필드 등 codify). 상세는 [[policy-db-audit]].
- 관련: [[seed-onconflict]] (ON CONFLICT SET 필드 누락 주의), [[supabase-db-update]] (link 전환 방식).

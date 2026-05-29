---
name: postgrest-nested-filter
description: PostgREST nested embedded filter는 부모 row 미제거. .in(a.b.code) 2단계 필터 무효. FK ID 직접 필터 필수. Supabase !inner JOIN 한계.
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 1337ffc6-dcf8-449b-9bba-bc383b95fbc1
---

Supabase/PostgREST에서 `.in("policy_life_stage.life_stage.code", values)` 같은 2단계 nested embedded filter는 부모 row를 제거하지 않고 embedded 결과만 shaping한다.

**Why:** PostgREST 설계상 embedded filter는 top-level row filter가 아님. `!inner`는 해당 relation에 row 존재 여부만 체크. 내부 relation의 컬럼 조건은 left join으로 적용되어 부모 정책이 살아남음. 이로 인해 pregnancy_prep 전용 난임 정책이 infant_0_36m 사용자에게 노출되는 버그 발생.

**How to apply:**
- 2단계 관계 필터가 필요하면 중간 테이블의 FK ID로 직접 필터: `.in("policy_life_stage.life_stage_id", uuidArray)`
- code → UUID 변환을 먼저 수행 (별도 쿼리 1회)
- `policy_region`도 전국 확대 시 같은 패턴으로 전환 필요 (현재는 모든 정책이 KR/11/11590 중 하나를 가져서 문제 안 됨)

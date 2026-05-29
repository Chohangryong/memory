---
name: supabase-db-update
description: Supabase DB 시드/마이그레이션 실행 방법. anon key RLS 차단. supabase db query --linked 필수. --project-ref 미지원. link 전환 방식.
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 1337ffc6-dcf8-449b-9bba-bc383b95fbc1
---

seed_policies.sql 수정 후 실제 DB에 반영할 때 `supabase db query --linked` 사용.

**Why:** anon key로 Supabase JS Client INSERT 시 RLS가 policy_life_stage 등 테이블에서 차단. `--project-ref`는 `db query` 서브커맨드에서 미지원.

**How to apply:**
- dev DB: `supabase db query --linked "SQL"` (기본 링크가 bumoro-dev)
- 운영 DB: `supabase link --project-ref pfwrniqytvnlkhphnyid` → `supabase db query --linked "SQL"` → `supabase link --project-ref lqqcufhfnyubxumryhws` (dev 복귀)
- 파일로 실행: `supabase db query --linked -f path/to/file.sql`
- 운영 반영 순서: DB 먼저 → 코드 배포 (코드가 새 데이터에 의존할 수 있으므로)

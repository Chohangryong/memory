---
name: nextjs16-proxy-migration
description: Next.js 16에서 middleware.ts는 Edge Runtime 강제 — __dirname 에러 발생. proxy.ts(Node.js Runtime)로 마이그레이션 필수. Supabase SSR 포함 시 특히 주의.
metadata: 
  node_type: memory
  type: project
  originSessionId: 5fb9e9ec-5cc6-4123-99c5-e164f84a232a
---

Next.js 16에서 `middleware.ts`는 deprecated → Edge Runtime 강제 실행.
Edge Runtime에는 `__dirname` 등 Node.js 글로벌이 없어 `@supabase/ssr` 사용 시 `MIDDLEWARE_INVOCATION_FAILED` 발생.

**Why:** Vercel 배포 시 500 에러. `serverExternalPackages` 설정도 Edge Middleware에는 효과 없음.

**How to apply:** `middleware.ts` → `proxy.ts` 전환. export 함수명 `middleware` → `proxy`. 
Codex 상담으로 확인한 사실 (Claude + Codex 합의).

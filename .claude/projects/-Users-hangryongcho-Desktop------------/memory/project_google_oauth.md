---
name: google-oauth-setup
description: "구글 OAuth 설정 — NEXT_PUBLIC_SITE_URL 환경변수 필수, Supabase Authentication > URL Configuration에서 Redirect URL 등록 필수. 운영/개발 Supabase 프로젝트 각각 설정."
metadata: 
  node_type: memory
  type: project
  originSessionId: 5fb9e9ec-5cc6-4123-99c5-e164f84a232a
---

구글 로그인이 작동하려면 3가지 모두 맞아야 함:

1. **Vercel 환경변수** `NEXT_PUBLIC_SITE_URL` — 미설정 시 localhost로 콜백됨
2. **Supabase Redirect URL** — Authentication > URL Configuration에서 `https://도메인/auth/callback` 등록
3. **Google Cloud Console** — OAuth 2.0 승인된 리디렉션 URI에 Supabase 콜백 URL 등록

**Why:** 2026-05-26 구글 로그인 시 아이디 선택 후 로그인 페이지로 되돌아오는 버그. NEXT_PUBLIC_SITE_URL 미설정 + Supabase Redirect URL 미등록이 원인.

**How to apply:** 환경 추가 시 위 3가지 모두 확인. 운영/개발 Supabase 프로젝트 각각 설정해야 함.

---
name: login-redirect-fullreload
description: Next.js App Router 서버 액션에서 redirect()는 클라이언트 네비게이션으로 처리 — 클라이언트 상태(Nav user) 미갱신. window.location.href로 전체 새로고침 필요.
metadata: 
  node_type: memory
  type: project
  originSessionId: 5fb9e9ec-5cc6-4123-99c5-e164f84a232a
---

로그인 서버 액션에서 `redirect("/")`를 사용하면 Nav 컴포넌트의 `useEffect`가 재실행되지 않아
로그인 후에도 "로그인" 버튼이 그대로 보이는 버그 발생.

**Why:** Next.js App Router의 서버 액션 redirect는 soft navigation(클라이언트 네비게이션)으로 처리됨.

**How to apply:** 서버 액션에서 `return { redirect: true }`, 클라이언트에서 `window.location.href = "/"`로 전체 새로고침 유도.

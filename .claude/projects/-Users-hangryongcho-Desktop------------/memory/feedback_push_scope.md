---
name: feedback-push-scope
description: 푸시 범위 — 테스트/인프라 파일은 명시적 요청 없으면 push 대상에서 제외. 로직 변경만 push.
metadata: 
  node_type: memory
  type: feedback
  originSessionId: d723835f-618b-4d2e-ba13-fac73bc7267c
---

테스트 케이스, vitest 설정 등 개발 인프라 파일은 "푸시"하라고 하지 않으면 로컬 커밋만 하고 push하지 않는다.

**Why:** 테스트 인프라는 배포와 무관하며 불필요하게 리모트를 오염시킨다.
**How to apply:** git push 전에 어떤 커밋이 포함되는지 확인하고, 테스트/설정 커밋이 있으면 push 대상에서 제외하거나 사용자에게 확인받는다.

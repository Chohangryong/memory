---
name: feedback-branch-rule
description: "bumoro 프로젝트 브랜치 규칙 — main 직접 커밋/푸쉬 금지, 반드시 dev 먼저. git checkout dev 확인 후 작업 시작."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 93b7b0ee-af57-44c1-8112-9d4453b76509
---

main 브랜치에 직접 커밋·푸쉬 절대 금지. 모든 변경은 dev 브랜치에서 시작한다.

**Why:** 2026-05-26 main에 직접 커밋·푸쉬하여 운영(bumoro.kr)에 검증 없이 배포된 사고 발생. dev.bumoro.kr에서 먼저 확인 후 main에 merge하는 게 프로젝트 규칙.

**How to apply:** 작업 시작 전 `git branch` 또는 `git status`로 현재 브랜치 확인. main이면 반드시 `git checkout dev`부터. 커밋·푸쉬 요청 시에도 현재 브랜치가 dev인지 재확인.

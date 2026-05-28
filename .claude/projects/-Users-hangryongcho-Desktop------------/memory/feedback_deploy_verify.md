---
name: deploy-verify
description: "부모로 배포 규칙: dev push 후 dev.bumoro.kr 확인 단계 필수, 사용자 명시 승인 없으면 main 직행 금지"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 70dce57b-451e-4ab4-9251-6a3512904774
---

dev push 후 dev.bumoro.kr 동작 확인하지 않은 상태에서 main merge하지 말 것.

**Why:** CLAUDE.md(/Users/hangryongcho/Desktop/부모로데이터베이스설계/CLAUDE.md) "개발 → 배포 규칙" 3-4단계에 명시:
> 3. 개발 서버 배포 → dev.bumoro.kr 자동 배포 → 확인
> 4. 운영 반영

2026-05-28 nav 플래시 수정 시 dev push 직후 main merge → 사용자 지적("개발 서버에 안 올리고 운영에 먼저 올린 거야?"). layout.tsx async 전환·Nav prop 변경은 모든 페이지 영향 → 검증 없이 운영 반영은 위험.

**How to apply:**
- 큰 변경(layout, auth, DB 스키마, 인프라)일수록 dev 확인 필수
- 사용자가 명시적으로 "바로 main 반영", "운영까지 같이 배포" 등으로 허용한 경우에만 dev → main 연속 배포 가능
- 자동 모드라도 verification은 생략하지 말 것 — 시간보다 안전이 우선
- dev push 후 Vercel 배포 끝나기 기다리고(30~60s) curl/스크린샷으로 1회 검증, 그 다음 main merge

---
name: deploy-verify
description: "부모로 배포 규칙: 런타임 영향 변경은 dev 검증 후 main, docs/data 변경은 묻지 말고 즉시 동기화"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 70dce57b-451e-4ab4-9251-6a3512904774
---

변경 성격에 따라 main 동기화 정책이 다름.

**런타임 영향 변경(layout/auth/DB 스키마/인프라/UI/API)**: dev push → dev.bumoro.kr Vercel 배포 대기(30~60s) → curl/playwright 1회 검증 → main merge. 사용자 명시 승인 없으면 검증 단계 생략 금지.

**Why:** CLAUDE.md(/Users/hangryongcho/Desktop/부모로데이터베이스설계/CLAUDE.md) "개발 → 배포 규칙" 3-4단계에 명시:
> 3. 개발 서버 배포 → dev.bumoro.kr 자동 배포 → 확인
> 4. 운영 반영

2026-05-28 nav 플래시 수정 시 dev push 직후 main merge → 사용자 지적("개발 서버에 안 올리고 운영에 먼저 올린 거야?"). layout.tsx async 전환 같은 광범위 변경은 검증 없이 운영 반영 위험.

**docs/data/마스터 파일/메모리 파일** (런타임 무관): 동기화 여부 묻지 말고 즉시 main merge.

**Why (2건 보완):** 2026-05-28 region 마스터 파일 4개(data/regions/*.csv, README, SQL 템플릿) 커밋 후 main 반영 여부 물어봄 → 사용자 응답: "이거 동기화할 때마다 물어볼 거잖아. 그냥 동기화해." 런타임 영향이 없는 docs/data 파일은 사용자 결정만 지연시키는 질문이라 의미 없음.

**How to apply:**
- 변경 파일 경로로 판단:
  - 런타임 영향: `app/**`, `components/**`, `lib/**`, `supabase/migrations/**`, `vercel.json`, `package.json`, `proxy.ts`, 등 → 검증 필수
  - 런타임 무관: `data/**`, `docs/**`, `README.md`, `.claude/**`, 메모리 파일, 주석/타입 only 변경 → 묻지 말고 즉시 main 동기화
- 런타임 영향이지만 사용자가 "바로 main 반영", "운영까지 같이 배포" 명시 → 검증 생략하고 즉시 동기화
- dev 확인이 어려운 경우(basic auth 등) 사용자에게 dev 확인 요청 후 응답 받고 main 반영

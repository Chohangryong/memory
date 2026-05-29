---
name: bumoro-infra
description: "부모로 프로젝트 인프라 — Vercel 배포, 도메인, Supabase 프로젝트, 환경 분리, 브랜치 전략"
metadata: 
  node_type: memory
  type: reference
  originSessionId: 5fb9e9ec-5cc6-4123-99c5-e164f84a232a
---

## 배포 환경

| | 운영 | 개발 |
|---|------|------|
| **도메인** | bumoro.kr | dev.bumoro.kr |
| **브랜치** | main | dev |
| **Vercel 환경** | Production | Preview (dev) |
| **자동 배포** | main push → bumoro.kr | dev push → dev.bumoro.kr |

## Supabase 프로젝트

| | 운영 | 개발 |
|---|------|------|
| **프로젝트명** | bumoro_MVP | bumoro-dev |
| **리전** | Northeast Asia (Tokyo) | Southeast Asia (Singapore) |
| **URL** | pfwrniqytvnlkhphnyid.supabase.co | lqqcufhfnyubxumryhws.supabase.co |

## Vercel 환경변수

- `NEXT_PUBLIC_SUPABASE_URL` — Production + Preview(dev) 분리
- `NEXT_PUBLIC_SUPABASE_ANON_KEY` — Production + Preview(dev) 분리
- `NEXT_PUBLIC_SITE_URL` — Production: bumoro.kr / Preview(dev): dev.bumoro.kr
- `BASIC_AUTH_PASSWORD` — Preview(dev)만 설정. dev 서버 접근 비밀번호

## 도메인 DNS (가비아)

- `@` A → 76.76.21.21 (bumoro.kr)
- `www` CNAME → cname.vercel-dns.com. (www.bumoro.kr)
- `dev` A → 76.76.21.21 (dev.bumoro.kr)

## GitHub

- 레포: Chohangryong/bumoro
- Vercel Git 연동 완료 — push 시 자동 배포

## 개발 워크플로우

1. `git checkout dev && git pull origin dev`
2. 로컬 개발 (`npm run dev`)
3. `git commit && git push origin dev` → dev.bumoro.kr 자동 배포
4. 확인 후 `git checkout main && git pull origin main && git merge dev && git push origin main` → bumoro.kr 자동 배포

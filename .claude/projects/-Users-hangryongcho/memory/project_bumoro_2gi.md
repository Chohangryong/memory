---
name: project-bumoro-2gi
description: "부모로 2기 — 부모 커뮤니티 피벗 (~/Desktop/부모로2기/, Chohangryong/bumoro2, bumoro2.vercel.app). v1 아카이빙 완료(2026-08-08), 인프라(도메인·Supabase·Vercel·Resend) 전부 승계, 컨셉 브레인스토밍 전 단계"
metadata: 
  node_type: memory
  type: project
  originSessionId: 8ab03d28-52d7-4872-b304-fd35056643b2
  modified: 2026-08-08T12:55:19.247Z
---

# 부모로 2기 (커뮤니티 피벗)

**Why:** v1(bumoro.kr, 정부지원금 매칭)이 반응이 없어 부모 커뮤니티 컨셉으로 피벗. v1 인프라를 그대로 재사용하되 코드베이스는 새로 시작.

## 확정 결정 (2026-08-08)

- **v1은 유지한 채 전환**: bumoro.kr + 크론 12개 전부 계속 가동, 개발만 동결. 2기 런칭 때 도메인 이전.
- **새 리포**: `Chohangryong/bumoro2` (private) + 새 Vercel 프로젝트 `bumoro2` → https://bumoro2.vercel.app (placeholder 200 확인). Vercel Hobby도 프로젝트 200개 가능(공식문서 확인).
- **Supabase 기존 dev/prod 재사용** (무료 2프로젝트 한도 소진이라 신규 불가): dev 62MB/prod 161MB(한도 500MB, 실측 2026-08-08). 2기 테이블은 별도 스키마/`s2_` 접두사, v1 테이블 불가침. 기존 자산 = 가입자 25명·정책 524건(active 442)·events 3.3만·tour_attraction 5,785.
- 이번 범위는 아카이빙+인계까지. **커뮤니티 컨셉 브레인스토밍은 미착수** — 다음 세션 첫 작업.

## 아카이빙 산출물

- 태그 `v1-final`(main 3b034ce) / `v1-final-dev`(dev 332632f, 미커밋 문서·supabase 설정 보존 커밋 3개 포함)
- 전체 백업 `~/Desktop/부모로1기아카이브/` (180MB): db-dumps dev+prod(row count·SHA256 검증 완료) / secrets(600) / local-docs / personal-data / patches / MANIFEST.md / **CRON-INVENTORY.md**(크론 12개 표+런칭 시 중지 순서)
- 인계 문서 = 2기 리포 `INFRA.md` (계정·DNS·시크릿 키이름·함정·런칭 전환 체크리스트 9단계)
- v1 운영지식 = v1 리포 `docs/OPERATIONS.md`(구 CLAUDE.md 사본)
- `bumoro-project`(구 설계 리포) GitHub Archived. 홈 메모리 리포 이중추적 4파일 해소 + .gitignore에 부모로 폴더 4개 등록(4538b9b)

## 잔여 액션

1. **Vercel GitHub App에 bumoro2 리포 접근 권한 부여** — 사용자만 가능(github.com/settings/installations → Vercel → Repository access). 완료 후 `vercel git connect` 재실행하면 push 자동배포 연결.
2. v1 `cl-export` 크론 **12일 연속 실패**(7/27~, prod cl 데이터 export) — 수리 여부 미결정.
3. 커뮤니티 컨셉 브레인스토밍 → 스택 확정 → 스캐폴드(placeholder index.html 교체).

## 함정 승계 (상세는 INFRA.md)

- dev 브랜치 미공개 기능(flag OFF) 다수 → **dev→main 머지 = 운영 배포, 금지**
- v1 `.env`=prod SERVICE_ROLE / `.env.local`=dev — 스크립트 대상 확인 필수
- hotdeal-sidecar launchd 데몬 + worktree `.claude/worktrees/hotdeal-sidecar` 삭제 금지
- supabase link 전환식 CLI: prod 작업 후 dev 복귀 필수, 마이그레이션 추적테이블 없음

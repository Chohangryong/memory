---
name: project-bumoro-2gi
description: "부모로 2기 — 부모 커뮤니티 피벗 (~/Desktop/부모로2기/, Chohangryong/bumoro2, bumoro2.vercel.app). v1 아카이빙 완료(2026-08-08), 인프라(도메인·Supabase·Vercel·Resend) 전부 승계, 컨셉 브레인스토밍 전 단계"
metadata: 
  node_type: memory
  type: project
  originSessionId: 8ab03d28-52d7-4872-b304-fd35056643b2
  modified: 2026-08-09T07:22:18.125Z
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
2. ~~cl-export 크론 실패~~ → **해결(2026-08-08)**: 원인=Actions Secret 미등록(워크플로 생성 후 0성공, env 빈값 exit 2). `CL_EXPORT_SUPABASE_URL_PROD`·`CL_EXPORT_SERVICE_ROLE_KEY_PROD`를 v1 .env에서 등록(secret 파이프는 분류기 차단 → 사용자 `!` 명령으로 등록, AI의 권한 자가수정도 하드차단됨). 수동 실행 성공, export 커밋 2ef1273.
3. ~~커뮤니티 컨셉 브레인스토밍~~ → **완료(2026-08-09)**: 설계 v2 확정 = "밤에 여는 부모 커뮤니티"(스펙 docs/superpowers/specs/*.html, 정책DB 제외·토스 규칙 9개·익명 발행). 구현 계획 1(커뮤니티 코어 8태스크, plans/2026-08-09-community-core.md) **v2 = 적대적 감사 반영 완료, 실행 방식 결정 대기**(서브에이전트 vs 인라인).

## 커뮤니티 코어 완료 (2026-08-09, main dd2e935)

8태스크 서브에이전트 실행(구현·리뷰 전부 Opus, 메인 조율만 Fable→Opus) + 태스크별 독립 리뷰 + 최종 전체 리뷰 fix wave. **34 tests, main 머지 완료, 브랜치 삭제.** 동작: 익명 발행(가입 0)·keyset 무한스크롤 피드·펼칠 때 로드하는 인라인 댓글·도움돼요·`/p/[id]` 공유 착지점.

**리뷰가 잡은 실결함 6건**(전부 계획 코드에 있던 것, 실측 재현 후 수정): anon 키로 전 사용자 notify_email 덤프 / permanent 제재가 warning 행 추가로 해제(옛 쿼리로 회귀 증명) / 무한스크롤 실패 시 loading 플래그 고정→영구 정지 / ensureSession upsert 실패 은폐(DO NOTHING 시 빈 데이터 반환 재현) / `/p/[id]`가 조회 실패를 404로 위장 / 다크 기기 본문 대비 1.1:1 불가독(밤 제품인데).

**night-layer 필수 인계**: ① 본인 글·댓글 삭제 경로 부재(RLS DELETE 정책 없음·deleted_at grant 없음 — 개인정보 담긴 글을 본인이 못 지움) ② 쿨다운이 RLS 가시 글만 카운트 → 모더레이션 태스크의 하드 선행조건 ③ FeedItem 매핑 2곳 복제 → 첫 태스크에서 fetchPost 추출 후 필드 추가 ④ globals.css `color-scheme: light`는 밤 모드 설계 시 의도적 복원 지점 ⑤ Server Action 자동 테스트 0 — 게이트 수정 시 테스트 통과 수치를 근거로 삼지 말 것 ⑥ 회원 계층 7건(승격·탈퇴·정리크론·열람RPC·고지·/me·글삭제).

**INFRA.md 위험 정정**: 2기 마이그레이션의 `grant ... to anon`을 v1 프로젝트에 적용하면 정책 524건·가입자 25명 전면 개방 — 문서에 경고 명문화, `s2_` 접두사 방침 폐기(2기는 빈 프로젝트).

## 회원 관리 리서치 (커뮤니티 10곳, docs/research/)

레딧이 우리와 동형: 익명 시작 + "이메일 = 계정 복구의 유일한 열쇠" 고지 + 승격 시 닉네임·글 승계. 탈퇴는 **글 보존 + 작성자 익명화**가 유일 권장(전량 삭제=스레드 파괴, 삭제 불가=민원). /me는 "본인에게 전부, 남에게 최소"·받은 반응 1급 메뉴·공개 프로필 없음. 자녀정보는 마미톡형(수집하되 표면 노출 0). **금지**: 매너온도류 점수, 활동량 등업, 전화번호 루트 키, 자녀정보 제3자 제공, 신뢰신호 유료화.

## 감사에서 확정된 기술 함정 (2026-08-09, 재사용 가치 높음)

- **PostgREST 임베드는 노출 스키마 간 FK 필수** — post.user_id가 auth.users를 참조하면 `profile(nickname)` 임베드가 PGRST200으로 실패. public.profile을 직접 참조해야 함(라이브 재현 확인).
- **Next.js Server Component는 쿠키 쓰기 불가** — 페이지에서 signInAnonymously 하면 세션이 매 요청 유실 + 익명 rate limit(30/h/IP) 소진. 세션 생성은 Server Action 전용 + proxy.ts(updateSession)가 토큰 갱신 담당.
- **Supabase 마이그레이션에 GRANT 블록 필수** — RLS 이전 롤 권한 단계에서 42501 전면 거부.
- **create-next-app은 비어있지 않은 폴더에서 즉시 exit 1**(README.md도 허용 목록에 없음) — 임시 디렉토리 생성 후 복사가 정석.

## 함정 승계 (상세는 INFRA.md)

- dev 브랜치 미공개 기능(flag OFF) 다수 → **dev→main 머지 = 운영 배포, 금지**
- v1 `.env`=prod SERVICE_ROLE / `.env.local`=dev — 스크립트 대상 확인 필수
- hotdeal-sidecar launchd 데몬 + worktree `.claude/worktrees/hotdeal-sidecar` 삭제 금지
- supabase link 전환식 CLI: prod 작업 후 dev 복귀 필수, 마이그레이션 추적테이블 없음

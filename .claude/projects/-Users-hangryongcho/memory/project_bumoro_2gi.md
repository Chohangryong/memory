---
name: project-bumoro-2gi
description: "부모로 2기 — 부모 커뮤니티 피벗 (~/Desktop/부모로2기/, Chohangryong/bumoro2, bumoro2.vercel.app). v1 아카이빙 완료(2026-08-08), 인프라(도메인·Supabase·Vercel·Resend) 전부 승계, 컨셉 브레인스토밍 전 단계"
metadata: 
  node_type: memory
  type: project
  originSessionId: 8ab03d28-52d7-4872-b304-fd35056643b2
  modified: 2026-08-09T08:17:58.472Z
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

## ⚠️ 신원 모델 = "게스트 세션 + 계정 승격" (레딧 모델 기각, 2026-08-09 1차 검증)

**"레딧형" 명명 폐기.** 레딧은 이메일이 없어도 사용자가 아는 자격증명(id+pw)을 항상 보유 → 대가는 복구 실패 하나, 이동은 언제나 가능. 우리 signInAnonymously는 사용자가 아는 자격증명 0개(쿠키만) → 복구+이동 둘 다 상실. **레딧은 오히려 자격증명 없는 세션의 게시·댓글·투표를 전면 금지**(익명 열람 30분 종료). 가져올 원칙은 "이메일 필수"가 아니라 **"회수 가능한 자격증명 최소 1개"**. 용어: 레딧모델→게스트 세션+계정 승격 / 익명 회원→미승격 게스트 / 이메일은 선택→회수 수단 미확보.

**🚨 데이터 손실 위험**: profile→auth.users ON DELETE CASCADE + post/comment→profile CASCADE. auth 1행 삭제 = 글 전멸. **Supabase auth 서버에 익명 30일 자동삭제 코드 실재(cleanup.go, PR#1497), 호스티드 활성화 여부 비공개** → 탈퇴 기능 없어도 글이 사라질 수 있음. profile을 신원 tombstone으로 분리(정석안 확정)하기 전엔 클라우드에 실사용 데이터 금지.

**Supabase 승격 확정 사실**: ①@supabase/ssr이 PKCE 강제 → **이메일 링크는 카톡인앱↔사파리에서 100% 실패**, 6자리 OTP 단일 경로 ②'Change Email Address' 템플릿에 `{{ .Token }}` 없으면 코드 미발송·조용한 실패 ③확인 전 이메일은 선점 안 됨(email_change는 중복검사 미포함) → 두 게스트 동시 신청 가능 ④확인 후 refreshSession() 필요(기존 토큰 클레임은 is_anonymous=true 유지) ⑤익명은 비밀번호 설정 서버 거부 ⑥기기이전은 signInWithOtp({shouldCreateUser:false}) 필수 ⑦Manual Linking 토글 안 켜면 소셜 연결 즉시 실패 ⑧익명 rate limit 30/h/IP 조정불가 가정(NAT+카톡 동시유입 시 조용한 진입실패) ⑨정리크론은 공식예시(30일) 쓰면 활성 작성자 글까지 삭제 → "글 0건 게스트"만.

**사용자 확정(2026-08-09)**: 신원구조=정석안(profile 자체PK+auth_user_id nullable) / 밤모드=시간이 결정(22-06 무조건 밤, 기기설정 무관) / 클라우드=T8 시점 bumoro-dev 일시중지 승인 / 승격=이메일 OTP 단독(카카오는 실기기 실험 후) / 탈퇴=글 보존+익명화+일괄삭제 옵션 병기.

**착수 전 결정 7건 전건 확정(2026-08-09)**: ①이메일 통합(승격용=아침알림 수신처 동일값, "답 오면 알려드릴까요?"로 묻고 계정회수는 부수효과) ②승격유도=발행직후 인라인카드, **닫으면 끝**(재권함 없음, /me에 "회수수단 미확보" 상시표시) ③**게스트정리=최종활동일 30일**(아래) ④어드민=**Vercel 배포보호**(플랜 미지원 시 env 비번) ⑤월령뱃지=구간표시("돌 무렵", 월단위는 생일역산됨) ⑥복구코드 1차 제외 ⑦탈퇴 시 글삭제 체크박스 **기본해제**.

**⚖️ 미활동계정 정리 = 법적 강제 없음(전수조사 완료)**: **휴면계정 1년 규정(개인정보보호법 제39조의6)은 2023.9.15 폐지** — "30일 안 지우면 불법"은 폐지조문 인용이니 쓰지 말 것. 법 요구는 셋뿐: ①기간을 **숫자로** 정할 것(작성지침, "일정기간후"는 위반) ②처리방침 공개(제30조, 미공개 1천만원) ③정한 기간 지나면 실제 파기(제21조 지체없이=표준지침 5일내, 3천만원). 리스크는 '지우면 위험'이 아니라 **'안정하고 방치하면 위험'**(CNIL→Discord 80만유로 사유). 짧은 삭제는 제3조 최소보유와 정합.
**30일 확정 근거**: ①**읽기 방문자는 계정 미생성**(ensureSession이 app/actions.ts:84·128·193 쓰기액션 3곳에서만 호출, 실측) → "두달뒤 복귀" 반론 무효, 빈게스트=게이트에 튕긴 잔여물 ②Firebase 익명계정 30일 삭제·승격계정 제외=우리와 동형 모델, Supabase 공식예시도 30일(구글/디스코드 2~3년은 실명·결제계정이라 성격 다름) ③v1 실측 +30일 복귀 0.3%. **삭제조건에 글0건만 쓰면 안 됨** — notify_email·child_birth_date NULL(글 안 써도 사용자 입력값) + user_sanction 부재(CASCADE라 제재이력 유실=회피창구) 추가. 기준은 created_at이 아니라 **profile.last_seen_at**(신설, T3) — auth.users.last_sign_in_at은 익명계정서 토큰갱신에 반응 안 함. 매일1회(월배치는 5일내 파기 위반). 처리방침 초안=docs/legal/2026-08-09-privacy-policy-draft.md(게시 전 확정필요 3건: IP·UA 90일=통비법 추정치·**애초에 IP 미저장이 제58조의2 익명정보에 가까워져 리스크 축소 효과 더 큼**, 신고기록 1년=관행값, 실제 저장항목 미확인).

**night-layer 계획**: plans/2026-08-09-night-layer.md, 12태스크. 하드 의존 T1→T2, T3→T4·T8·T10, **T5→T6(테스트 하니스 없이 모더레이션 금지)**. 실기기 검증은 T2/T7=LAN, **T8 Step0=Vercel Preview+SMTP(카톡인앱·이메일 최초 검증)**, T12=프로덕션. 최대 일정 리스크=T8 Step0 지연.

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

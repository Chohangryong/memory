---
name: project_auth_email_smtp
description: 부모로 인증메일 이슈 2종. ①미수신=Supabase 커스텀SMTP 미설정·기본메일 시간당한도(429 over_email_send_rate_limit)·한국메일 전달률저조. 재전송버튼+프론트1분쿨다운(de4c487) dev+운영. ②링크만료 재인증 dead-end(2026-06-03)=인증 안 하고 24h경과→링크 만료(auth로그 "email link has expired")→로그인하면 email_not_confirmed 차단만, 재전송버튼이 회원가입성공 블록에만 있어 재인증 경로 부재→영구잠김. fix 948399e(dev): login()이 needsResend 반환+error.code==email_not_confirmed 감지+로그인 에러블록에 재전송버튼. SMTP 근본해결 보류. disposable도메인 가입차단. signup 429→generic에러.
metadata: 
  node_type: memory
  type: project
  originSessionId: b6c89b16-50a0-400a-89d9-8f1d7450ff1b
---

2026-06-01 인증 메일 미수신 진단·대응.

**근본 원인 (라이브 재현):** dev·운영 Supabase 모두 **커스텀 SMTP 미설정** → 기본 내장 메일(`noreply@mail.app.supabase.io`) 사용. 기본 메일 한계 = ① **시간당 ~2~3건 전역 rate limit**(`over_email_send_rate_limit` 429를 테스트 중 실제 재현), ② 한국 메일(naver/daum) 전달률 저조, ③ Supabase 공식 입장 "운영 금지". gmail엔 발송 확인됨(mail.send 로그). dev 가입자는 1명(hrocho@naver.com, 05-27 22초만에 인증성공=한도 안이라 통과).

**구분 주의:** "이미 가입된 이메일 재시도"는 설계상 **무발송**(`user_repeated_signup` 200, 메일 안 옴)이라 별개 이슈 → UX 안내(B안 0b3412b)로 해결. 진짜 미수신은 **신규 가입인데 한도/전달률**.

**대응(완료, dev+운영 배포):** 재전송 버튼(`dae9859`) + **프론트 1분 쿨다운**(`de4c487`, app/login/page.tsx). 쿨다운=가입성공 직후·재전송 클릭 시 60초 카운트다운(Supabase 사용자별 최소간격 60초에 맞춤). 로컬 검증 완료(60→0 비활성↔재활성). **⚠️ 쿨다운은 "한 유저 연타 방지"일 뿐 서버측 전역 시간당 한도는 못 막음 → 미수신 근본해결 아님.**

**SMTP 근본해결 = 사용자 보류 결정.** 도입 시 필요 3종(도메인 소유만으론 불가): ① SMTP 제공자(Resend 무료3천/월·SES·Postmark) ② bumoro.kr DNS에 **SPF/DKIM/DMARC** 인증레코드 ③ Supabase Auth SMTP 폼(host/port/user/pass) 입력. 제공자 기본도메인(resend.dev) 발송은 DNS인증 생략되나 전달률·신뢰도↓ 비권장. 운영 가입자 증가 시 재검토 권고. → [[project_next_task]]

**2026-06-03 추가 — 링크 만료 재인증 dead-end (별개 이슈, fix 948399e dev):** `hrcho1995@gmail.com`이 06-01 가입 후 인증 안 함 → 06-03 옛 링크 클릭=auth로그 `GET /verify "email link has expired"`(메일은 **왔음**, 미수신 아님 — 기본 인증링크 TTL 24h 초과) → 비번 로그인 `POST /token email_not_confirmed 400`. 코드 결함: 재전송 버튼이 `app/login/page.tsx` **회원가입 성공 블록(state.success)에만** 존재, 로그인 에러블록(state.error)엔 없음 → 만료 후 돌아온 유저는 새 인증메일 받을 화면 경로 0 = 영구잠김. **fix(948399e):** `actions.ts login()`이 `error.code==="email_not_confirmed"`(문자열매칭→code 강화) 시 `{error,needsResend:true}` 반환, `page.tsx` 에러블록에 기존 재전송 핸들러(startResend/cooldown/email state) 재사용 버튼 노출. 빌드✓·dev푸쉬, 운영 미반영. 코덱스 검증: 진단·최소수정 맞음, error.code 전환 권장 채택. 보류 follow-up: 재전송 429쿨다운 일관화·resendConfirmation 공개호출 throttle·mailer_otp_exp 연장은 근본해결 아님(링크는 만료돼야 하고 재요청 경로가 정답). 진단=`get_logs(auth)`에 expired/email_not_confirmed 동시출현이 신호. [[project_google_oauth]]

**부수 발견:** Supabase signup이 disposable 도메인(.dev, mailinator) 차단=`email_address_invalid` 400 → 로컬 QA는 실도메인 필요. `actions.ts` signup이 429를 generic "회원가입 중 오류"로 매핑(over_email_send_rate_limit 전용 안내 없음)=follow-up 후보. 로컬 .env.local은 운영(pfwr) 가리킴 → dev QA시 dev(lqqc)로 스왑(anon키는 sb_publishable, 공개키). 진단도구: MCP `get_logs(auth)` + `auth.users` 조회. [[reference_bumoro_infra]]

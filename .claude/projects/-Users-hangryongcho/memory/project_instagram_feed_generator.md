---
name: instagram-feed-generator project status
description: Instagram Feed Generator 프로젝트 현황 — Phase 3 게시 예약 머지 완료. IG /media 9004/2207052 차단 이슈(2026-03-13~) Cloudinary로 마이그레이션 완료(2026-04-27). R2/S3/CloudFront 모두 차단됨, Cloudinary 통과 확인. `IMAGE_HOST=cloudinary` 환경변수 토글로 R2 폴백 가능.
type: project
originSessionId: aee1c5b5-ef58-4600-89f4-107b66db635a
---
## Instagram Feed Generator — 프로젝트 현황 (2026-04-26)

### Phase 3 — 게시 예약 (Post Scheduling) 머지 완료
- master `d5a694e` (2026-04-26 머지). 28 commits, 185 tests passed.
- Spec: `docs/superpowers/specs/2026-04-26-post-scheduling-design.md`
- Plan: `docs/superpowers/plans/2026-04-26-post-scheduling.md`

**기능**: 캐러셀 생성 후 "🗓 게시 예약" 버튼 → KST 일자/시간 picker → 예약 시각에 자동 IG 게시. 즉시 취소 / 예약 목록 / 놓친 예약 Slack 프롬프트.

**핵심 설계**:
- `post_history.json` 단일 진실 소스 + 모듈 레벨 `_history_lock` (RLock)
- `status` 필드: `"scheduled"` | `"posted"` (legacy 항목은 자동 마이그레이션)
- 재예약 시 `previous` 백업 → 취소 시 posted 복귀
- R2 업로드는 예약 시점, 게시 시점은 IG API 호출만
- `_scheduled_publish` 진입 시 in-process 락 (retry/missed_now 동시 클릭 방지)
- listen 시작 시 `_restore_scheduled_posts`: 미래 → APScheduler 재등록, 과거 → `send_missed_post_prompt`

**Picker UX 학습**:
- Slack datepicker는 `initial_date` 없으면 사용자가 클릭만으론 콜백 미발사 (선택 변경 시에만). 반드시 `initial_date`/`initial_time` default 설정.
- `_post_schedule_state`는 confirm 후 pop X (5분 가드 거절/재시도 시 같은 picker 재사용 가능). 새 picker open 시점에만 cleanup.

### 🚨 인프라 이슈 (글로벌, 우리 코드 무관) — R2 custom domain 매핑 진행 중 (2026-04-26)
2026-03-13 이후 IG Graph API가 일부 도메인의 `image_url` fetch를 거절. error 9004/2207052 "Only photo or video can be accepted as media type". `pub-*.r2.dev` (Cloudflare R2 default public URL)도 영향. mixpost 등 운영 서비스도 미해결.
- 검증: 즉시 게시도 동일 400 (예약/즉시 흐름 모두 영향, 우리 코드 무관)
- 2026-04-26 재검증: R2 1080×1080 정상 JPEG, CT=image/jpeg, GET 200인데 IG /media 400. 동일 조건 dummyimage.com → 200. → R2 default 도메인 차단 확정.
- 4/25 마지막 자동 게시 성공, 4/26 이후 자동 게시 모두 실패 (수기 게시로 우회 중)
- 참고: mixpost issue #197 (https://github.com/inovector/mixpost/issues/197)

**진행 상태 (2026-04-27 00:05 KST):**
- Cloudflare zone `objectory.co.kr` Active ✅ (zone-id `a1b1579a03e7930bcd38f3012fa54b56`, account-id `ec7237f2235c1b746b6a8de9f0aacdb9`)
- R2 Custom Domain `cdn.objectory.co.kr` 연결 + SSL 발급 ✅ → IG /media 400
- R2 Custom Domain `img.objectory.co.kr` 신규 발급 ✅ → IG /media **즉시 400** (negative-cache 가설 폐기)
- `.env`: `R2_PUBLIC_URL=https://cdn.objectory.co.kr` (현재) — 4/26 23:36 thunderbolt 게시 실패 시 사용된 도메인. 실패 후 R2 객체는 자동 삭제됨.

### 2026-04-26~27 시도 내역 및 결과 (상세)

**1. negative-cache 우회 시도 (가설: Meta가 호스트 단위로 robots.txt 결과를 캐시)**
- Cloudflare에서 Block AI bots OFF, BIC OFF, robots.txt `Allow: /` 업로드 → 변화 없음
- 신규 서브도메인 `img.objectory.co.kr` 발급 → 첫 요청부터 9004 → **호스트 단위 캐시 가설 폐기**

**2. Cloudflare R2 UI 버그**
- R2 Custom Domains UI에서 `img.objectory.co.kr` Connect 시도 → "That domain was not found on your account" 반복 (계정 1개, zone Active, 같은 account-id 확인됨)
- placeholder CNAME 사전 생성/제거 둘 다 동일 에러
- **wrangler CLI 우회 성공**: `npx wrangler r2 bucket domain add instagram-feed-images --domain img.objectory.co.kr --zone-id a1b1579a03e7930bcd38f3012fa54b56 -y` → 즉시 연결+SSL 발급
- 결론: UI 버그. 향후 R2 Custom Domain 작업은 wrangler CLI로.

**3. 검증 결과 (img.objectory.co.kr)**
- `curl -I` → 200 OK, image/jpeg, 219KB
- Meta UA(`facebookexternalhit/1.1`, `meta-externalagent/1.1`)로 fetch → 200 OK
- robots.txt → `User-agent: * / Allow: /` 정상
- 같은 토큰으로 `dummyimage.com/1080x1080/000/fff.jpg` IG /media → 200 (id 발급)
- 같은 토큰+파라미터로 `img.objectory.co.kr/scheduled/.../slide_01.jpg` IG /media → **9004/2207052** "미디어 다운로드에 실패. 미디어 URI가 요구사항을 충족하지 않습니다"

### 원인 추정 (현재 가설)

**가장 유력**: Meta가 R2 백엔드 인프라(전체 R2 IP 풀 또는 R2 Custom Domain의 cf-ray 패턴) 단위로 차단.
- 근거 1: 같은 zone 위 두 서브도메인(`cdn.`, `img.`) 모두 즉시 차단 — 호스트 단위 캐시면 신규 도메인은 첫 요청 통과해야 함
- 근거 2: Cloudflare anycast IP는 dummyimage.com과 같은 풀이지만 dummyimage는 통과 → IP 단위 차단은 아님 (또는 R2 origin이 식별 가능한 별도 시그니처를 남김)
- 근거 3: mixpost issue #197(https://github.com/inovector/mixpost/issues/197) 등 다른 운영 서비스도 R2 커스텀 도메인에서 동일 증상 보고

**모르는 부분**:
- Meta가 R2를 어떻게 식별하는지 (응답 헤더? cf-ray 분석? origin AS?)
- zone 단위 차단인지 R2 백엔드 단위 차단인지 — 같은 zone에 R2 아닌 정적 파일(예: Pages)을 띄워 비교해야 확정 가능
- 영구 차단인지 일시적 차단인지 — Meta 공식 발표 없음
- 우리 IG 계정/앱 단위 차단 가능성 (낮음 — dummyimage 통과로 계정/앱은 정상)

### 2026-04-27 추가 검증 — S3/CloudFront도 차단, Cloudinary 통과 확인

**추가 시도 결과 (모두 IG /media 9004/2207052)**
- AWS S3 직접 퍼블릭 (ap-southeast-2, `instagram-feed-images-objectory`) → 400
- S3 + CORS (Origin/AllowedMethods/ExposeHeaders 정책 추가) → 400
- S3 + CloudFront (OAC, CachingOptimized, redirect-to-https, Cache-Control immutable) → 400
- S3 + CloudFront + Response Headers Policy (CORS + nosniff override) → 400

**추가로 시도해본 다른 호스트**
- `gstatic.com` (Google CDN), `picsum.photos`(imgix backend) → 400
- `upload.wikimedia.org`(envoy server, 풀 CORS) → 200
- `dummyimage.com` (Cloudflare proxy, dynamic 이미지 서비스) → 200
- **Cloudinary** (`res.cloudinary.com/<cloud>/image/upload/...`) → 200 ✅

**최종 원인 추정 (정설은 아님)**
- Meta IG image fetcher가 **클라우드 오브젝트 스토리지 / 일부 이미지 CDN 호스트 패턴**을 식별해 거절. R2, S3, CloudFront, Google gstatic, imgix 등이 영향.
- 식별 메커니즘 미상. 응답 헤더(CORS, nosniff, Server)·CDN 캐시 상태·ASN/IP 단독으로는 설명 불가 (CORS 추가/Response Headers 변조 모두 효과 없음).
- mixpost issue #197 외 여러 SaaS가 같은 시기에 동일 증상 → Meta의 의도적 정책 변경(2026-03-13~)으로 추정.
- 정확히 무엇을 트리거로 거절하는지는 **모름**. Cloudinary는 일단 화이트리스트(또는 패턴 미일치)로 통과.

**중요 학습**
- **R2 Custom Domain UI 버그**: "domain not found on your account" 에러가 같은 계정 zone인데도 발생. wrangler CLI로 우회 가능: `npx wrangler r2 bucket domain add <bucket> --domain <fqdn> --zone-id <id>`
- **CloudFront Response Headers Policy**로 CORS/nosniff 추가는 가능하지만 IG /media 우회에는 무효.
- **검증 패턴**: 호스트 변경 시 IG /media에 직접 POST해서 9004 회귀 즉시 확인 (1초). 가설 폐기 빠르게 가능.

### 마이그레이션 완료 (2026-04-27)

**구조**
- `src/core/cloudinary_uploader.py` 신규 — `R2Uploader`와 동일 인터페이스(`upload(local_path, remote_key) -> url`, `delete(remote_key)`). public_id는 확장자 제거.
- `src/core/image_uploader.py` 신규 — `get_image_uploader()` 팩토리. `IMAGE_HOST` env로 `cloudinary`/`r2` 선택. 기본값 cloudinary.
- `src/agents/github_hot_repo/agent.py` — 6개 `R2Uploader(...)` 인스턴스화 블록 모두 `get_image_uploader()` 호출로 교체. 변수명 `r2`/`r2_cleanup` 유지(최소 diff).
- `requirements.txt` — `cloudinary>=1.40.0` 추가.
- `.env` — `IMAGE_HOST=cloudinary`, `CLOUDINARY_CLOUD_NAME`, `CLOUDINARY_API_KEY`, `CLOUDINARY_API_SECRET` 추가. R2 변수는 보존.

**E2E 스모크 테스트 결과**
- 실제 슬라이드(1080×1620 progressive JPEG) Cloudinary 업로드 → IG /media 200 (`id=18049101224571410`) → delete 정상.
- 기존 `tests/test_r2_uploader.py` 3건 통과 (R2Uploader 코드는 미변경).

**보안 메모**
- API Secret이 채팅 컨텍스트에 노출됐음. 운영 안정화 후 Cloudinary 대시보드 → Access Keys → Generate New로 회전 권장.
- Cloudinary 무료 플랜: 25GB 스토리지, 25GB egress/월. 현재 사용량 충분.

**TODO (운영 안정화)**
- [ ] listen 모드에서 실제 캐러셀 자동 게시 1건 검증 (E2E 시도)
- [ ] 자동 cleanup 정책 — Cloudinary는 기본 영구 보관. 게시 후 즉시 delete 호출은 코드 그대로 동작하지만, 실패 시 잔존 객체 정기 청소 스크립트 검토.
- [ ] Cloudinary API Secret 회전 후 .env 갱신
- [ ] 기존 R2 버킷에 남은 schedule된 객체 정리 (구버전 URL이라 cancel→재예약 필요)

### 폐기된 R2 인프라 (참고용으로 유지)
- Cloudflare zone `objectory.co.kr` (zone-id `a1b1579a03e7930bcd38f3012fa54b56`, account-id `ec7237f2235c1b746b6a8de9f0aacdb9`) Active
- R2 Custom Domain `cdn.objectory.co.kr`, `img.objectory.co.kr` (둘 다 IG에 막힘. Cloudflare 측 정상)
- Block AI bots OFF, BIC OFF, robots.txt `Allow: /` 설정 완료 (의미 없어졌으나 되돌릴 필요 없음)
- IG가 R2 차단을 풀거나 정책 변경하면 `IMAGE_HOST=r2`로 즉시 전환 가능

## Instagram Feed Generator — 프로젝트 현황 (2026-04-16)

### 프로젝트 요약
GitHub Trending 레포 자동 수집 → LLM 콘텐츠 가공 → 캐러셀 이미지 생성 → Slack 공유 → Instagram 자동 게시 파이프라인.
Python 3.11, Pydantic v2, LiteLLM, Playwright, Jinja2, slack-bolt, APScheduler.
수익화 목표로 인스타그램 계정 운영 중 (팔로워 보유).

### 프로젝트 경로
`/Users/hangryongcho/instagram-feed-generator`

### GitHub 레포
`https://github.com/Chohangryong/instagram-feed-generator` (private)

### 현재 브랜치 상태 (2026-04-16)
- **master (b2f01fb)**: v5.1 + Phase 2 머지 완료
  - 코랄 팔레트 + Feature 딥다이브 + Wanted Sans + 정보 밀도 개선
  - Instagram 자동 게시 (R2 + Graph API + Slack 승인 버튼)
  - 140 tests passed

### Phase 2 완료 항목
- R2 버킷 `instagram-feed-images` + Public URL
- Meta Business Login (instagram-publisher)
- Instagram OAuth 토큰 → `data/tokens/instagram.json`
  - IG 계정: @hot.code.pieces (조각모음)
  - 토큰 만료: 2026-06-15
- `config/settings.yaml`: instagram.enabled: true, auto_publish: false (Slack 승인 버튼 방식)
- 엔드투엔드 동작 확인: rebase 후 listen 모드에서 agent-skills 레포로 전체 파이프라인 성공

### 미구현 (보류)
- Slack 타임아웃/리마인더 — listen 모드에서는 10분 busy timeout으로 충분. 스케줄 모드 본격 운영 시 구현 예정

### 특별판 게시 이력
특별판 소스·카피·캡션은 `docs/specials/YYYY-MM-DD-{topic}.md`에 보관한다 (재사용 참고용).
- 2026-04-17 — Claude Opus 4.7 출시 (Typographic Hero 디자인, 7장 캐러셀) — `special/opus-4-7` 브랜치
- 이전: 클로드 데스크톱 2.0 (`render_special_claude_desktop.py`)

특별판 구조 (기존 템플릿 재활용):
- `render_special_{topic}.py` — SLIDES 데이터 + CSS 오버라이드
- `scripts/upload_{topic}.py` — R2 + Instagram 업로드
- `data/stock_images/{topic}_special/` — Hook 이미지 보관

### 브랜치 정책 (중요)
- **특별판: `special/{topic}` 브랜치에 격리. master로 머지하지 않음.**
  일회성 수작업 스크립트·하드코딩 카피가 공용 코드베이스를 오염시키는 것 방지.
- **일반 기능(예: 이미지 캐시): `feat/{name}` 브랜치 → 완료 시 master 머지.**
  `src/agents/github_hot_repo/` 자동 파이프라인에 통합되는 코드.
- 특별판 중 공용화 가치 있는 로직은 별도 PR로 `src/core/`에 추출.

## 운영·카피 학습
- 인스타 hook 문구는 명사형 종결 필수 — "~예요" 같은 문장형 종결로 LLM이 자꾸 돌아감.
- Slack listen 모드 실행 전 기존 프로세스 확인 필수 — 구버전 프로세스가 이벤트를 가져가면 새 프로세스가 수신 못함.

## listen 모드 데몬화 (launchd, 2026-05-10 확인)
- plist: `~/Library/LaunchAgents/com.objectory.feed-generator.plist`
- 실행: `/Users/hangryongcho/.pyenv/shims/feed-generator listen`, WorkingDirectory=`~/instagram-feed-generator`
- `RunAtLoad=true` + `KeepAlive.SuccessfulExit=false` (비정상 종료 시 재시작) + `ThrottleInterval=30`
- 로그: `~/instagram-feed-generator/logs/launchd.{out,err}.log`
- 제어: `launchctl bootstrap/bootout gui/$(id -u) ~/Library/LaunchAgents/com.objectory.feed-generator.plist`, 또는 `launchctl kickstart -k gui/$(id -u)/com.objectory.feed-generator`로 강제 재시작
- 새 listen 프로세스 띄울 때는 launchd가 자동 복구하므로 plist를 bootout하거나 PID 죽인 뒤 ThrottleInterval(30s) 안에 새 프로세스 띄우기 주의

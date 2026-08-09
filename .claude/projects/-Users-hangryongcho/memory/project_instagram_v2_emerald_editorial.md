---
name: instagram-v2-emerald-editorial
description: "v2 밝은 테마 emerald-editorial 완성 + 퀄리티 루프·design-review rubric 객관 채점 A 도달 — 가로 배너·flow 배치·합산 24자 validator, 터미널 리얼리티·카피 에코 규칙, 4레포 배치 하니스 (2026-08-08)"
metadata: 
  node_type: memory
  type: project
  originSessionId: 08bbcbba-3529-4f1b-9d2c-42ae67ab0171
  modified: 2026-08-08T15:11:55.768Z
---

# instagram-feed-generator-v2 emerald-editorial (밝은 테마) — 2026-08-08 A 등급 수렴

사용자 요청 "v2를 밝은 버전으로 개선" → **emerald-editorial theme pack** 완성(42-agent 감사→32건 수정→7-agent 재검증). 이후 "전문가 수준까지 루프" 지시로 4레포 배치(openwork/airllm/DeepSeek-Reasonix/AI-For-Beginners, `scripts/render_emerald_editorial_batch.py`) 심사 루프 실행: 자체 심사 7.4→8.48/10, 이어 **design-review 스킬(~/.claude/skills/design-review, Skill 도구는 skillOverrides로 비활성 → rubric을 직접 읽어 적용) 기반 객관 감사 3.54→3.74→3.80→3.76/4.0 (A 수렴, AI Slop 전원 A)**. R4에서 심사 지적이 이전 라운드 수정과 상충(배너 위치·어미 통일 vs 다양화)하기 시작 = 수렴 신호로 루프 종료.

**Why:** 구 레이아웃은 하단 데드존·세로 크롭·absolute 겹침이 구조 결함. 루프에서는 "클로저 중앙 240px 데드존, 카피 에코, 터미널 목업 가짜 명령"이 점수를 깎는 3대 축으로 확인됨.

**How to apply (설계·채점 원칙):**
- **객관 채점 방법**: 심사자가 점수를 매기지 않고 finding(카테고리+impact)만 보고 → 스크립트가 A에서 high −1등급·medium −0.5 결정론 계산. 가중치 위계25/타이포20/간격20/색15/콘텐츠15/slop5. 워크플로우 스크립트 재사용: `.../32774474-*/workflows/scripts/emerald-editorial-design-rubric-audit-wf_5a9e46cb-41a.js`
- 스크린샷은 **원본 자산을 컨테이너 비율로 타이트 크롭**(`data/v2/stock_images/openwork_*_band.jpg`)이 근본 해결 — CSS scale 줌은 부분 글자 노출 부작용. v1 저장 이미지는 1080×1350 데스크톱 배경 포함 캡처라 앱 창만 잘라야 함. 하단 28px 화이트 페이드로 절단면 마감
- 클로저 audience 카드는 bottom 앵커 금지(중앙 데드존) → **리드 아래 flow(margin 110px) + 행간으로 흡수**. 클로저 킥커는 FOR YOU(푸터 SAVE THIS와 중복 금지)
- 홀수 그리드 마지막 카드 = **슬림 배너(116px, 가로 배치, align-self:start)** — 그리드에 20px로 붙여야 한 그룹으로 읽힘 (bottom 정렬하면 분리 지적)
- **터미널 목업 리얼리티**: $ 뒤 실행 가능 명령만(자연어 금지), CLI 없는 라이브러리에 가짜 CLI 금지, git clone은 전체 URL/gh, cd는 리포 루트부터, 로그는 ✓/무프롬프트. 개발자 심사자가 `airllm run`(존재하지 않는 CLI)을 즉시 잡아냄
- **카피 에코가 최후의 감점원**: 같은 밸류프롭 문장 재진술은 장당 신규 정보 1개 원칙으로 분산. 단 코어 메시지 1~2회 반복은 정당(심사자 인정). 근거 없는 절대 주장("0분", "사라진다") 톤다운. 리스트 어미는 **리스트 안 통일, 포스트 간 교차**(둘 다 지적받는 지점 — 균형점)
- **명령형 금지 (사용자 직접 피드백 2026-08-09)**: 한다체≠하라체. "-어라/-아라"("저장해 두어라")·"~할 것"은 건방지게 읽혀 불편 — 저장 유도는 이유·조건·명사형으로. 명사+"다" 직결 종결("관리 도구다")도 무뚝뚝 — 명사 종결 또는 서술어 연결. 프롬프트 톤 섹션에 반영됨
- LICENSE 칩 SPDX명 강제, 미확인 시 슬롯 교체(openwork=NOASSERTION 실측). '한 번' 등 2어절 관용구 NBSP. --text-dim #5F6E66(AA)
- validators `_EME_TITLE_ACCENT_MAX=24`, accent 2어절 이상, keep-all, 리스트 개수 하드 제약 프롬프트 명시 — 전부 `src/engine/prompts/themes/emerald-editorial.txt`에 이식 완료
- 테스트 143 passed 유지. 파이프라인 잔여 이슈(README 광고배너 필터, collector 창 경계 클리핑, 모노스페이스 폰트 제약)는 미해결 등록 상태

루프 변경분 커밋 완료(2026-08-08, 997551b~5b7f80d 6커밋: terminal_lines·시그니처 CSS·bleed-ok 가드·desc dedupe validator·프롬프트 규율·배치 하니스). 크롭 자산(data/v2/stock_images/openwork_*_band.jpg)은 gitignore라 로컬 전용 — 하니스 재실행 시 필요.

**운영 통합 완료(2026-08-08~09, ~e80625c 푸시: 그리드·포인트카드 오버플로우 3중 방어(5카드+ desc 42자, points desc 가중폭 52=한글 28자·고정높이+line-clamp)·CLI 세션 env 차단·effort 옵션·호출 계측·명령형 금지 톤·패러프레이즈 에코/비교대상 일관성/콜로케이션 규칙 포함)**: v1 listen 파이프라인(슬랙 버튼·IG 승인·예약)은 그대로 두고 `agent.py handle_selection`의 생성·렌더만 v2 엔진으로 교체. **`FEED_THEME` env(기본 emerald-editorial)로 분기, `FEED_THEME=""` = v1 롤백**. `_generate_v2` = 레포 자체 이미지(노이즈 필터: shields/badge/sponsor 등) → ContentGenerator(claude CLI, CLAUDE_TIMEOUT 기본 600s·FEED_CLAUDE_EFFORT 기본 medium — 생성 실측 부팅+10K프리필 27s, 본체는 출력 4K토큰+검증재시도 배수로 3~10분 변동) → CarouselComposer, 출력 data/v2/outputs. 터미널 줄 폭 validator `_EME_TERMINAL_LINE_MAX=34`(한글 1.85 가중 — LLM이 README 명령 그대로 옮기면 절단, 검증이 축약 재생성 유도 확인). E2E 검증: karpathy/nanoGPT LLM 실생성 5장 2회(README 실측 수치·LICENSE 슬롯 교체·한다체 전부 준수). **자격증명 완비(2026-08-08)**: GITHUB_TOKEN=v1 유효본 복사(200 확인), IG 토큰=v1 data/tokens/instagram.json(ig_user_id 포함, 만료 2026-10-04)을 v2 하드코딩 경로 data/tokens/에 복사(gitignore 확인). INSTAGRAM_ACCOUNT_ID env 불필요(토큰 파일이 소유). **운영 컷오버 완료(2026-08-09)**: launchd plist(com.objectory.feed-generator)를 v2 리포로 전환(python -m src.main listen, WorkingDirectory=v2, 로그 logs/launchd.{out,err}.log, v1 plist 백업 .bak-v1). kaneo 실전 게시 성공(media_id 확보, 단일호출 220초·총 4분). **완전 자동 게시 가동: auto_post_cron="0 7 * * *"(settings.yaml, 빈값=끄기) — weekly 트렌딩 30개→post_history 이력 스킵→별 최고 선택→생성→슬랙 공유→IG 자동 게시→이력 기록, 실패시 슬랙 알림. 드라이런: 첫 대상 Comfy-Org/ComfyUI(★12.4만).** **첫 실전 자동 게시 성공(2026-08-09 07:28, ComfyUI media_id 18100796482964157)** — 단 첫 7시 발동은 실패했었음: ⚠️launchd plist PATH에 ~/.local/bin(claude CLI) 필수(셸 상속 없음), 생성 시간 편차 200~600초+(시간대별)라 CLAUDE_TIMEOUT 기본 900초+생성 1회 재시도 추가. 검증 재생성 포함 총 ~14분. post_history 정합(2026-08-09): v1 정본 150+kaneo=151건 병합, media_id 교정 2(thunderbolt·local-deep-research 재업로드), permalink 백필 67, IG 153건 전수 대조 역방향 누락 0, **codex-plugin-cc IG 중복 게시 2건 존재(삭제는 사용자 결정 대기)**, Archon 등 2건 IG 미확인(상태 유지=중복방지 계속). 백업 data/post_history.json.bak-reconcile. 관련: [[instagram-v2-brainstorm]]

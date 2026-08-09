---
name: project-ax-hackathon
description: "AX 인재전쟁 해커톤 예선 — Codex 플러그인 3개 제출 (무신사 표기검증·MRT 상품정보표준화·삼일PwC 초도감사), 마감 2026-07-10, 로그 원본 제출 필수(편집=실격)"
metadata: 
  node_type: memory
  type: project
  originSessionId: 664f110d-d964-4f26-95aa-91d8c4c16ff8
---

# AX 인재전쟁 해커톤 예선 (hack.primer.kr/rounds/10)

**마감: 2026-07-10 23:59:59** (본선 발표 07-15, 오프라인 본선 07-18). 작업 폴더: `~/Desktop/hackathon`.

## 과제 본질
기업(무신사/삼일PwC/마이리얼트립 중 선택, 사용자는 3곳 모두 선택됨)의 실제 문제를 **공개 자료(AI가 URL로 검증 가능)로 입증**하고 **Codex 플러그인**으로 해결. 문제는 의도적으로 모호 — **문제 정의 자체가 과제** (FAQ 명시). 기업당 별도 플러그인·별도 제출. 마감 전까지 수정 가능.

## 확정 라인업 (2026-07-03, 사용자 결정)
1. **무신사 — musinsa-listing-guard** (스토리 대전환 완료 07-04~05, 하단 참조): 혼용률 검증·정규화, 일본 수출 통관 프레임
2. **마이리얼트립 — mrt-listing-standardizer**: 해외 공급사 상품정보 표준화·검수 (규격 근거가 2017-18 파트너 블로그라 현재성 보강 필요). AI 추천 1위(정산 대사)를 사용자가 기각
3. **삼일PwC — audit-onboarding**: 주기적 지정제 초도감사 온보딩, Open DART MCP. 근거: 금융위 실태조사 42.6%

선택 이유(로그·질문지 정합성 핵심): 사용자 **이커머스 경력** → 상품 리스팅 데이터가 홈그라운드. 경력은 근거로 못 쓰고 선택 이유·설계 품질로만.

## ⛔ 클린룸 절대 규칙 (작업 폴더 세션에서)
사용자 재직 회사 관련 **고유명사·시스템명·프로그램명·경로를 절대 발화/기록 금지** (해당 명칭들은 의도적으로 이 메모리에 기록하지 않음 — 필요하면 사용자에게 "회사 관련 단어"라고만 지칭). 회사 도구의 코드·데이터·문서 반입 금지. 사용자 실무 경험은 "이커머스/물류 실무 경험" 수준까지만 언급.
**백지 원칙 (사용자 결정 07-05)**: 제출 로그는 자기완결이어야 함 — 사전 리서치 결론을 "이미 아는 사실"로 덤프하지 말고, 작업 세션 안에서 검색·실측으로 **라이브 재검증**하며 진행 (근거 URL 재확인, 252건 스캔 새로 실행). 사전 세션 로그는 기밀 보호를 위해 제출 제외. 참고: log-hooks의 save_log.py는 대화 텍스트만 저장(툴 결과·시스템 주입 제외) — 그래도 발화 규율 유지.

## 무신사 스토리 최종 (검증 완료 07-05)
**아크**: 통신판매중개 플랫폼(브랜드 셀프입력) → 혼용률 오기재 실재(무신사 2025-12 무한책임 선언) → 자체실측 252건 중 19.8% 혼용률 검증불가+형식카오스 → 글로벌 성장(일·미 거래액 84%, 역직구) → 일본 세관 2026 단속강화(4/1 품명오기재 통관업자 목록통관 이용정지, **7/21** 검사통지 본신고시 후퇴 財関第740号) → 의류는 HS61/62 분류에 혼용률 상시필수 → 등록시점 자동 검증·정규화 플러그인. 포지셔닝: "해결"이 아니라 **발견 시점을 앞당겨 문제 단가를 낮춤**.
- ⛔금지: "7/1(7월) 혼용률 의무화"(명문규정 없음, 사용자 기억은 통관업자 실무 데드라인), "일본 1위"(근거기사 봇차단→합산84%로), "물량"→"거래액", 동기추정("구색 우선이라 등록"), 주어("세관이 요구"✗→"통관업자가 요구"✓)
- 일본 라벨 공식기준: 소비자청 繊維製品品質表示規程 (지정용어·%내림차순·100%오차-3~+1·80%초과 以上/未満·5%미만 その他·純/正은 100%만) → 스킬의 정규화 목표 어휘
- 산출물: `~/Desktop/hackathon/GUIDE-musinsa.html`(실전 가이드, 사용자가 Codex에서 직접 제작 예정), `research/story-evidence.md`(근거맵 전체), `research/musinsa-listing-scan/`(scan.py·analyze.py·results.jsonl 252건·FINDINGS.md), `research/jp-composition-rules.md`(미작성—규정은 story-evidence에 포함)
- 실측 하이라이트: DEFER 12.3%+NO_RATIO 7.5%=19.8% 검증불가, 치수회피 41.3%, "Leather Jacket→PU100%"·"린넨라이크→COTTON100%" 오인사례, 나이브매칭 오탐(모=울 동의어) → 동의어사전 필요성 증명
- 문항4 재료: ①AI가 "7/1 의무화" 검증실패→1차출처로 7/21 교정 ②모=울 오탐→동의어사전 설계 반려

## 절대 규칙 (실격 사유)
- **AI 대화 로그를 편집·발췌·삭제해 제출하면 실격.** 전 과정 원본 제출 (md/txt/json/jsonl). Claude Code 세션 JSONL(`~/.claude/projects/`)이 원본 — logs/에 복사해 제출. 서브에이전트/워크플로우 로그도 포함할 것
- 대화에 API 키·시크릿 입력 금지 (로그에 남음)
- 근거는 공개 URL만. bot 접속 확인된 URL만 사용 (pwc.com 403, law.go.kr JS렌더 — 배제하거나 archive 스냅샷 병기)

## 제출물 (submission.zip, 기업별 각각, 최대 100MB)
`src/.codex-plugin/plugin.json`(필수) + `src/skills/<이름>/SKILL.md` + `src/.mcp.json`(선택) + README.md + logs/. 질문 5문항(각 800자, 문항3은 1000자, 문항2에 출처 URL 필드). Codex 플러그인은 **실행돼야 함** — CLI 2단계(실측): `codex plugin marketplace add <SOURCE>`→`codex plugin add <PLUGIN>@<MARKETPLACE>`→`codex plugin list`로 확인(상세 SETUP-SKILL.md). plugin.json만 .codex-plugin/ 안에, 나머지는 루트. 경로는 `./` 시작 상대경로.

## 참여 설정·검증 절차 (2026-07-05 완료·검증)
**플랫폼 등록**: 로그인(hrocho2@gmail.com/조항룡), 지원기업 3곳 선택(무신사·삼일PwC·마이리얼트립), 자주쓰는이메일 등록 완료(코드인증).
**빌드 도구 = Claude Code (Codex 아님)**: 사용자는 Claude Code로 제작. 로그수집은 `.claude/settings.json` 훅(Stop+SessionEnd, `${CLAUDE_PROJECT_DIR}` 절대경로)이 담당—검증됨(이 세션 로그가 `logs/claude-code/`에 저장 중). Codex-cwd 함정(주의①)은 사용자에 **무관**. Codex CLI는 오직 최종 '플러그인이 Codex에서 실행됨' 스모크테스트용. ⚠️ Claude Code **서브에이전트/워크플로우 로그는 별도 파일**(`~/.claude/projects/<proj>/<sid>/subagents/…`)이라 Stop훅이 자동수집 안 함 → 사용 시 제출 전 `logs/`에 수동 포함 필요.
**로그훅 설치·검증(적대적 테스트 PASS)**: log-hooks.zip을 각 회사 폴더 루트에 해제. `.claude/settings.json`(Stop+SessionEnd, `${CLAUDE_PROJECT_DIR}` 절대경로), `.codex/hooks.json`(Stop, **상대경로**), `tools/save_log.py`(대화라인만 slim→`logs/<tool>/<sid>.jsonl`, 실패시 verbatim, 항상 exit0). 합성 트랜스크립트로 Claude/Codex 양쪽 대화만 바이트동일 저장·isMeta/tool_use/thinking 제거·엣지(빈/깨진/traversal) exit0·버그0 확인.
- ⚠️ **훅 함정 2가지**: ①Codex는 **반드시 cwd=폴더에서 실행**(상대경로라 밖에서 켜면 `; exit 0`로 로그 조용히 유실). ②save_log.py 쓰기위치=payload `cwd`+/logs(Claude는 보통 루트=일치). → 운영수칙: **AI 도구는 항상 회사 폴더 안에서 켜고, 첫턴 후+제출전 `logs/` 눈으로 확인.** 훅 파일(save_log.py/settings.json/hooks.json/logs)은 주최측 제공→**수정·가공 금지(실격 위험)**.
- **제출 로그 필터 실측**: CLAUDE.md(전역+프로젝트)·글로벌규칙·메모리는 시스템 주입이라 slim 로그에 **미포함**(isMeta·비대화 제거, `# claudeMd` 0건 실측). 대화 발화만 남음 → 사고흐름은 "대화로 근거 서술 + CLAUDE.md/SKILL.md를 산출물 파일로 제출"로 커버. 클린룸 발화규율은 CLAUDE.md와 별개(파일 내용을 대화창에 복창하면 로그에 남음).
**규칙 라이브 캡처** (`musinsa-plugin/docs/RULES.md`): 과제·제출구조(.mcp.json 선택 포함)·5문항 글자수(1:800/2:800+출처URL/3:1000/4:800/5:800)·채점(AI+심사자)·FAQ(일부제출무방·참가기업변경시 기존제출삭제·저작권=참가자본인·정답없음·훅 작업前설치전제)·인터뷰영상=본선문제(예선회피는 규칙아닌 전략). 출처 URL: rounds/10, opportunities/3/submission/new, announcements/132.
**codex CLI**: 깨짐(vendor 바이너리 ENOENT, 0.125.0)→재설치 **codex-cli 0.142.5** 정상. 재발시 `npm uninstall -g @openai/codex && npm install -g @openai/codex`.
**Codex 플러그인 설치(CLI 실측 0.142.5)**: plugin.json 필수=name/version/description(`.codex-plugin/`만, 나머지 루트), SKILL.md frontmatter=name/description. 설치=`codex plugin marketplace add <SOURCE:로컬경로/owner-repo[@ref]/GitURL>`→`codex plugin add <PLUGIN>@<MARKETPLACE>`(또는 `--marketplace`)→`codex plugin list` 확인, 검증 `/skills`·`@`·`$skillname`, 변경 후 재시작 필요. 대안(스킬만 로컬)=`.agents/skills/`에 폴더째(marketplace 불필요). ⚠️초안 `marketplace add ./`는 1단계로만 맞음(이어 plugin add 필요).
**재사용 부트스트랩(검증됨)**: `~/Desktop/hackathon/SETUP-SKILL.md`(스킬 frontmatter 포함) + `bootstrap-company.sh`. `bash bootstrap-company.sh <slug> "<표시명>"` → 새 회사 폴더에 훅·RULES 복제 + CLAUDE.md 템플릿(회사명 자동치환·<PLACEHOLDER> 안내) + logs/ 준비 + 훅 사전점검(exit0). **회사무관 복제**={.claude, .codex, tools, docs/RULES.md}, **회사별 교체**={CLAUDE.md 플레이스홀더, plugin.json name/desc, 스토리·근거(라이브 재수집), 5문항 답변, RULES 말미 본선주제절}. 착수 체크리스트=훅설치·python3·RULES·CLAUDE.md 잔여마커0·plugin.json스텁·**첫턴 logs/ 라이브**·실행컨텍스트정합·codex구동. **제출 절차 단일 체크리스트=`~/Desktop/hackathon/SUBMIT-CHECKLIST.md`**(산출물확인→Codex실행검증→로그취합[서브에이전트 cp 포함]→5문항→zip[src+README+logs]→제출, 참가기업변경 금지·기업별 별도).

## 심사 힌트 (인터뷰 영상, 자막 확보됨 — scratchpad에 transcript)
- 무신사 김상범: "넓은 문제를 좁게 정의하는 능력, 문제-해결책 수미상관, (실패해도) 생각의 흐름" 평가. 엔지니어들이 Codex CLI 사용 중. **본선 문제 = AI 브랜드 발굴·트렌드 감지** (예선에서 피할 것)
- MRT 방태욱: 키워드 "집요함". AI 네이티브(인사평가 반영). **본선 = Open API/MCP 여행자향 빌딩** (예선은 백오피스로 분리)
- 삼일PwC 영상 미공개(~7/7) → 제출 전 확인 필수

## 산출물 위치
- 리서치 결과(24개 후보 랭킹): `/private/tmp/claude-501/-Users-hangryongcho-Desktop/664f110d-d964-4f26-95aa-91d8c4c16ff8/tasks/wowqjn10s.output` (tmp라 휘발 위험 — hackathon 폴더로 백업 권장)
- 영상 자막: 같은 세션 scratchpad `musinsa_transcript.txt`, `mrt_transcript.txt`
- log-hooks.zip: https://github.com/jocoding-ax-partners/axwar/releases/download/v1.0/log-hooks.zip (설치·검증 완료 2026-07-05 — 아래 '참여 설정·검증 절차' 참조)

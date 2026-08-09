---
name: personal-ai-team 하네스 도입 체크포인트
description: 공식 Claude Code Agent Teams + VoltAgent 144개 + agent-teams 스킬 조합으로 전환 완료(2026-05-05). 11명 자체정의(옵션 B) 보류. 첫 실전(heisenberg drift v2) 검토 성공.
type: project
originSessionId: 94fb1543-b502-4d6a-bd74-fcca195b7463
---
## 현황 (2026-05-05 갱신)
- **방향 전환**: 옵션 B(11명 자체 정의 + ceo-orchestrator)는 **보류**. 공식 Agent Teams 기능 + VoltAgent 144개 라이브러리 + 자체 작성 `agent-teams` 스킬 조합으로 전환.
- 이유: Anthropic이 OAuth 차단(2026-04)으로 third-party 하네스가 Max 구독 호환 안 됨. 공식 Agent Teams가 Max 구독 범위에서 가장 안정적.
- 셋업 완료:
  - `~/.claude/settings.json` — `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS: 1`, `teammateMode: in-process`
  - `~/.claude/agents/` — VoltAgent 144개 정의 복사 완료
  - `~/.claude/skills/agent-teams/SKILL.md` — 컨벤션 스킬 (spawn prompt, 결과 보존, gbrain 통합)
- 첫 실전 (heisenberg Notion sync drift v2 검토): 4명 병렬 검토 → APPROVE WITH CHANGES, P0 9개·P1 8개·spike 4개 도출. reports/ + gbrain publish.

## 보존 (구 옵션 B 자료)
- 스펙: `/Users/hangryongcho/docs/superpowers/specs/2026-04-19-personal-ai-team-design.md` (미커밋, 참고용)
- 플랜: `/Users/hangryongcho/docs/superpowers/plans/2026-04-19-personal-ai-team-plan.md` (1865줄, 미커밋, 참고용)
- 옵션 B 재개 트리거: 공식 Agent Teams로 처리 안 되는 케이스 발견 시 (ceo-orchestrator 같은 시스템 페르소나가 진짜 필요해질 때).

## 핵심 설계 결정 (번복 시 스펙부터 수정)
- 옵션 B: 11명 정의 유지, **기본 활성 4명**(ceo-orchestrator/researcher/developer/cto) + **온디맨드 7명**(marketer/strategist/sales/designer + 회사 특화 3명).
- 실행 순서: M1 → M2 → **M5** → M3 → M4 → M6. M5(dotfiles-claude repo)를 M3 앞에 배치 — Windows 회사 노트북이 dotfiles pull로 셋업하기 때문.
- Max 플랜: **$100(5x) 시작**. M6 `/cost` 일일 측정 → Opus 70% 초과 시 $200 업그레이드 or ceo-orchestrator를 Sonnet으로 다운그레이드.
- Anthropic Routines 병행: 로컬 launchd(Mac 19:00/23:00) + TaskSched(Windows 평일 09:00/18:00) 알림 + 콘솔 Routines가 Notion "Side/Work × Standup/EOD" 4개 DB에 원시 데이터 append. 회사 Routines는 정보보안 사전 승인 필수.
- 회사 특화 3명(oms-domain-expert/business-analyst/qa-scenario-writer)은 회사 cwd(`C:\work\oms-main` 등)에서만 활성, dotfiles-claude repo 범위 밖, Mac에는 절대 배치 금지.
- 자연어 라우팅(CLAUDE.md Task 2.4): 팀 위임 표현("팀에게/오케스트레이터에게") → `/task`, 역할 지명("리서처에게") → 단일 에이전트 직접 dispatch.

## 실행 방식 결정 대기
다음 대화 시작 시 아래 중 하나 선택:
1. **Subagent-Driven (추천)** — `superpowers:subagent-driven-development`, fresh subagent per task + two-stage review.
2. **Inline Execution** — `superpowers:executing-plans`, 현재 세션에서 batch 실행 + 체크포인트.

## 재개 방법
"personal-ai-team 이어서" / "M1부터 시작" / "플랜 실행" 등 지시 시:
1. 이 메모리 + 스펙·플랜 파일 읽기 (플랜은 1865줄이라 Read offset/limit 필수).
2. 위 "실행 방식" 재확인 요청.
3. 선택된 스킬 호출 후 M1 Task 1.1부터 체크박스(`- [ ]`) 순차 진행.
4. 실행 전 스펙·플랜 git commit 여부도 사용자에게 확인.

## 주의사항
- 플랜 self-review에서 14개 이슈 전부 수정 완료 (B1·B2 blocker 2 / S1-S4 serious 4 / M1-M4 moderate 4 / m1-m3 minor 4). 재수정 불필요.
- M3/M4 일부는 Windows 회사 노트북 작업 — Mac 세션에서는 복사붙여넣기용 블록 출력에 그침. 실제 실행은 회사 노트북에서 별도 세션.
- Task 5.3은 활성 Claude Code 세션 종료 후 진행 (symlink 전환). 실행 시 별도 터미널 필요.
- 회사 Routines(Task 4.5 Step 3-4)는 NDA·정보보안 승인 없이는 스킵 지시.

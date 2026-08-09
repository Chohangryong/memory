---
name: work style preferences
description: Detailed work style context — supplements ~/.claude/CLAUDE.md global rules
type: feedback
originSessionId: f8329eab-8bb7-42cb-858c-2663526c51ac
---
핵심 규칙은 ~/.claude/CLAUDE.md 글로벌 규칙으로 이관됨.

아래는 글로벌 규칙에 담기지 않은 보충 맥락:

**Why:** 사용자는 "먼저 코드 쓰지 말고 아래만 제안해라" 패턴을 자주 사용.
각 단계(live 실행, 코드 수정, merge, tag, push)마다 명시적 승인을 요구하는 이유는
과거 sweeping refactor로 의도하지 않은 변경이 발생한 경험 때문.

**How to apply:**
- live smoke 결과를 보고 다음 단계 방향을 제안하는 반복 사이클
- 기존 파일 수정 전 반드시 Read로 소스 확인 후 변경 — 확인 없이 바로 Edit 금지
- 커밋은 변경 성격별로 분리 — 기능 변경과 무관한 정리(import 제거 등)는 별도 커밋

---
name: planning-workflow
description: 큰 변경·방향성 결정은 codex review + agent-driven (subagent dispatch); 혼자 임의로 진행 금지
type: feedback
originSessionId: a1ce95f1-7226-461b-9a80-c51c618a1d92
---
큰 spec 변경, 진화 path, 새 단계 결정 등 방향성에 영향 주는 결정은 codex review 거치고 agent-driven (subagent dispatch) 방식으로 work 분담해서 진행한다.

**Why:** 2026-05-05 agent-hub multisession 작업 중, multi-bot dynamic agent 변경 (큰 spec 변경)은 codex review 받았으나, 이후 (B-mini) Claude single-shot, (C2) worker tmux wire, S1~S4 단계 분해 등 후속 결정은 codex 없이 내 판단으로 진행. 사용자가 "계획을 codex와 함께 하고 agent driven 방식으로 해야지 왜 편한대로 하냐"고 강하게 시정 요청. 사용자는 superpowers:subagent-driven-development 패턴을 명시적으로 선호하는데 내가 그걸 우회하고 직접 코드/명령 실행으로 가버린 잘못.

**How to apply:**
- spec 변경, 진화 path, 새 단계 분해 → 먼저 codex review로 sanity check
- review 받은 후 task별 subagent dispatch (subagent-driven-development skill)
- 직접 실행은 단발 검증·log 점검·trivial cleanup에만
- "Auto mode"라 해도 방향성 결정은 confirm + codex 거쳐야 함 — auto mode = 동의된 단계 실행, 새 단계 결정 무자격
- "(B-mini)" 같은 임시 우회 path를 spec 진화로 spawn할 때도 review 필요

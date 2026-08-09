---
name: feedback-docs-html
description: 설계·기획·분석 문서는 마크다운(.md) 말고 HTML로 만든다 — 사용자가 MD 원문을 읽기 어려워함. spec/design/plan/리포트 전부 해당
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 8ab03d28-52d7-4872-b304-fd35056643b2
  modified: 2026-08-09T00:37:41.227Z
---

설계문서·기획서·분석 리포트 등 **사람이 읽는 문서는 마크다운이 아니라 HTML로 만든다.**

**Why:** 2026-08-09 부모로 2기 설계문서를 `.md`로 써서 커밋했더니 사용자가 "MD 문서는 너무 어려워"라며 HTML로 다시 요청. 사용자는 개발자지만 문서를 **브라우저에서 읽는 것을 선호**한다 — 실제로 기존 산출물이 전부 HTML이다(`beta_surveyresult/*.html`, `docs/analytics/weekly-deep-dive-*.html`, `design/announcement-*.html`, `TalkFile_부모로_성장시스템_시안.html`). MD 원문은 표·강조·구조가 기호로 보여서 읽는 부담이 크다.

**How to apply:**
- 대상: spec/design/plan/브레인스토밍 결과/분석 리포트/회의자료 등 **사람이 읽는 문서 전부**
- 제외: README, CLAUDE.md, 자동메모리, 커밋 메시지 등 **도구·에이전트가 읽는 파일**은 MD 유지
- 리포에 커밋할 땐 `docs/**/*.html`로 저장 (기존 관례와 동일)
- 공유가 필요하면 Artifact로 발행해 URL을 함께 제공
- 스타일: Pretendard + 카드형 블록 + 표. 기존 문서(`TalkFile_부모로_성장시스템_시안.html`)의 톤이 사용자 취향
- superpowers:brainstorming 스킬이 `docs/superpowers/specs/*.md`를 지시해도 **이 규칙이 우선** — 확장자를 .html로 바꿔 저장

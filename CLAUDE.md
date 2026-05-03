# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 리포지토리 성격

이 리포지토리는 사용자의 **auto-memory(brain) 저장소**입니다 — 코드베이스가 아니라 markdown 메모리 파일을 git으로 추적하는 문서 리포.

- **루트:** `/Users/hangryongcho` (홈 디렉토리 자체가 git 리포)
- **Remote:** `Chohangryong/memory`
- **추적 대상:** `.claude/projects/-Users-hangryongcho/memory/` 하위 markdown만
- **빌드·테스트·의존성 없음** — markdown 편집과 git 커밋이 전부

## ⚠️ 중요: git add 시 주의

홈 디렉토리가 리포 루트라 `git add -A` / `git add .` 실행 시 **모든 dotfile·시크릿·credential·외부 프로젝트 폴더가 스테이징**됩니다 (`.ssh/`, `.aws/`, `.zsh_history`, `.gitconfig`, 회사·개인 프로젝트 전체 등).

**규칙:**
- 항상 명시적 경로만 add: `git add .claude/projects/-Users-hangryongcho/memory/<filename>`
- 와일드카드 사용 시 반드시 memory 디렉토리로 한정
- `.gitignore`가 비어있으니 패턴 의존 금지

## 메모리 시스템 구조

`.claude/projects/-Users-hangryongcho/memory/` 안에 4가지 타입의 메모리 파일이 있고, `MEMORY.md`가 인덱스로 동작합니다.

**파일 형식 (모든 메모리 공통):**
```markdown
---
name: <메모리 이름>
description: <한 줄 설명 — 미래 retrieval의 검색 미끼>
type: <user | feedback | project | reference>
---

<본문>
```

**타입별 명명 규칙:**
- `user_*.md` — 사용자 프로필·역할·지식
- `feedback_*.md` — 작업 방식 가이드 (rule + Why + How to apply 구조)
- `project_*.md` — 프로젝트 현황·결정 (Why + How to apply 구조)
- `reference_*.md` — 외부 시스템 포인터 (Notion URL, 대시보드 등)

**MEMORY.md (인덱스):**
- `- [filename.md](filename.md) — <한 줄 검색 미끼>` 한 줄 = 메모리 1개
- 200줄 이후는 잘리니 간결하게
- "검색 미끼"는 요약이 아니라 키워드·규칙·패턴을 구체적으로 — retrieval이 작동하려면 필수
- 본문은 절대 MEMORY.md에 직접 쓰지 말 것 (인덱스 전용)

## 메모리 추가·수정 워크플로우

1. 새 메모리 파일을 `memory/` 하위에 작성 (위 형식 준수)
2. `MEMORY.md`에 한 줄 인덱스 추가 (적절한 타입 섹션)
3. **명시적 경로로 git add** (홈 add 금지)
4. Conventional Commits 형식: `docs(memory): <변경 요약>`

## 글로벌 규칙 (`~/.claude/CLAUDE.md`)

이 리포는 사용자의 글로벌 instructions(`~/.claude/CLAUDE.md`, `~/.claude/global-learnings.md`)와 함께 로드됩니다. 핵심:

- **한국어로 소통**
- **최소 변경 원칙** — 요청하지 않은 개선·리팩터·주석 추가 금지
- **승인 기반 워크플로우** — 코드 작성 전 계획 제안 → 승인 후 진행
- **검증 우선** — 변경 후 결과를 직접 확인 후 보고; 확인 불가 시 명시
- **Atomic Commit** — feat/fix/chore/test/docs 타입별 분리, 한 커밋 = 한 논리적 변경
- **Secret 절대 출력 금지**

## 관련 리소스

- **Hermes Agent 설치 기록:** `project_hermes_agent.md` (2026-05-03 사용자 전역 설치, `~/.hermes/`, `hermes setup` 미진행)
- **Secret 스캔:** `~/.claude/scripts/scan-memory-secrets.sh` 주 1회 권장

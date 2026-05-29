---
name: mobile-ui-pitfalls
description: "모바일 UI 함정 4종(2026-05-29 부모로). iOS input<16px 자동줌→화면확대·좌우흔들림, html단독 overflow-x:hidden iOS 무시, 다크모드 gray-100 테두리 카드배경에 묻힘, 다크 FOUC 스크립트 hydration mismatch→suppressHydrationWarning. 데스크톱 에뮬에선 재현 안 됨."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 6700d4e8-a3b4-442c-8791-dd8055c080d0
---

# 모바일 UI 함정 (실기기에서만 보임, 데스크톱 에뮬 재현 X)

부모로 온보딩/결과 화면에서 "운영(실기기)에서만 좌우 흔들림·정렬 이상"을 디버깅하며 확인. 모두 **데스크톱 크롬 모바일 에뮬에선 재현 안 됨** → scrollWidth 측정만으론 못 잡음.

## 1. iOS input 자동 줌 (가장 흔한 "확대된 채 좌우 흔들림")
- **규칙**: input/select/textarea 폰트가 **16px 미만**이면 iOS Safari가 포커스 시 페이지를 자동 확대. SPA 화면 전환 후에도 확대가 유지돼 다음 화면이 "확대된 채 좌우로 밀리는" 현상.
- **Why**: 부모로 온보딩 select/input이 `text-[15px]`, 결과 필터 select `fontSize:13`이었음. 데스크톱엔 자동줌 없어 운영(실기기)에서만 발생.
- **How to apply**: 모든 input/select/textarea 폰트 **16px 이상**으로. 새 폼 요소 추가 시 기본 16px. 공통 클래스(inputClass/selectClass)에서 한 번에.

## 2. html 단독 overflow-x:hidden은 iOS에서 무시될 수 있음
- **규칙**: `html { overflow-x: hidden }`만으로는 iOS Safari가 가로 넘침을 못 막을 때가 있음. **body에도** 줘야 안전.
- **진단법**: 요소별 `el.scrollWidth > el.clientWidth` + `white-space:nowrap` 스캔. nowrap span이 `min-width:auto`인 flex 부모를 콘텐츠 폭으로 부풀리는 케이스 주의(자식에 min-width:0).

## 3. 다크모드 gray-100 테두리가 카드 배경에 묻힘
- **규칙**: 다크모드 `--gray-100`(#212121)이 카드 배경(#1E1E1E)과 차이 3밖에 안 돼 **테두리가 안 보임**. 박스 구조가 사라져 내부 패딩이 "휑한 빈 공간"처럼 보임.
- **How to apply**: 다크모드 카드/박스 테두리는 `dark:border-[var(--gray-300)]`(#424242)로 대비 확보. 프로필·결과 등 다른 gray-100 테두리 카드도 같은 문제 가능(전역 점검 후보).

## 4. 다크 FOUC 스크립트 → hydration mismatch
- **규칙**: `<head>` 인라인 스크립트로 paint 전 `html.classList.add('dark')` 하면, 서버(클래스 없음)/클라(dark) 불일치로 React hydration 경고. **`<html suppressHydrationWarning>`** 추가가 표준 해결(테마 토글 공식 패턴). 자식 진짜 버그는 여전히 잡힘.

## 진단 도구 메모
- Playwright로 모바일 측정 시: 정적 overflow=0이어도 `overflow-x:hidden`이 clip해 안 잡힘. 요소별 scrollWidth/clientWidth, getBoundingClientRect로 화면밖 요소·정렬 좌표를 직접 측정할 것.
- 관련: [[project_mobile_design_overhaul]]

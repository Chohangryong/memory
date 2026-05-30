---
name: project_onboarding_ux
description: "온보딩 화이트모드 UX 개선(2026-05-30) — 가족형태 3택 단일그리드 통합, iOS 키보드 잔류스크롤 보정(실기기 확인완료), 카드 높이고정·진입모션·soft shadow·버튼 button-in-button. high-end-visual-design 스킬 적용. 프론트 작업 종료."
metadata: 
  node_type: memory
  type: project
  originSessionId: 8042eec5-2d54-4238-b869-084172f12409
---

2026-05-30 온보딩(/onboarding) 화이트모드 UX 3건 개선. `high-end-visual-design` 스킬(Soft Structuralism 아키타입 — 흰배경+sky블루+Noto Sans KR)로 재판단 후 구현. dev+운영(bumoro.kr) 배포 완료. 커밋 8f96a82 (3 atomic: style 가족형태 / fix 키보드 / style 카드·버튼).

**무엇을 했나 (파일 = app/onboarding/onboarding-client.tsx, components/onboarding/step-family.tsx, app/globals.css):**
1. **가족 형태 3택 통합** — 기존: 임신준비만 전체폭 버튼으로 분리 + 일반/한부모만 2열 그리드 → 위계 파탄. 변경: 임신준비·일반·한부모를 `grid-cols-3` 단일 그리드 라디오로 통합. 데이터 모델은 `household_type`(string "일반"|"한부모") + `is_pregnancy_prep`(bool) 그대로, isSelected/handleSelect 헬퍼로 분기. 임신준비 선택 시 자녀수 영역 숨김.
2. **iOS 키보드 잔류 스크롤 (fix)** — input 포커스로 밀린 화면이 키보드 닫혀도 복원 안 됨. `focusout`(INPUT/SELECT) 시 `setTimeout(()=>scrollTo(0,0),80)` + `min-h-[100dvh]`→`100svh`(키보드 동적축소 영향 감소). 데스크톱·에뮬 재현불가 → **iOS 실기기 확인 완료(2026-05-30)**.
3. **카드 출렁임·품질 (style)** — 스텝전환 시 카드높이 즉각점프 거슬림. 모바일에도 `min-h-[320px] md:min-h-[360px]` 하한 + `key={currentStep}`로 리마운트 + `.onboarding-step` fade-up 진입모션(translateY+opacity만=GPU-safe, prefers-reduced-motion 대응, globals.css keyframes). `shadow-sm`→soft ambient box-shadow(.onboarding-card). 다음버튼 `rounded-full` pill + 원형 화살표 button-in-button(group-hover 마그네틱).

**Why:** [[feedback_mobile_ui_pitfalls]]의 iOS 뷰포트 함정 계열. 하이엔드 렌즈 핵심 = "즉각 상태변화 금지"(높이 점프→fade-up), "동일 의미는 동일 시각그룹"(가족형태 3택). height 자체는 애니메이트 안 함(GPU-unsafe 회피, min-h 고정+내용물 페이드).

**How to apply:** 온보딩/폼 화면 추가 작업 시 — input 있는 화면은 svh+focusout 복원 패턴 재사용. 카드 높이 출렁임은 min-h 하한+fade-up. 단 같은 step 내 동적추가(자녀 N명)는 본질적 동적높이라 min-h로 못잡음(한계).

**상태:** 3건 모두 완료·검증(②키보드 iOS 실기기 확인 완료 2026-05-30). 장기 온보딩 확장은 [[project_next_task]](특수대상 장애인·기초생활·다문화). **온보딩 프론트 개선 종료(2026-05-30).**

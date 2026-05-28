---
name: next-task
description: "다음 작업: 특수대상 온보딩 확장 + taste-skill 카드 변주 + 섹션 배경 구분"
metadata: 
  node_type: memory
  type: project
  originSessionId: b1048768-ba79-4c30-af67-b02a286ef05b
---

## 다음 세션 예정 작업

**장기 과제:**
- 온보딩에 특수 대상 체크 추가 (장애인/기초생활/다문화) → disabled/basic_livelihood 정책 활성화
- taste-skill 기반 피처 카드 시각적 변주 (현재 동일 패턴 반복)
- 섹션 간 배경 구분 개선

**완료된 사항 (2026-05-28):**
- ~~프로필 UX 개선~~ → 클릭 진입 + 변경 감지 + 토스트 + 병렬 저장
- ~~성능 최적화~~ → getSession 전환 + 매칭 병렬화 + 캐시. cold 1.73s→0.38s (78%↓)
- ~~온보딩 즉시 이동~~ → DB 저장 백그라운드 처리
- ~~유산·사산 정책 노출 결정~~ → #103 출산전후(유산·사산)휴가 급여 discontinued, #107 모성보호육아지원 제목에서 유산·사산 단어 제거(active 유지)
- ~~서울 위기임신 보호출산(#58)·외국인 아동 보육료(#75) discontinued, 서울 다태아 안심보험(#57) 유지~~
- ~~운영 좌우 스크롤 이슈 해결~~

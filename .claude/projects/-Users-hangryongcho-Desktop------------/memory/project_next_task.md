---
name: next-task
description: "다음 작업: 특수대상 온보딩 확장 + taste-skill 카드 변주 + 섹션 배경 구분 (베타 폴리시·디자인 라운드)"
metadata:
  node_type: memory
  type: project
  originSessionId: b1048768-ba79-4c30-af67-b02a286ef05b
---

## 남은 장기 과제

- **특수 대상 온보딩 확장**: 장애인·기초생활·다문화 체크 추가 → disabled/basic_livelihood 정책 활성화
- **taste-skill 카드 시각적 변주**: 현재 동일 패턴 반복, 카드별 시각 차별화 필요
- **섹션 간 배경 구분 개선**: 시각 위계 강화

## 완료된 사항 (2026-05-28)

- ~~프로필 UX 개선~~ → 클릭 진입 + 변경 감지 + 토스트 + 병렬 저장
- ~~성능 최적화 1차~~ → getSession 전환 + 매칭 병렬화 + 캐시. cold 1.73s→0.38s (78%↓)
- ~~온보딩 즉시 이동~~ → DB 저장 백그라운드 처리
- ~~유산·사산 정책 노출 결정~~ → #103 discontinued, #107 제목 변경(active 유지)
- ~~서울 위기임신 보호출산(#58)·외국인 아동 보육료(#75) discontinued, 서울 다태아 안심보험(#57) 유지~~
- ~~운영 좌우 스크롤 이슈 해결~~
- ~~내혜택관리 자세히 보기 버튼 추가~~ → BenefitModal 재사용 + 쿼리 확장
- ~~예상최대지원금 "—" 표시 버그~~ → childcare 카테고리 포함 (부모급여·양육수당 합산)
- ~~시작하기 1초 지연~~ → getMedianIncomeStandards 1시간 캐시
- ~~아동수당 age range 보정~~ → child_age_min=0, max=107개월 (만 9세 미만)
- ~~life_stage code→id 모듈 캐시~~ → matchPolicies DB 왕복 1회 절감
- ~~get_result_bootstrap RPC~~ → profile+children 단일 호출
- ~~/result Suspense streaming~~ → ResultBodySkeleton 즉시 표시 후 정책 데이터 스트림
- ~~Vercel 함수 region icn1(서울)로 변경~~ → Tokyo Supabase RTT 150ms→30ms. 운영 /result Total 1.08s→0.29s(warm, −74%)
- ~~Nav 로그인 상태 플래시 제거~~ → layout.tsx async, server-side session→initialUser prop
- ~~다크모드 FOUC 제거~~ → <head> 인라인 스크립트로 paint 전 dark 클래스 설정

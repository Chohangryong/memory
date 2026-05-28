---
name: next-task
description: "다음 작업: 특수대상 온보딩 확장 + taste-skill 카드 변주 + 섹션 배경 구분 + 베타 region 확장 (마스터 파일 준비됨)"
metadata:
  node_type: memory
  type: project
  originSessionId: b1048768-ba79-4c30-af67-b02a286ef05b
---

## 남은 장기 과제

- **특수 대상 온보딩 확장**: 장애인·기초생활·다문화 체크 추가 → disabled/basic_livelihood 정책 활성화
- **taste-skill 카드 시각적 변주**: 현재 동일 패턴 반복, 카드별 시각 차별화 필요
- **섹션 간 배경 구분 개선**: 시각 위계 강화
- **베타 region 확장**: 동작구 외 지역 추가 시 `data/regions/insert_regions.sql`을 마이그레이션으로 복사. 마스터 데이터 검증 완료(시도 17 + 시군구 261, 행안부 기준). 정책 매핑(policy_region)도 함께 추가 필요.

## 데이터 일관성 추가 점검 후보

- seoul-* 정책 중 일부(2건)가 11590(동작구) row를 가지고 있음 — 의도된 매핑인지 확인 필요. 이번 region 정정 마이그레이션(20260528000003)에서는 건드리지 않음.
- generate_seed.py SCOPE_MAP 외에도 seed 자동화 로직 전반 재검토 (seoul-* / dongjak- 외 prefix 등장 시 매핑 어떻게 처리할지)

## 완료된 사항 (2026-05-28)

### 정책·데이터 정정
- ~~유산·사산 정책 노출 결정~~ → #103 discontinued, #107 제목 변경(active 유지)
- ~~서울 위기임신 보호출산(#58)·외국인 아동 보육료(#75) discontinued, 서울 다태아 안심보험(#57) 유지~~
- ~~예상최대지원금 "—" 표시 버그~~ → childcare 카테고리 포함 (부모급여·양육수당 합산)
- ~~아동수당 age range 보정~~ → child_age_min=0, max=107개월 (만 9세 미만)
- ~~policy_region 잘못된 매핑 정정~~ → seoul-* KR row 28건 + dongjak-* KR+11 row 84건 삭제. 베타 region 사용자가 타 지역 정책 잘못 매칭받던 문제 해소
- ~~generate_seed.py SCOPE_MAP 정정~~ → 회귀 방지

### 코드·아키텍처
- ~~프로필 UX 개선~~ → 클릭 진입 + 변경 감지 + 토스트 + 병렬 저장
- ~~온보딩 즉시 이동~~ → DB 저장 백그라운드 처리
- ~~내혜택관리 자세히 보기 버튼 추가~~ → BenefitModal 재사용 + 쿼리 확장
- ~~Nav 로그인 상태 플래시 제거~~ → layout.tsx async, server-side session→initialUser prop
- ~~다크모드 FOUC 제거~~ → <head> 인라인 스크립트로 paint 전 dark 클래스 설정
- ~~프로필·온보딩 region_id 누락 버그~~ → 실제 시도/시군구 select UI 구현 + region_id 저장. 베타엔 서울/동작구만 등록되어 있어 다른 지역은 마스터 파일 INSERT 대기.

### 매칭 정확성
- ~~region_code 하드코딩 제거~~ → get_result_bootstrap RPC에 region.code 포함, profile.region_code 동적 사용
- ~~matchPolicies nested filter 한계 우회~~ → region_id 직접 필터 + 캐시

### 성능
- ~~성능 최적화 1차~~ → getSession 전환 + 매칭 병렬화 + 캐시. cold 1.73s→0.38s (78%↓)
- ~~시작하기 1초 지연~~ → getMedianIncomeStandards 1시간 캐시
- ~~life_stage code→id 모듈 캐시~~ → matchPolicies DB 왕복 1회 절감
- ~~get_result_bootstrap RPC~~ → profile+children 단일 호출
- ~~/result Suspense streaming~~ → ResultBodySkeleton 즉시 표시 후 정책 데이터 스트림
- ~~Vercel 함수 region icn1(서울)로 변경~~ → Tokyo Supabase RTT 150ms→30ms. 운영 /result Total 1.08s→0.29s(warm, −74%)

### 운영
- ~~운영 좌우 스크롤 이슈 해결~~
- ~~data/regions 마스터 파일 생성~~ → 시도 17 + 시군구 261. 베타 확장 시 INSERT 마이그레이션 참고용

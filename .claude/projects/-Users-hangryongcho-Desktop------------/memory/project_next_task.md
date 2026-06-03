---
name: next-task
description: "다음 작업: 모바일 UI/UX 외부리뷰 대조 후속(P0 되돌리기 2건=소득 주버튼·상세 4버튼 자기유발 + ₩취소선·4카드·로그인 구글준비중버튼, doc=docs/validation/mobile-uiux-review-cross-check-2026-06-03.md) + 특수대상(장애·다문화) 온보딩 확장(장애인가정 17건 정밀화) + 결과카드 금액 헤드라인 개선 + 온보딩 URL PII 보안 + taste-skill 카드 변주. ✅베타 region 확장=서울25구 완료(2026-06-01). 서울22 잔여☎: 입양축하금/백일해 scope·미상금액."
metadata:
  node_type: memory
  type: project
  originSessionId: b1048768-ba79-4c30-af67-b02a286ef05b
---

## 남은 장기 과제

- **모바일 UI/UX 외부리뷰 대조 후속 (2026-06-03, 🔴 P0)**: HTML 외부리뷰(`부모로 모바일 UIUX 개선안.html`, 5/31 배포前 녹화)를 운영 라이브 실측 대조. 대조표=`docs/validation/mobile-uiux-review-cross-check-2026-06-03.md`. **이미개선 7건**(커스텀드롭다운·세전표기·홈퍼스트뷰·날짜밸리데이션·선택카드채움·다크모드라벨·금액보조문구). **되돌리기 P0 2건(5/26 자기유발)**: ①04-② 소득 빈 상태 채움 주버튼이 "소득 없이 전체 혜택 보기"(onboarding-client.tsx:178 라벨토글)→"내 혜택 확인하기" 고정+건너뛰기 텍스트링크 강등 ②08-① 상세시트 4버튼(바로가기/신청완료/관심없음/나중에, benefit-modal.tsx)→주채움+보조테두리 2버튼. **신규 P0**: 06-① 결과 "예상 지원금 ₩5,231,080"(summary-cards.tsx:10)→"523만 원" 한글단위+히어로화 / 06-② 4카드균등→위계. **로그인**: 09-① "구글로 시작하기(준비 중)" 버튼 숨김 / 09-② 비밀번호찾기 링크. **폴리시**: 01-② 둘러보기 버튼화·03 이모지/버튼위계·05 판정칩 상태별색토큰. **미확인(추가QA)**: 07 리스트 필터칩 가로스크롤·정렬분리·금액단위 / 08-② 모달 제목고정→금액가림. [[project_onboarding_ux]]
- **특수 대상 온보딩 확장**: 장애인·기초생활·다문화 체크 추가 → disabled/basic_livelihood 정책 활성화. **🔴 시급도↑(2026-06-01)**: 서울22구 장애인가정 출산/양육지원금 17건을 household=disabled 死게이트 회피 위해 household 미부여로 등록(일반에게도 노출). 온보딩 '장애 가구' 질문 추가 시 그 17건에 household_type=disabled 부여 + HOUSEHOLD_TYPE_MAP 매핑하면 정밀화. [[project_seoul22_discovery]]
- **taste-skill 카드 시각적 변주**: 현재 동일 패턴 반복, 카드별 시각 차별화 필요
- **섹션 간 배경 구분 개선**: 시각 위계 강화
- **결과 카드 금액 헤드라인 개선(2026-06-01 발견)**: `amountToText`(lib/amount.ts)가 amount_breakdown 없으면 amount_text를 헤드라인에 안 써서, 금액(amount_min/max) NULL인 정책(유축기·% 환급·무료서비스)이 헤드라인에 "지원"만 표시(상세는 모달). 동작·강서·송파도 동일=기존 동작이라 회귀 아니라 유지 중. 개선하려면 `amount==null→amount_text` fallback(앱 전체 영향, 184 sigungu 일괄 개선). [[project_seoul22_discovery]]
- ~~**베타 region 확장**~~ → **✅ 서울 25개 자치구 전체 완료(2026-06-01)**. 동작·강서·송파 + 22구 자체사업 148건 운영DB 등록 + `lib/constants.ts` SUPPORTED_SIGUNGU_CODES 25구 확장(온보딩·프로필 화면) 운영 배포. **다음 지역(경기 등) 확장 = 데이터(policy_region)+화면(SUPPORTED) 한 세트.** [[project_seoul22_discovery]] [[project_region_expansion]]
- **온보딩 결과 URL 개인정보 노출 (보안, 2026-05-31 발견)**: `/result?data=<base64>`가 암호화 아닌 base64라 자녀생년월일·월소득·가구형태가 URL에 평문. 유출경로=히스토리/Vercel로그/Referer헤더(외부 detail_url 클릭)/공유. **타인 DB조회는 불가**(get_result_bootstrap 서버 user.id+RLS)—본인 입력이 URL에 실리는 게 문제. 권고: **Supabase Anonymous Sign-ins**(`signInAnonymously()`)로 비로그인도 익명세션→온보딩데이터 DB저장→result 세션기반전환→URL data제거→정식가입시 linkIdentity 연결(데이터보존). 대안 임시토큰테이블. 최소완화(즉시)=Referrer-Policy:same-origin 헤더+로그 쿼리스트링 마스킹. 상세: `docs/security/onboarding-data-url-pii.md`. 규모=온보딩→result 흐름 전반(별도 spec).

## 서울22 확장 잔여 follow-up (비차단, 운영은 이미 live)
- **☎ 미상 금액 채우기**: 강동 입학축하금·강남/양천 장애인가정 출산금(조례·사업 존재 확인, 금액만 미공개). needs_review·노출은 됨.
- **☎ scope 보류 확정**: 입양축하금(중구·구로·금천·은평·종로 = 서울시 200만 대행 vs 구 조례 구비, 확실 sigungu=광진·강북·서대문)·백일해 Tdap(서울 시통일 vs 구별, 감염병관리과 02-2133-7668)·노원 복합(문화상품권/돌사진/작명 별도사업 분리). [[project_seoul22_discovery]]
- **amount_breakdown JSONB·parent_friendly_copy 백필**: 출생순서 차등(출산금)·UX 카피 미충전분.
- **임신부 national 태깅 점검**: 임신부 페르소나에 national 5건만 매칭(기존 데이터 life_stage pregnancy 태깅 누락 의심, 서울22 무관).
- **온보딩 장애 질문 추가**(위 특수대상 확장과 동일) → 장애인가정 17건 household 정밀화.

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

## 완료된 사항 (2026-05-29)

- ~~임산부 친환경농산물 꾸러미 전국 확대~~ → 동작구→전국(KR), 에코e몰 URL, 6월시행 안내. dev+운영 반영. [[eco-food-nationwide]]
- ~~"운영에서만 좌우 흔들림" 정체 규명·해결~~ → **iOS input<16px 자동줌**이 원인(캐시 아님). 온보딩·프로필·로그인·결과필터 input/select 폰트 16px 통일. [[mobile-ui-pitfalls]]
- ~~다크모드 자녀 정보 박스 테두리 안 보임~~ → gray-100이 카드배경에 묻힘. dark:border-gray-300 대비 강화. (프로필·결과 등 다른 다크 카드 전역 점검은 미실시)
- ~~온보딩 스텝 인디케이터 동그라미·연결선 정렬~~ → 라벨 글자수로 간격 불균등(77/66/54)이던 것 flex-1 균등칸+연결선 동그라미 중앙관통으로 정렬(66/65/66, diff0)
- ~~다크모드 hydration mismatch 경고~~ → html에 suppressHydrationWarning 추가

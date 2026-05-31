---
name: project_region_expansion
description: "부모로 서비스 지역확장 강서구(11500) 파일럿(2026-05-31, dev). scope-first 파이프라인·scripts/region_expansion/ 모듈·68개 자동커버 통찰(전국/시 재등록 금지)·동작구 정답지 대조·httpx크롤·등록후 URL오염 재검증·지역 파라미터화. UI 강서구 노출 연결 완료. 다음=송파구(11710). policy-region-audit 스킬 codify."
metadata: 
  node_type: memory
  type: project
  originSessionId: 7dc5a353-048b-4a3b-99c4-d797be73eb50
---

부모로 첫 서비스 지역확장. 동작구(11590) 단독 → **강서구(11500) 추가** 파일럿(2026-05-31, dev DB. 운영 미반영).

## 핵심 통찰 (가장 중요)
- **68개 자동커버**: `buildRegionCodes("11500")`→`["KR","11","11500"]`. 새 자치구민은 전국(national 40)+서울시(sido_wide 28)를 **이미 자동 매칭**. → **전국·시 정책 재등록 금지**(="중복 저장"·"시 정책을 구 정책 둔갑"). 신규는 자치구 자체 `sigungu_specific`만.
- **scope(funder) 1차 판정**: 사업주체=복지부→제외 / 서울시→제외 / 자치구 자체→등록. 신청창구(동주민센터·구보건소)는 신호 아님.

## 산출 (scripts/region_expansion/)
- `classify_funder.py`: funder/scope 2축(지역제한 AND 재원주체), gu_name 파라미터화. validate_scope_level.
- `dedup.py`: URL canonical 1차 + trigram + cross-funder 가드(구 후보가 전국/시와 매칭돼도 needs_review).
- `crawl_gangseo.py`: **httpx** 크롤(scrapling 불필요·requirements에 없음). SOURCES 리스트.
- `build_review.py`: build(gu_name,gu_code,host,slug,date) → 검토카드 + channel_hint + 제외 투명성 테이블.
- 테스트 26건(송파구 일반화 포함). npm test 79/79.

## 등록 3건 (dev, sigungu_specific @ 11500)
다자녀의료비(셋째아+ 연30만 per_birth·cash, /welfare/wel100401)·한의약난임(강서형 자체·cash, /health/ht020210)·임신부가사돌봄(service, /welfare/wel100501).
마이그 001(region)·002(초기4건)·003(URL정정)·004(영유아4종 national전환+난청제거)·005(취소됨).
- **난청(선천성난청보청기) 등록했다가 제거(004)**: 보건복지부 전국사업(135만 한도·소득기준폐지 전국시행)인데 동작구도 sigungu 오분류였음 → national 전환 + 강서구 중복 제거.
- **004로 영유아 4종 동작구 sigungu→national 정정**: 난청·선천성대사이상·미숙아선천성이상아의료비·영유아발달정밀검사. 전부 보건복지부 "영유아 사전예방적 건강관리" 국가사업인데 동작구 전용으로 오등록(전국정책이 동작구민만 노출되던 버그). 사용자가 "1번 전국사업 같은데"로 발견.

## ⚠️ 게이트 건너뛴 실수 2회 (반드시 교훈)
1. **카드 검토 전 DB 등록**: 사용자가 "카드로 먼저 보고 결정"을 골랐는데 그 전에 등록해버림. 검토 게이트는 등록 **전**에. 작업 길어질수록 순서 엄수.
2. **추측 URL로 등록(005 취소)**: 강서구 자체사업이 3개뿐이라 사용자가 "진짜 3개냐" 의심 → 내가 /www 본청 메뉴(key=5843·5849·5851)를 **추측**해 마더박스·다둥이카드·다자녀우대 3건 등록. 그러나 **그 URL 전부 500(존재 안 함)** + lifewithbaby 제3자 자료는 "강서구 자체 출산지원금 0원" 명시. 검증 실패 데이터라 DB삭제+마이그 revert. **교훈: 출처 URL이 200 OK로 본문 확인 안 되면 등록 금지. 추측 key 번호 생성 금지.**
- 강서구는 동작구와 달리 **출산축하금·산모신생아 톱업·태교패키지·마더박스가 (공식상) 없음**. 자체사업이 3개인 게 실제일 가능성 높음(동작구가 유난히 많은 것).

## 동작구 자체사업(기준선) — 다른 구 대조용
동작구는 sigungu 29건으로 유난히 많음(출산지원금 동작천사축하금·출산축하용품·다둥이행복카드·다자녀주차감면/재산세감면·산모신생아본인부담금톱업·태교패키지·마더박스·신생아건강보험료·아토피보습제·백일해·북스타트·유축기대여·장난감도서관 등). **이 중 '고위험임산부의료비'·영유아4종은 전국사업 오분류**. 동작구 전수 audit은 별도 follow-up(사용자: 따로 전수조사 후 — 이번엔 손대지 말 것).

## UI 연결 완료 (2026-05-31)
`lib/constants.ts` SUPPORTED_SIGUNGU_CODES=["11590","11500"] 신설. 결과 지역필터·filter-bar 카운트("동작구 특화"→"지역 특화")·benefit-card/modal 출처배지(lib/utils getSourceLabel 공통화, region.name 동적)·온보딩/프로필 안내문구. 지역 추가 시 SUPPORTED_SIGUNGU_CODES에 코드만 추가. 온보딩 기본값 11590은 유지. npm run build 통과.

## 동작구 전수 audit·오분류 정정 완료 (2026-05-31, dev, 마이그007·008)
동작구 sigungu 27건 전수검증(subagent) → 전국/서울 오분류 9건 발견. 사용자 검증·Codex 협의로 정정:
- **007: 전국사업 6건 sigungu→national** (산후도우미바우처·B형간염주산기·미숙아의료비·엽산철분·고위험임산부 + 발달정밀은004기정정). 보건복지부 사업이 동작구민만 노출되던 버그.
- **008: 서울/여가부 3건 정정 + slug 변경** — 공영주차장·키즈카페→sido_wide@11(seoul-multi-child-parking-discount·seoul-kids-cafe), 가족센터→national@KR(national-family-center-childcare). **slug도 실제주체 기준 변경**: project_policy_db_audit #8(slug↔scope 불일치, "slug변경 위험"이라 미뤄둔 것)을 **Codex 협의로 해결** — natural-key rename은 **seed_policies.sql 수정 + live migration 한 세트**(seed만 고치면 재시드때 옛slug 부활·중복). seed의 옛 3 region(KR/11/11590)→정확히1개로, 008은 old→new rename(공존방어 DELETE)+region전체삭제후1개+키즈카페 household_type4개삭제+income recipient_required→none(일반가구 누락버그). 재시드 양경로 동일수렴 검증.
- **검증완료**: 강서구민이 3건 다 봄, 키즈카페 일반가구 매칭(household 0·income none). 동작구 자체사업 27→**20**(진짜 자체만, 009 발달정밀까지 빠져 21→20). npm test 79/79.
- **009 발달정밀 누락버그 정정**: 마이그004가 발달정밀 slug를 'dongjak-developmental-screening'으로 **오추측**(실제 'dongjak-child-development-test')해 정정 누락 + 007은 "004가 했다" 가정해 제외 → dev·운영 양쪽 발달정밀이 sigungu로 남아있던 버그(메모리 #3 "slug 추측금지·현재값 SELECT" 실증, 운영 검증 중 발견). 009로 national 정정. **seed_policies.sql도 정정**: 004/007/009 national 전환한 전국사업 8건(산후도우미·B형간염·미숙아·엽산철분·고위험임산부·발달정밀·대사이상·난청)의 region KR/11/11590 3행→KR 1행(재시드시 옛sigungu 부활방지). 커밋 32d0db3.
- **slug 변경 안전성 코드검증**: canonical_slug는 app/components/lib에서 SELECT만(분기·매칭·라우팅 무사용). 하드코딩은 data/validation 스냅샷뿐(앱 미사용). 매칭은 region_id FK직접필터(.in(region_id))라 단일 region 행 안전(feedback_postgrest_nested_filter 우려 해소).

## 보류(사용자 결정, 이번 미정정)
- 🟡 의심이나 보류: 없음(3건 다 정정함). ⚪ 애매2건 동작구유지: dongjak-prenatal-helper(임신맘도우미 — 구의회 회의록"우리구 사업"=자체 확인), dongjak-preconception-health-screening(예비부부건강검진 — 구의회"연1회 무료"=동작구보건소 자체). 둘 다 sigungu 유지 타당(공식+준공식).

## ✅ 운영(bumoro.kr) 반영 완료 (2026-05-31)
마이그 001·002·003·004·006·007·008·**009** 운영DB(bumoro_MVP) 순차 적용·검증(005취소). dev·운영 동작구 자체사업 **20건 diff 0** 확인. main ff merge+push(32d0db3, bumoro.kr HTTP200). 순서 준수: 운영DB먼저(supabase link 운영ref→-f 순차→dev복귀)→main배포. ⚠️ 마이그 추적테이블 없음=파일존재≠적용, 양쪽 SELECT 검증(project_policy_db_audit #3 교훈)으로 발달정밀 누락 발견·009 정정.
- 최종 지역 자체사업: 동작구20·강서구3·송파구1. 운영=dev 일치.

## 남은 follow-up
- **무료 대상 강조 표시 기능(향후 업데이트, 사용자 보류 2026-05-31)**: 키즈카페처럼 "일반 유료 + 특정그룹 무료" 정책에서 해당자에게 "당신은 무료" 강조. **현 구조 불가**: `policy_household_type`은 matchesEligibility(lib/queries/policies.ts:185)에서 **매칭 차단**용(가구유형 안 맞으면 return false) → 강조(모두 노출+해당자 표시)와 의미 충돌. 신설 시 household_type을 차단용이 아닌 **표시용 메타**로 분리 설계 필요(예: requirement_type='free_eligible' vs 'required' 구분, 표시 컴포넌트에서만 읽기). 현재 무료대상 정보는 모달 raw_target_text(benefit-modal:237)에 텍스트로 노출 중이라 기능상 문제없음.
- 강서구·송파구 자체사업 추가 발굴: 출처 200 OK 확인된 것만. 추측 금지(005 마더박스 추측등록 취소 교훈).
- 운영(bumoro.kr) 미반영 — dev만(push 완료). 운영 반영은 사용자 직접(DB먼저→코드).

[[project_policy_db_audit]] [[feedback_seed_reseed]] [[feedback_postgrest_nested_filter]] [[project_seoul_baby_first_step]]

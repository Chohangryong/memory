-- ============================================================================
-- 부모로 (Bumoro) MVP — 정책 시드 데이터 (122건)
-- 자동 생성: generate_seed.py
-- ============================================================================

BEGIN;

-- #1 다둥이 행복카드 발급 (동작구 안내)
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'dongjak-multi-child-happy-card', '다둥이 행복카드 발급 (동작구 안내)', NULL, '서울시 다자녀 가족(2자녀 이상, 막내 18세 이하) 대상 각종 할인·우대 카드. 공영주차장·문화시설·서울대공원·서울상상나라·예술의전당·주유·영화 등 5~50% 할인 또는 무료.', '서울특별시 동작구청 영유아보육과 (서울시 사업 안내)',
  (SELECT id FROM category WHERE code = 'discount'), 'one_time',
  NULL, NULL, '서울시 다자녀 가족(2자녀 이상, 막내 18세 이하) 대상 각종 할인·우대 카드. 공영주차장·문화시설·서울대공원·서울상상나라·예술의전당·주유·영화 등 5~50% 할인 또는 무료.', NULL,
  '주민센터 방문|서울지갑 앱(앱카드)|우리카드 홈페이지(신용/체크카드)', ARRAY['online', 'visit'],
  '마감 없음 (자녀 조건 충족 동안)', NULL, 'none',
  '신분증, 가족관계증명서', 'https://www.dongjak.go.kr/portal/main/contents.do?menuNo=200286',
  'medium', 'needs_review', 'active',
  '[이호] 동작구청 페이지에 ''다둥이행복카드 발급'' 항목만 있고 상세 혜택은 서울시 사업 페이지 참조.'
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-multi-child-happy-card' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sido_wide'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-multi-child-happy-card' AND r.code = '11'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sigungu_specific'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-multi-child-happy-card' AND r.code = '11590'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'dongjak-multi-child-happy-card' AND ls.code = 'infant_0_36m'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;
INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'dongjak-multi-child-happy-card' AND ls.code = 'post_birth_60d'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'none', NULL, FALSE,
  0, NULL,
  'multi_child / 출생순위: second_or_more', NULL
FROM policy p WHERE p.canonical_slug = 'dongjak-multi-child-happy-card'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'manual', 'https://www.dongjak.go.kr/portal/main/contents.do?menuNo=200286'
FROM policy p WHERE p.canonical_slug = 'dongjak-multi-child-happy-card'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #2 동작구 다자녀 가구 공영주차장 50% 자동 감면
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'dongjak-multi-child-parking-discount', '동작구 다자녀 가구 공영주차장 50% 자동 감면', NULL, '서울시 공영주차장 주차요금 50% 자동 감면 (다자녀가구 부모 차량 1대). 다둥이 행복카드 없이도 ‘바로녹색결제’ 등록 시 비대면 자동 감면.', '서울특별시 / 동작구청 (서울 공영주차장 통합 운영)',
  (SELECT id FROM category WHERE code = 'discount'), 'one_time',
  NULL, NULL, '서울시 공영주차장 주차요금 50% 자동 감면 (다자녀가구 부모 차량 1대). 다둥이 행복카드 없이도 ‘바로녹색결제’ 등록 시 비대면 자동 감면.', NULL,
  '바로녹색결제 앱·홈페이지 등록|다둥이 행복카드 제시 (현장 감면)', ARRAY['online'],
  '서울시 거주 막내 자녀 만 18세 이하 다자녀 가구', NULL, 'none',
  '다둥이 행복카드 또는 본인 차량 등록 정보', 'https://news.seoul.go.kr/welfare/archives/564314',
  'high', 'verified', 'active',
  '[이호] 서울시 전체 공영주차장 대상. 동작구 내 공영주차장도 자동 감면. 2024-08 시행. 시정일보 보도에서 동작구가 자체적으로 ‘다자녀 가정 감면 혜택(공영주차장·체육시설·키즈카페 등)’ 별도 운영한다 언급됨.'
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-multi-child-parking-discount' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sido_wide'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-multi-child-parking-discount' AND r.code = '11'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sigungu_specific'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-multi-child-parking-discount' AND r.code = '11590'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'dongjak-multi-child-parking-discount' AND ls.code = 'infant_0_36m'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'none', NULL, FALSE,
  0, 216,
  'multi_child / 출생순위: second_or_more', NULL
FROM policy p WHERE p.canonical_slug = 'dongjak-multi-child-parking-discount'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'manual', 'https://news.seoul.go.kr/welfare/archives/564314'
FROM policy p WHERE p.canonical_slug = 'dongjak-multi-child-parking-discount'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #3 동작형 청년·신혼부부 만원주택 (전세임대주택)
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'dongjak-youth-newlywed-housing', '동작형 청년·신혼부부 만원주택 (전세임대주택)', NULL, '월 임대료 1만원 (실거주). 보증금은 전세금의 5%만 입주자가 부담. 임대 기간 2년(1회 재계약 가능, 최장 4년). 신혼부부 대상은 동작구 내 노량진동·상도동·흑석동·사당동 등 방2개·화1개 주택.', '서울특별시 동작구청 주택과 / 대한민국동작주식회사',
  (SELECT id FROM category WHERE code = 'discount'), 'one_time',
  10000, 10000, '월 임대료 1만원 (실거주). 보증금은 전세금의 5%만 입주자가 부담. 임대 기간 2년(1회 재계약 가능, 최장 4년). 신혼부부 대상은 동작구 내 노량진동·상도동·흑석동·사당동 등 방2개·화1개 주택.', NULL,
  '동작구청 주택과 공고|대한민국동작주식회사 누리집', ARRAY['online'],
  '공고일 현재 동작구에 주민등록을 두거나 입주일 즉시 전입 가능한 19~39세 청년·신혼부부·예비신혼부부 대상', NULL, 'none',
  '주민등록등본, 혼인관계증명서, 소득증빙서류, 무주택 확인 서류', 'https://www.newsis.com/view/NISX20250102_0003018683',
  'high', 'verified', 'active',
  '[이호] 임대인-구청 전세계약 → 입주자 재임대 방식. 대한민국동작주식회사(구 산하 회사) 자본금에서 보전. 2024년 1차 7세대, 2025년 추가 모집 진행 중. 보증금은 전세금의 5%만 입주자 부담.'
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-youth-newlywed-housing' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sido_wide'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-youth-newlywed-housing' AND r.code = '11'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sigungu_specific'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-youth-newlywed-housing' AND r.code = '11590'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'dongjak-youth-newlywed-housing' AND ls.code = 'infant_0_36m'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;
INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'dongjak-youth-newlywed-housing' AND ls.code = 'post_birth_60d'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;
INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'dongjak-youth-newlywed-housing' AND ls.code = 'pregnancy'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;
INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'dongjak-youth-newlywed-housing' AND ls.code = 'pregnancy_prep'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'median_income_percent', 120, FALSE,
  NULL, NULL,
  '소득: 중위소득 120% 이하', '중위소득 120% 이하'
FROM policy p WHERE p.canonical_slug = 'dongjak-youth-newlywed-housing'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'manual', 'https://www.newsis.com/view/NISX20250102_0003018683'
FROM policy p WHERE p.canonical_slug = 'dongjak-youth-newlywed-housing'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #4 서울형 키즈카페 동작구 3개점 (저소득·다둥이 무료 이용)
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'dongjak-kids-cafe-free', '서울형 키즈카페 동작구 3개점 (저소득·다둥이 무료 이용)', NULL, '1인당 120분 기준 1,000~5,000원 (일반). 다둥이 행복카드 소지자·기초생활수급자·국가유공자·장애인·한부모가족 지원 대상자 무료. 어린이주간 등 시기에 어린이 무료 운영.', '서울특별시 / 동작구청',
  (SELECT id FROM category WHERE code = 'discount'), 'one_time',
  5000, 5000, '1인당 120분 기준 1,000~5,000원 (일반). 다둥이 행복카드 소지자·기초생활수급자·국가유공자·장애인·한부모가족 지원 대상자 무료. 어린이주간 등 시기에 어린이 무료 운영.', NULL,
  '우리동네키움포털(icare.seoul.go.kr) 예약|서울가족플라자 지하2층 시립 1호점 / 상도3동점 / 대방동점', NULL,
  '사전 예약 필수 (서울 전체 시민 이용 가능, 동작구민은 동작구 3개점 우선 이용)', NULL, 'none',
  '무료 이용 시 본인 신분증 + 증빙서류(다둥이행복카드·수급자증·한부모가족증명서 등)', 'https://icare.seoul.go.kr/icare/user/kidsCafe/BD_selectKidsCafeView.do?q_fcltyId=DJ221102',
  'high', 'verified', 'active',
  '[이호] 동작구 3개점 — 제1호 시립 서울형 키즈카페(노량진로 10 서울가족플라자 지하2층), 상도3동점(상도로15가길 16 가온어린이집 3층), 대방동점(여의대방로36길 11 4층). 신대방1동점은 추가 개소 보도.'
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-kids-cafe-free' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sido_wide'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-kids-cafe-free' AND r.code = '11'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sigungu_specific'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-kids-cafe-free' AND r.code = '11590'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'dongjak-kids-cafe-free' AND ls.code = 'infant_0_36m'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'recipient_required', NULL, TRUE,
  24, 84,
  '소득: none (무료 이용은 다둥이·기초생활·국가유공자·장애·한부모 대상)', 'none (무료 이용은 다둥이·기초생활·국가유공자·장애·한부모 대상)'
FROM policy p WHERE p.canonical_slug = 'dongjak-kids-cafe-free'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);

INSERT INTO policy_household_type (policy_id, household_type_id, requirement_type)
SELECT p.id, ht.id, 'required'
FROM policy p, household_type ht
WHERE p.canonical_slug = 'dongjak-kids-cafe-free' AND ht.code = 'multi_child'
ON CONFLICT (policy_id, household_type_id) DO NOTHING;
INSERT INTO policy_household_type (policy_id, household_type_id, requirement_type)
SELECT p.id, ht.id, 'required'
FROM policy p, household_type ht
WHERE p.canonical_slug = 'dongjak-kids-cafe-free' AND ht.code = 'single_parent'
ON CONFLICT (policy_id, household_type_id) DO NOTHING;
INSERT INTO policy_household_type (policy_id, household_type_id, requirement_type)
SELECT p.id, ht.id, 'required'
FROM policy p, household_type ht
WHERE p.canonical_slug = 'dongjak-kids-cafe-free' AND ht.code = 'disabled'
ON CONFLICT (policy_id, household_type_id) DO NOTHING;
INSERT INTO policy_household_type (policy_id, household_type_id, requirement_type)
SELECT p.id, ht.id, 'required'
FROM policy p, household_type ht
WHERE p.canonical_slug = 'dongjak-kids-cafe-free' AND ht.code = 'basic_livelihood'
ON CONFLICT (policy_id, household_type_id) DO NOTHING;

INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'manual', 'https://icare.seoul.go.kr/icare/user/kidsCafe/BD_selectKidsCafeView.do?q_fcltyId=DJ221102'
FROM policy p WHERE p.canonical_slug = 'dongjak-kids-cafe-free'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #5 동작구 신생아 건강보험료 지원
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'dongjak-newborn-health-insurance', '동작구 신생아 건강보험료 지원', NULL, '동작구 거주 신생아 건강보험료 관련 지원 (정확한 지원 금액 페이지 미명시)', '서울특별시 동작구청 영유아보육과',
  (SELECT id FROM category WHERE code = 'information'), 'one_time',
  NULL, NULL, '동작구 거주 신생아 건강보험료 관련 지원 (정확한 지원 금액 페이지 미명시)', NULL,
  '주민센터 방문', ARRAY['visit'],
  '출생신고와 함께 신청 권장', NULL, 'none',
  '신분증, 신청서', 'https://www.dongjak.go.kr/portal/main/contents.do?menuNo=200286',
  'low', 'needs_review', 'active',
  '[이호] 동작구청 페이지에 ''신생아 건강보험료 지원'' 항목명만 있고 상세 미명시. 본 항목은 단서 확보 차원에서 적재.'
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-newborn-health-insurance' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sido_wide'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-newborn-health-insurance' AND r.code = '11'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sigungu_specific'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-newborn-health-insurance' AND r.code = '11590'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'dongjak-newborn-health-insurance' AND ls.code = 'infant_0_36m'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;
INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'dongjak-newborn-health-insurance' AND ls.code = 'post_birth_60d'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'none', NULL, FALSE,
  0, 12,
  NULL, NULL
FROM policy p WHERE p.canonical_slug = 'dongjak-newborn-health-insurance'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'manual', 'https://www.dongjak.go.kr/portal/main/contents.do?menuNo=200286'
FROM policy p WHERE p.canonical_slug = 'dongjak-newborn-health-insurance'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #6 동작형 전문 돌봄 '동작맘'
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'dongjak-care-mom', '동작형 전문 돌봄 ''동작맘''', NULL, '시간당 11,080원 (월 최대 100시간)', '동작구청',
  (SELECT id FROM category WHERE code = 'childcare'), 'monthly',
  11080, 11080, '시간당 11,080원 (월 최대 100시간)', NULL,
  '동작구육아종합지원센터 홈페이지', ARRAY['online'],
  '상시 (매월 18일 접수)', NULL, 'none',
  NULL, '33',
  'unrated', 'needs_review', 'active',
  '[현민] 2026년 확장: 저녁 8시까지 운영 연장 및 야간 할증 비용 구비 지원'
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-care-mom' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sido_wide'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-care-mom' AND r.code = '11'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sigungu_specific'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-care-mom' AND r.code = '11590'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'dongjak-care-mom' AND ls.code = 'infant_0_36m'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'none', NULL, FALSE,
  NULL, NULL,
  '동작구 거주 아동 가정 (소득 재산 무관)', NULL
FROM policy p WHERE p.canonical_slug = 'dongjak-care-mom'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'manual', '33'
FROM policy p WHERE p.canonical_slug = 'dongjak-care-mom'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #7 동작 맘(Mom) 편한 태교 패키지 지원사업
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'dongjak-prenatal-care-package', '동작 맘(Mom) 편한 태교 패키지 지원사업', NULL, '첫째 10만원, 둘째 20만원, 셋째 이상 30만원 상당의 태교 패키지 바우처', '서울특별시 동작구청 영유아보육과',
  (SELECT id FROM category WHERE code = 'voucher'), 'one_time',
  100000, 300000, '첫째 10만원, 둘째 20만원, 셋째 이상 30만원 상당의 태교 패키지 바우처', '[{"birth_order": 1, "amount": 100000}, {"birth_order": 2, "amount": 200000}, {"birth_order": "3+", "amount": 300000}]'::jsonb,
  '정부24 온라인|거주지 동주민센터 방문', ARRAY['online', 'visit'],
  '출산 전까지 동작구 거주 유지 필요', NULL, 'none',
  '신분증, 임신확인서, 주민등록등본', 'https://biz.heraldcorp.com/article/10454855',
  'medium', 'needs_review', 'active',
  '[이호] 사업 자체는 동작구청 보도자료 기반으로 시정일보·헤럴드경제·인사이드피플 다수 보도. 동작구청 영유아보육과 02-820-1786 문의처 명시.'
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-prenatal-care-package' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sido_wide'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-prenatal-care-package' AND r.code = '11'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sigungu_specific'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-prenatal-care-package' AND r.code = '11590'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'dongjak-prenatal-care-package' AND ls.code = 'pregnancy'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'none', NULL, FALSE,
  NULL, NULL,
  NULL, NULL
FROM policy p WHERE p.canonical_slug = 'dongjak-prenatal-care-package'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'manual', 'https://biz.heraldcorp.com/article/10454855'
FROM policy p WHERE p.canonical_slug = 'dongjak-prenatal-care-package'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #8 동작구 영유아 북스타트 책꾸러미
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'dongjak-baby-bookstart', '동작구 영유아 북스타트 책꾸러미', NULL, '구립도서관 8개관에서 영유아 발달단계별 그림책 2권 + 도서목록집 + 가이드북 + 기념품 + 가방 등 책꾸러미 무료 배포. 1단계(영아)·2단계 북스타트 플러스·3단계 보물상자(취학전)로 구성.', '동작문화재단 / 동작구 구립도서관 (위탁)',
  (SELECT id FROM category WHERE code = 'voucher'), 'one_time',
  NULL, NULL, '구립도서관 8개관에서 영유아 발달단계별 그림책 2권 + 도서목록집 + 가이드북 + 기념품 + 가방 등 책꾸러미 무료 배포. 1단계(영아)·2단계 북스타트 플러스·3단계 보물상자(취학전)로 구성.', NULL,
  '동작구통합도서관 홈페이지 사전 신청|구립도서관 방문 수령', ARRAY['online', 'visit'],
  '동작구 주민등록 영유아 대상', NULL, 'none',
  '주민등록등본 (영유아 거주 확인)', 'https://lib.dongjak.go.kr/dj/index.do',
  'medium', 'needs_review', 'active',
  '[이호] 동작문화재단이 위탁 운영. 8개 구립도서관 — 사당솔밭, 대방, 동작, 까망돌, 약수, 노을빛, 동작어린이, 양녕 등. 서울형 북스타트 사업 (시·구·도서관 협력).'
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-baby-bookstart' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sido_wide'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-baby-bookstart' AND r.code = '11'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sigungu_specific'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-baby-bookstart' AND r.code = '11590'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'dongjak-baby-bookstart' AND ls.code = 'infant_0_36m'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;
INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'dongjak-baby-bookstart' AND ls.code = 'post_birth_60d'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'none', NULL, FALSE,
  0, 84,
  NULL, NULL
FROM policy p WHERE p.canonical_slug = 'dongjak-baby-bookstart'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'manual', 'https://lib.dongjak.go.kr/dj/index.do'
FROM policy p WHERE p.canonical_slug = 'dongjak-baby-bookstart'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #9 동작구 청소년산모 임신·출산 의료비 지원
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'dongjak-teen-mom-medical', '동작구 청소년산모 임신·출산 의료비 지원', NULL, '임신확인일 기준 만 19세 이하 청소년 산모. 임신 1회당 120만원 범위 이내. 임산부 및 2세 미만 영유아의 모든 의료비·약제비 사용 가능.', '서울특별시 동작구보건소 건강증진과',
  (SELECT id FROM category WHERE code = 'voucher'), 'per_visit',
  1200000, 1200000, '임신확인일 기준 만 19세 이하 청소년 산모. 임신 1회당 120만원 범위 이내. 임산부 및 2세 미만 영유아의 모든 의료비·약제비 사용 가능.', NULL,
  '사회서비스 전자바우처 홈페이지(socialservice.or.kr) 온라인 신청 후 한국사회보장정보원 우편 서류 제출', ARRAY['online'],
  '임신 확인 후 즉시 신청 권장 (카드 수령 후 2년까지 사용)', NULL, 'none',
  '임신확인서, 신분증', 'https://www.dongjak.go.kr/healthcare/main/contents.do?menuNo=300253',
  'high', 'verified', 'active',
  '[이호] 동작구보건소 건강증진과 02-820-9567. 임신확인일 기준 만 19세 이하. 소득·재산 기준 없음.'
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-teen-mom-medical' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sido_wide'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-teen-mom-medical' AND r.code = '11'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sigungu_specific'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-teen-mom-medical' AND r.code = '11590'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'dongjak-teen-mom-medical' AND ls.code = 'infant_0_36m'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;
INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'dongjak-teen-mom-medical' AND ls.code = 'post_birth_60d'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;
INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'dongjak-teen-mom-medical' AND ls.code = 'pregnancy'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'none', NULL, FALSE,
  0, 24,
  'single_parent', NULL
FROM policy p WHERE p.canonical_slug = 'dongjak-teen-mom-medical'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'manual', 'https://www.dongjak.go.kr/healthcare/main/contents.do?menuNo=300253'
FROM policy p WHERE p.canonical_slug = 'dongjak-teen-mom-medical'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #10 동작구 출산축하용품 구입비 지원
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'dongjak-birth-celebration-gift', '동작구 출산축하용품 구입비 지원', '동작구에 거주하는 출생아 부모에게 출산축하용품 구입비 지원', '첫째 5만원, 둘째 10만원, 셋째 15만원, 넷째 이상 20만원 (출산축하용품 구입비 영수증 기반 현금 지급)', '서울특별시 동작구청 영유아보육과',
  (SELECT id FROM category WHERE code = 'voucher'), 'one_time',
  50000, 200000, '첫째 5만원, 둘째 10만원, 셋째 15만원, 넷째 이상 20만원 (출산축하용품 구입비 영수증 기반 현금 지급)', '[{"birth_order": 1, "amount": 50000}, {"birth_order": 2, "amount": 100000}, {"birth_order": 3, "amount": 150000}, {"birth_order": "4+", "amount": 200000}]'::jsonb,
  '거주지 동주민센터 방문|정부24 온라인', ARRAY['online', 'visit'],
  '출생신고일로부터 1년 이내 신청', 365, 'birth',
  '부모 신분증, 통장사본, 육아용품 구입영수증', 'https://www.dongjak.go.kr/portal/main/contents.do?menuNo=200286',
  'high', 'verified', 'active',
  '[현민] 육아용품 영수증 및 통장사본 첨부 필수 (현금 환급 방식)
[이호] 출산축하금(현금)과 별개로 운영되는 영수증 환급 형식. 영유아보육과 02-820-9220.'
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-birth-celebration-gift' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sido_wide'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-birth-celebration-gift' AND r.code = '11'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sigungu_specific'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-birth-celebration-gift' AND r.code = '11590'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'dongjak-birth-celebration-gift' AND ls.code = 'infant_0_36m'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;
INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'dongjak-birth-celebration-gift' AND ls.code = 'post_birth_60d'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'none', NULL, FALSE,
  0, 12,
  '- 동작구에 주소를 두고 신생아와 동일세대원인 부 또는 모에게 첫째아 5만원, 둘째아 10만원, 셋째아 15만원, 넷째아 이상 20만원의 현금(일시금) 지급
- 2023. 1. 1이후 신생아부터 신청가능 (출생신고일 기준 1년이내 신청가능)
- 신생아 거주지 주민센터로 방문하여 신청(준비서류: 부 또는 모의 신분증, 입금받을 통장사본, 육아용품구입한 영수증) 및 정부24 온라인 신청', NULL
FROM policy p WHERE p.canonical_slug = 'dongjak-birth-celebration-gift'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'manual', 'https://www.dongjak.go.kr/portal/main/contents.do?menuNo=200286'
FROM policy p WHERE p.canonical_slug = 'dongjak-birth-celebration-gift'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #11 임산부 친환경농산물 꾸러미 지원
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'dongjak-eco-food-package', '임산부 친환경농산물 꾸러미 지원', '- 친환경농산물 소비촉진을 통한 농가부담경감 - 올바른 먹거리 공급으로 임산부 건강증진 및 지역 경제활성화에 기여', '총 45만원 상당 친환경 인증 과일·채소·곡물 꾸러미 배송. 지원금 최대 36만원 (자부담 9만원)', '서울특별시 동작구청 경제정책과',
  (SELECT id FROM category WHERE code = 'voucher'), 'one_time',
  90000, 450000, '총 45만원 상당 친환경 인증 과일·채소·곡물 꾸러미 배송. 지원금 최대 36만원 (자부담 9만원)', NULL,
  '임산부 비대면자격검증시스템 온라인 신청', ARRAY['online'],
  '공고 기간 내 선착순 신청 (동작구청 홈페이지 모집 공고 확인 필수)', NULL, 'none',
  '주민등록등본 또는 임신확인서, 신분 확인 사진', 'https://www.servedream.com/service/319000000145',
  'medium', 'needs_review', 'active',
  '[현민] 동작구 자체 육성 사업으로 임산부 영양 식단 공급
[이호] 동작구청 경제정책과 02-820-9333. 타 영양 지원(영양플러스 등) 수혜자 제외. 배송 서비스.'
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-eco-food-package' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sido_wide'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-eco-food-package' AND r.code = '11'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sigungu_specific'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-eco-food-package' AND r.code = '11590'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'dongjak-eco-food-package' AND ls.code = 'post_birth_60d'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;
INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'dongjak-eco-food-package' AND ls.code = 'pregnancy'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'none', NULL, FALSE,
  0, 12,
  '신청일 현재 동작구에 주소를 둔 2025. 1. 1. 이후 출산한 산모 또는 임신부', 'none (영양플러스 등 타 영양 지원 수혜자 제외)'
FROM policy p WHERE p.canonical_slug = 'dongjak-eco-food-package'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'api_gov24', 'https://www.servedream.com/service/319000000145'
FROM policy p WHERE p.canonical_slug = 'dongjak-eco-food-package'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #12 2026년 출산 전 임신맘 도우미 지원
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'dongjak-prenatal-helper', '2026년 출산 전 임신맘 도우미 지원', NULL, '출산 전 임신 중 가사 지원 도우미 파견 서비스 (금액·횟수 이미지·PDF 첨부에만 명시 — 상세 미확인)', '서울특별시 동작구청 영유아보육과',
  (SELECT id FROM category WHERE code = 'service'), 'one_time',
  NULL, NULL, '출산 전 임신 중 가사 지원 도우미 파견 서비스 (금액·횟수 이미지·PDF 첨부에만 명시 — 상세 미확인)', NULL,
  '동작구청 영유아보육과 문의 (02-820-9237)', ARRAY['phone'],
  '신청 기간 미확인 — 영유아보육과(02-820-9237) 직접 문의 필요', NULL, 'none',
  '미확인 (첨부파일 내용 미추출)', 'https://www.dongjak.go.kr/portal/bbs/B0000022/view.do?nttId=10736744&menuNo=200641',
  'low', 'needs_review', 'active',
  '[이호] 2026-02-20 동작구청 알려드립니다 게시판(B0000022) 공지 확인. 담당 부서: 영유아보육과, 연락처: 02-820-9237. 첨부파일: ''2026년 출산 전 임신맘 도우미 지원 안내.jpg'', ''임신출산정책전단.pdf''.'
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-prenatal-helper' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sido_wide'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-prenatal-helper' AND r.code = '11'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sigungu_specific'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-prenatal-helper' AND r.code = '11590'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'dongjak-prenatal-helper' AND ls.code = 'pregnancy'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'requires_review', NULL, FALSE,
  NULL, NULL,
  '소득: 미확인 (첨부파일 내용 미추출)', '미확인 (첨부파일 내용 미추출)'
FROM policy p WHERE p.canonical_slug = 'dongjak-prenatal-helper'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'manual', 'https://www.dongjak.go.kr/portal/bbs/B0000022/view.do?nttId=10736744&menuNo=200641'
FROM policy p WHERE p.canonical_slug = 'dongjak-prenatal-helper'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #13 고위험 임산부 의료비 지원
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'dongjak-high-risk-pregnancy-medical', '고위험 임산부 의료비 지원', '고위험 임신의 적정 치료와 관리에 필요한 진료비를 지원하여 경제적 부담을 줄이고, 건강한 출산을 보장합니다.', '19대 임신 질환으로 입원치료 시 본인부담금 및 비급여 진료비의 90% 지원 (본인 10% 부담). 의료급여 수급자는 비급여 전액 지원. 1인당 최대 300만원.', '서울특별시 동작구보건소 건강증진과',
  (SELECT id FROM category WHERE code = 'service'), 'one_time',
  3000000, 3000000, '19대 임신 질환으로 입원치료 시 본인부담금 및 비급여 진료비의 90% 지원 (본인 10% 부담). 의료급여 수급자는 비급여 전액 지원. 1인당 최대 300만원.', NULL,
  '동작구보건소 방문', ARRAY['visit'],
  '분만일로부터 6개월(180일) 이내에 신청해야 함', NULL, 'none',
  '지원신청서, 진단서, 입퇴원확인서, 진료비 영수증, 주민등록등본, 건강보험증, 통장사본', 'https://www.dongjak.go.kr/healthcare/main/contents.do?menuNo=300247',
  'high', 'needs_review', 'active',
  '[이호] 동작구보건소 건강증진과 02-820-9604, 9565. 상급병실료 차액, 식대, 고위험 질환 무관 비급여는 지원 제외.'
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-high-risk-pregnancy-medical' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sido_wide'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-high-risk-pregnancy-medical' AND r.code = '11'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sigungu_specific'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-high-risk-pregnancy-medical' AND r.code = '11590'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'dongjak-high-risk-pregnancy-medical' AND ls.code = 'pregnancy'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'none', NULL, FALSE,
  NULL, NULL,
  '19대 고위험 임신질환*으로 진단받고 입원치료 받은 임산부를 대상으로 지원합니다. * 조기진통, 분만관련 출혈, 중증 임신중독증, 양막의 조기파열, 태반조기박리, 전치태반, 절박유산, 양수과다증, 양수과소증, 분만전 출혈, 자궁경부무력증, 고혈압, 다태임신, 당뇨병, 대사장애를 동반한 임신과다구토, 신질환, 심부전, 자궁 내 성장 제한, 자궁 및 자궁의 부속기 질환 세부질환기준으로 각 질환별 지원대상 질병코드로 시작되는 하위코드 모두 포함하여 지원', 'none (2024년부터 소득 무관 지원)'
FROM policy p WHERE p.canonical_slug = 'dongjak-high-risk-pregnancy-medical'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);

INSERT INTO policy_household_type (policy_id, household_type_id, requirement_type)
SELECT p.id, ht.id, 'required'
FROM policy p, household_type ht
WHERE p.canonical_slug = 'dongjak-high-risk-pregnancy-medical' AND ht.code = 'disabled'
ON CONFLICT (policy_id, household_type_id) DO NOTHING;

INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'manual', 'https://www.dongjak.go.kr/healthcare/main/contents.do?menuNo=300247'
FROM policy p WHERE p.canonical_slug = 'dongjak-high-risk-pregnancy-medical'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #14 동작 백일축하용품 대여
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'dongjak-100day-celebration-rental', '동작 백일축하용품 대여', '동작구에 거주하는 백일을 맞은 영아 가정에 백일 축하용품 대여', '한복·정장·드레스, 백일 축하용품, 범보의자, 테이블 무료 대여 (5일간). 동작구 거주 4개월 이하 영아 가정 대상.', '서울특별시 동작구청 영유아보육과',
  (SELECT id FROM category WHERE code = 'service'), 'one_time',
  NULL, NULL, '한복·정장·드레스, 백일 축하용품, 범보의자, 테이블 무료 대여 (5일간). 동작구 거주 4개월 이하 영아 가정 대상.', NULL,
  '대한민국동작주식회사 누리집 온라인(kdongjak.co.kr)', ARRAY['online'],
  '전월 25일 이전 온라인 예약 필수 (선착순 마감)', NULL, 'none',
  '주민등록등본 (거주지 확인)', 'https://www.servedream.com/service/319000000161',
  'medium', 'needs_review', 'active',
  '[이호] 동작구청 영유아보육과 02-820-1786. 목요일 배송·월요일 회수. 아시아경제 2024-03-15 보도 확인.'
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-100day-celebration-rental' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sido_wide'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-100day-celebration-rental' AND r.code = '11'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sigungu_specific'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-100day-celebration-rental' AND r.code = '11590'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'dongjak-100day-celebration-rental' AND ls.code = 'infant_0_36m'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;
INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'dongjak-100day-celebration-rental' AND ls.code = 'post_birth_60d'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'none', NULL, FALSE,
  0, 4,
  '동작구에 주민등록이 되어 있는 4개월 이하 영아 가정', NULL
FROM policy p WHERE p.canonical_slug = 'dongjak-100day-celebration-rental'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'api_gov24', 'https://www.servedream.com/service/319000000161'
FROM policy p WHERE p.canonical_slug = 'dongjak-100day-celebration-rental'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #15 동작 어린이 영어놀이터
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'dongjak-kids-english-playground', '동작 어린이 영어놀이터', NULL, '원어민과 함께 영어로 놀이하는 시설. 1층 자유놀이공간 무료. 2층 특화프로그램은 사전예약·별도 시설이용료. 회차 당 약 20명, 1일 5회차 운영.', '서울특별시 동작구청 / 동작구육아종합지원센터',
  (SELECT id FROM category WHERE code = 'service'), 'one_time',
  NULL, NULL, '원어민과 함께 영어로 놀이하는 시설. 1층 자유놀이공간 무료. 2층 특화프로그램은 사전예약·별도 시설이용료. 회차 당 약 20명, 1일 5회차 운영.', NULL,
  '동작구육아종합지원센터 누리집(dccic.go.kr) 사전예약', ARRAY['online'],
  '동작구 거주 영유아 및 어린이집 단체 사전예약 필수', NULL, 'none',
  NULL, 'https://www.welfarehello.com/community/hometownNews/b9b92747-9352-4d8f-819e-d1214f08e37c',
  'high', 'verified', 'active',
  '[이호] 사당동 까치어린이공원(동작대로9길 35) 구 사당지구대 건물 리모델링. 총 116㎡, 지하1층~지상2층. 동작구육아종합지원센터에서 예약 관리.'
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-kids-english-playground' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sido_wide'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-kids-english-playground' AND r.code = '11'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sigungu_specific'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-kids-english-playground' AND r.code = '11590'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'dongjak-kids-english-playground' AND ls.code = 'infant_0_36m'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'none', NULL, FALSE,
  24, 84,
  NULL, NULL
FROM policy p WHERE p.canonical_slug = 'dongjak-kids-english-playground'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'manual', 'https://www.welfarehello.com/community/hometownNews/b9b92747-9352-4d8f-819e-d1214f08e37c'
FROM policy p WHERE p.canonical_slug = 'dongjak-kids-english-playground'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #16 동작구 B형간염 주산기감염 예방사업
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'dongjak-hepb-perinatal-prevention', '동작구 B형간염 주산기감염 예방사업', NULL, 'B형간염 양성 산모 출생 신생아에게 출생 12시간 이내 백신+면역글로불린 투여, 생후 1개월·6개월 추가 접종, 생후 9~15개월 항원·항체검사 무료 지원', '서울특별시 동작구보건소 예방접종실',
  (SELECT id FROM category WHERE code = 'service'), 'monthly',
  NULL, NULL, 'B형간염 양성 산모 출생 신생아에게 출생 12시간 이내 백신+면역글로불린 투여, 생후 1개월·6개월 추가 접종, 생후 9~15개월 항원·항체검사 무료 지원', NULL,
  '분만기관 자동 시행 (1차). 이후 예방접종도우미(nip.kdca.go.kr) 참여 의료기관 검색', NULL,
  '출생 12시간 이내 1차 접종 필수 (분만기관 자동 시행)', NULL, 'none',
  '산모 산전검사결과지 (임신 중 검사 결과), 개인정보제공 동의서', 'https://www.dongjak.go.kr/healthcare/main/contents.do?menuNo=300050',
  'high', 'verified', 'active',
  '[이호] 국가사업. 1차(출생 직후·12시간 이내), 2차(생후 1개월), 3차(생후 6개월), 항원·항체검사(생후 9~15개월). central-gov 트랙과 dedup 필요.'
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-hepb-perinatal-prevention' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sido_wide'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-hepb-perinatal-prevention' AND r.code = '11'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sigungu_specific'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-hepb-perinatal-prevention' AND r.code = '11590'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'dongjak-hepb-perinatal-prevention' AND ls.code = 'post_birth_60d'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'none', NULL, FALSE,
  0, 15,
  '소득: B형간염 표면항원(HBsAg) 양성 및 e항원(HBeAg) 양성 산모 출생 영유아 한정', 'B형간염 표면항원(HBsAg) 양성 및 e항원(HBeAg) 양성 산모 출생 영유아 한정'
FROM policy p WHERE p.canonical_slug = 'dongjak-hepb-perinatal-prevention'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'manual', 'https://www.dongjak.go.kr/healthcare/main/contents.do?menuNo=300050'
FROM policy p WHERE p.canonical_slug = 'dongjak-hepb-perinatal-prevention'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #17 동작구 가족센터 공동육아나눔터 + 가족품앗이
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'dongjak-family-center-childcare', '동작구 가족센터 공동육아나눔터 + 가족품앗이', NULL, '18세 미만 자녀 양육 부모 대상 공동육아나눔터(육아 정보 교환 공간 + 도서·장난감 비치 + 참여형 놀이프로그램) 무료 이용. 가족품앗이(이웃 가정 간 공동 양육·체험·등하교 매칭) 자동 매칭 지원.', '동작구 가족센터 (서울특별시 동작구 위탁)',
  (SELECT id FROM category WHERE code = 'service'), 'one_time',
  NULL, NULL, '18세 미만 자녀 양육 부모 대상 공동육아나눔터(육아 정보 교환 공간 + 도서·장난감 비치 + 참여형 놀이프로그램) 무료 이용. 가족품앗이(이웃 가정 간 공동 양육·체험·등하교 매칭) 자동 매칭 지원.', NULL,
  '동작구 가족센터 홈페이지 신청 (dchfc.familynet.or.kr)|공동육아나눔터 담당 02-599-3260|동작구 가족센터 02-599-3301', ARRAY['online'],
  '동작구 거주 18세 미만 자녀 양육 가구', NULL, 'none',
  NULL, 'https://dchfc.familynet.or.kr/center/lay1/bbs/S295T315C319/A/12/list.do',
  'high', 'verified', 'active',
  '[이호] 본센터(매봉로 37) + 신대방분소. 공동육아나눔터는 「서울특별시 동작구 공동육아나눔터 지원에 관한 조례」에 근거. 영유아 부모에게도 가치 있는 프로그램이라 info 트랙 유효.'
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-family-center-childcare' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sido_wide'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-family-center-childcare' AND r.code = '11'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sigungu_specific'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-family-center-childcare' AND r.code = '11590'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'dongjak-family-center-childcare' AND ls.code = 'infant_0_36m'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'none', NULL, FALSE,
  0, 216,
  NULL, NULL
FROM policy p WHERE p.canonical_slug = 'dongjak-family-center-childcare'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'manual', 'https://dchfc.familynet.or.kr/center/lay1/bbs/S295T315C319/A/12/list.do'
FROM policy p WHERE p.canonical_slug = 'dongjak-family-center-childcare'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #18 동작구 구립 다문화특화 지역아동센터
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'dongjak-multicultural-childcare-center', '동작구 구립 다문화특화 지역아동센터', NULL, '다문화가족 자녀·기타 돌봄 필요 가구 자녀 대상 맞춤형 특화 돌봄 서비스. 1·2층 지역아동센터 + 3층 건강가정·다문화가족지원센터. 한국문화 체험·예절교육·이중언어 지도·재능 발굴·가족상담·사례 관리 제공.', '서울특별시 동작구청 아동청소년과 / 신대방동',
  (SELECT id FROM category WHERE code = 'service'), 'one_time',
  NULL, NULL, '다문화가족 자녀·기타 돌봄 필요 가구 자녀 대상 맞춤형 특화 돌봄 서비스. 1·2층 지역아동센터 + 3층 건강가정·다문화가족지원센터. 한국문화 체험·예절교육·이중언어 지도·재능 발굴·가족상담·사례 관리 제공.', NULL,
  '동작구청 아동청소년과 문의|신대방동 다문화특화 지역아동센터 방문', ARRAY['phone', 'visit'],
  '동작구 거주 다문화가족 자녀 및 기타 돌봄 필요 아동', NULL, 'none',
  NULL, 'https://www.khan.co.kr/article/202010080947001',
  'medium', 'needs_review', 'active',
  '[이호] 신대방1동 구립지역아동센터 건물 — 가족센터 신대방분소와 같은 위치. 「2021년 1월 개관」 보도 기준. 3층에 건강가정·다문화가족지원센터(가족센터 분소) 동시 운영.'
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-multicultural-childcare-center' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sido_wide'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-multicultural-childcare-center' AND r.code = '11'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sigungu_specific'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-multicultural-childcare-center' AND r.code = '11590'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'dongjak-multicultural-childcare-center' AND ls.code = 'infant_0_36m'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'none', NULL, FALSE,
  36, 216,
  'multicultural', NULL
FROM policy p WHERE p.canonical_slug = 'dongjak-multicultural-childcare-center'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'manual', 'https://www.khan.co.kr/article/202010080947001'
FROM policy p WHERE p.canonical_slug = 'dongjak-multicultural-childcare-center'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #19 동작구 난임부부 시술비 지원사업
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'dongjak-infertility-treatment', '동작구 난임부부 시술비 지원사업', NULL, '체외수정(신선배아) 출산당 최대 20회, 1회당 최대 110만원. 체외수정(동결배아) 출산당 최대 20회, 1회당 최대 50만원. 인공수정 출산당 최대 5회, 1회당 최대 30만원.', '서울특별시 동작구보건소 건강증진과',
  (SELECT id FROM category WHERE code = 'service'), 'per_visit',
  300000, 1100000, '체외수정(신선배아) 출산당 최대 20회, 1회당 최대 110만원. 체외수정(동결배아) 출산당 최대 20회, 1회당 최대 50만원. 인공수정 출산당 최대 5회, 1회당 최대 30만원.', NULL,
  'e-보건소 온라인(e-health.go.kr)|정부24 온라인|동작구보건소 8층 모자건강센터 방문 (사실혼 부부는 필수 방문)', ARRAY['online', 'visit'],
  '지원결정통지서 발급 후 3개월 이내 시술 실시 필요', 90, 'none',
  '신청서, 부부 신분증, 건강보험증, 사실혼 입증서류(해당 시)', 'https://www.dongjak.go.kr/healthcare/main/contents.do?menuNo=300246',
  'high', 'verified', 'active',
  '[이호] 동작구보건소 건강증진과 02-820-9604, 02-820-9565. 부부 중 최소 한 명 대한민국 국적 및 건강보험 가입 필수.'
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-infertility-treatment' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sido_wide'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-infertility-treatment' AND r.code = '11'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sigungu_specific'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-infertility-treatment' AND r.code = '11590'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'dongjak-infertility-treatment' AND ls.code = 'pregnancy_prep'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'none', NULL, FALSE,
  NULL, NULL,
  NULL, NULL
FROM policy p WHERE p.canonical_slug = 'dongjak-infertility-treatment'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'manual', 'https://www.dongjak.go.kr/healthcare/main/contents.do?menuNo=300246'
FROM policy p WHERE p.canonical_slug = 'dongjak-infertility-treatment'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #20 동작구 보건소 유축기 대여
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'dongjak-breast-pump-rental', '동작구 보건소 유축기 대여', NULL, '동작구 거주 출산부 대상 유축기 무료 대여 (기본 1개월). 소모품(부속품)은 별도 구매.', '서울특별시 동작구보건소 건강증진과 모자건강센터',
  (SELECT id FROM category WHERE code = 'service'), 'one_time',
  NULL, NULL, '동작구 거주 출산부 대상 유축기 무료 대여 (기본 1개월). 소모품(부속품)은 별도 구매.', NULL,
  '동작구보건소 모자건강센터(8층) 방문 (사전 예약 필수)|서울시 임신·출산 정보센터 온라인 예약', ARRAY['online', 'visit'],
  '동작구 주민등록 출산부 대상', NULL, 'none',
  '본인 또는 대리인 신분증, 출생증명서 또는 산모 임신·출산 관련 서류', 'https://www.welfarehello.com/policy/e968c763-e5bf-4ef3-9aa0-1ae4979858a3',
  'high', 'verified', 'active',
  '[이호] 서울시 전 자치구 공통 사업이지만, 동작구는 보건소 8층 모자건강센터에서 직접 대여. 서울시 임신·출산 정보센터에서 자치구 선택 후 신청 가능. 02-820-9604, 02-820-9565 (보건소 건강증진과).'
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-breast-pump-rental' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sido_wide'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-breast-pump-rental' AND r.code = '11'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sigungu_specific'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-breast-pump-rental' AND r.code = '11590'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'dongjak-breast-pump-rental' AND ls.code = 'post_birth_60d'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'none', NULL, FALSE,
  0, 12,
  NULL, NULL
FROM policy p WHERE p.canonical_slug = 'dongjak-breast-pump-rental'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'manual', 'https://www.welfarehello.com/policy/e968c763-e5bf-4ef3-9aa0-1ae4979858a3'
FROM policy p WHERE p.canonical_slug = 'dongjak-breast-pump-rental'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #21 동작구 산모·신생아 건강관리 지원 (산후도우미 바우처)
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'dongjak-postpartum-care-voucher', '동작구 산모·신생아 건강관리 지원 (산후도우미 바우처)', NULL, '산모·신생아 건강관리사 방문 서비스 바우처 (단축 5~20일 / 표준 10~15일 / 연장 15~40일, 자녀 수·소득 수준에 따라 차등). 2026년 1일당 단가 146.4천원~569.6천원. 정부지원금 외 본인부담금은 동작구 본인부담금 지원사업(별도 슬러그)으로 추가 환급 가능.', '서울특별시 동작구보건소 건강증진과 모자건강팀',
  (SELECT id FROM category WHERE code = 'service'), 'one_time',
  NULL, NULL, '산모·신생아 건강관리사 방문 서비스 바우처 (단축 5~20일 / 표준 10~15일 / 연장 15~40일, 자녀 수·소득 수준에 따라 차등). 2026년 1일당 단가 146.4천원~569.6천원. 정부지원금 외 본인부담금은 동작구 본인부담금 지원사업(별도 슬러그)으로 추가 환급 가능.', NULL,
  '복지로 온라인(bokjiro.go.kr)|동작구보건소 8층 모자건강센터 방문|관할 동주민센터 방문', ARRAY['online', 'visit'],
  '출산 후 60일 안에 신청하지 않으면 못 받음', NULL, 'none',
  '신청서, 산모·배우자 건강보험증, 건강보험료 납부확인서 등', 'https://www.dongjak.go.kr/healthcare/main/contents.do?menuNo=300047',
  'high', 'verified', 'active',
  '[이호] 운영시간 09:00~11:30, 13:00~18:00. 담당 02-820-9603, 9564.'
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-postpartum-care-voucher' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sido_wide'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-postpartum-care-voucher' AND r.code = '11'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sigungu_specific'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-postpartum-care-voucher' AND r.code = '11590'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'dongjak-postpartum-care-voucher' AND ls.code = 'post_birth_60d'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'median_income_percent', 150, FALSE,
  0, 2,
  '소득: 정부 지원금은 기준중위소득 150% 이하 우대, 그 외에도 신청 가능 (자치구별 추가 지원 별도)', '정부 지원금은 기준중위소득 150% 이하 우대, 그 외에도 신청 가능 (자치구별 추가 지원 별도)'
FROM policy p WHERE p.canonical_slug = 'dongjak-postpartum-care-voucher'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'manual', 'https://www.dongjak.go.kr/healthcare/main/contents.do?menuNo=300047'
FROM policy p WHERE p.canonical_slug = 'dongjak-postpartum-care-voucher'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #22 동작구 산모신생아 건강관리 본인부담금 지원
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'dongjak-postpartum-copay-support', '동작구 산모신생아 건강관리 본인부담금 지원', '출산과 산후 회복 등에 소요되는 경제적 부담 완화 및 산모와 신생아의 건강증진을 도모 하고자 함', '산모·신생아 건강관리서비스 본인부담금의 90% 지원 (서울형 산후조리경비 바우처 사용 시 그 차액을 지원)', '서울특별시 동작구보건소 건강증진과 모자건강팀',
  (SELECT id FROM category WHERE code = 'service'), 'one_time',
  NULL, NULL, '산모·신생아 건강관리서비스 본인부담금의 90% 지원 (서울형 산후조리경비 바우처 사용 시 그 차액을 지원)', NULL,
  '동작구보건소 모자건강센터(8층) 방문|정부24 온라인', ARRAY['online', 'visit'],
  '산모·신생아 건강관리 서비스 종료 후 12개월 이내', 360, 'none',
  '신청서, 서비스 이용 영수증 등', 'https://www.dongjak.go.kr/healthcare/main/contents.do?menuNo=300341',
  'high', 'verified', 'active',
  '[현민] 소득 제한 없이 건강관리사 파견 비용 실 지불금 환불
[이호] 동작구보건소 건강증진과 모자건강팀 02-820-9603, 9564. 국가 산모·신생아 건강관리지원사업(중위소득 150% 이하 90%)과는 별도로, 본인부담금에서 또 한 번 90%를 동작구가 추가 지원하는 구조.'
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-postpartum-copay-support' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sido_wide'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-postpartum-copay-support' AND r.code = '11'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sigungu_specific'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-postpartum-copay-support' AND r.code = '11590'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'dongjak-postpartum-copay-support' AND ls.code = 'post_birth_60d'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'none', NULL, FALSE,
  0, 12,
  '- 지원
- 대상: 신생아 출생일 전·후 6개월 연속하여 신청일까지 계속하여 동작구에 주민등록상 주소를 두고 실제 거주하고 있는 신생아의 부 또는 모 *동작구 출생등록 신청 기한: 서비스 종료후 12개월이내 신청', NULL
FROM policy p WHERE p.canonical_slug = 'dongjak-postpartum-copay-support'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'manual', 'https://www.dongjak.go.kr/healthcare/main/contents.do?menuNo=300341'
FROM policy p WHERE p.canonical_slug = 'dongjak-postpartum-copay-support'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #23 동작구 아토피 피부염 보습제 지원
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'dongjak-atopic-moisturizer', '동작구 아토피 피부염 보습제 지원', NULL, '아토피피부염(L20) 진단 아동 대상 보습제 현물 제공 (재고 소진 시 조기 마감)', '서울특별시 동작구보건소 건강관리과 모자보건팀',
  (SELECT id FROM category WHERE code = 'service'), 'one_time',
  NULL, NULL, '아토피피부염(L20) 진단 아동 대상 보습제 현물 제공 (재고 소진 시 조기 마감)', NULL,
  '동작구보건소 8층 모자건강센터 방문', ARRAY['visit'],
  '재고 소진 시 조기 마감 — 신청 전 사전 전화 확인 필요', NULL, 'none',
  '진단서·소견서 또는 처방전(진료코드 L20 기재된 원본), 신분증, 주민등록등본 또는 가족관계증명서', 'https://www.dongjak.go.kr/healthcare/main/contents.do?menuNo=300252',
  'medium', 'needs_review', 'active',
  '[이호] 동작구보건소 건강관리과 모자보건팀 02-820-9567. 신청 전 반드시 담당자에게 전화 문의 (재고 소진 조기 마감 가능).'
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-atopic-moisturizer' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sido_wide'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-atopic-moisturizer' AND r.code = '11'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sigungu_specific'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-atopic-moisturizer' AND r.code = '11590'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'dongjak-atopic-moisturizer' AND ls.code = 'infant_0_36m'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'none', NULL, FALSE,
  0, 216,
  NULL, NULL
FROM policy p WHERE p.canonical_slug = 'dongjak-atopic-moisturizer'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'manual', 'https://www.dongjak.go.kr/healthcare/main/contents.do?menuNo=300252'
FROM policy p WHERE p.canonical_slug = 'dongjak-atopic-moisturizer'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #24 동작구 여성 HPV 검사비 지원 참여신청
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'dongjak-hpv-test-support', '동작구 여성 HPV 검사비 지원 참여신청', '임신 전 HPV 검사를 지원하여 자궁경부암 예방 및 조기 관리를 강화하고 임산부와 태아의 건강 위험요인을 사전에 예방하여 건강한 출산 환경 조성에 기여하고자 함', 'HPV 검사 본인부담금 최대 3만원 지원 (급여 및 비급여 항목 포함). 2026년 1월~예산 소진 시까지.', '서울특별시 동작구보건소 건강증진과 모자건강센터',
  (SELECT id FROM category WHERE code = 'service'), 'monthly',
  30000, 30000, 'HPV 검사 본인부담금 최대 3만원 지원 (급여 및 비급여 항목 포함). 2026년 1월~예산 소진 시까지.', NULL,
  'e-보건소 온라인(e-health.go.kr) 신청 또는 동작구보건소 8층 모자건강센터 방문', ARRAY['online', 'visit'],
  'HPV 검사 후 1개월 이내 청구 (예산 소진 시 조기 마감)', 30, 'none',
  '신청서, 2026년 동작구 임신 사전건강관리 지원사업 검사 결과지', 'https://www.dongjak.go.kr/healthcare/main/contents.do?menuNo=300385',
  'high', 'needs_review', 'active',
  '[이호] 동작구보건소 건강증진과 02-820-9605, 9562. 관내 참여 의료기관에서 검사 실시 후 청구.'
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-hpv-test-support' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sido_wide'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-hpv-test-support' AND r.code = '11'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sigungu_specific'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-hpv-test-support' AND r.code = '11590'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'dongjak-hpv-test-support' AND ls.code = 'pregnancy_prep'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'none', NULL, FALSE,
  NULL, NULL,
  '대상 : ''26년 임신 사전건강관리지원사업 신청한 동작구 여성 중 ‣ 의사가 필요하다고 판단한 경우 ‣ HPV 검사를 희망하는 경우', NULL
FROM policy p WHERE p.canonical_slug = 'dongjak-hpv-test-support'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'manual', 'https://www.dongjak.go.kr/healthcare/main/contents.do?menuNo=300385'
FROM policy p WHERE p.canonical_slug = 'dongjak-hpv-test-support'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #25 동작구 임신 사전건강관리 지원 (가임력 검사)
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'dongjak-preconception-health-check', '동작구 임신 사전건강관리 지원 (가임력 검사)', NULL, '여성 최대 13만원, 남성 최대 5만원 검사비 지원. 주기별 최대 3회 (29세 이하 / 30~34세 / 35~49세)', '서울특별시 동작구보건소 건강증진과 모자건강센터',
  (SELECT id FROM category WHERE code = 'service'), 'one_time',
  50000, 130000, '여성 최대 13만원, 남성 최대 5만원 검사비 지원. 주기별 최대 3회 (29세 이하 / 30~34세 / 35~49세)', NULL,
  'e보건소 온라인|동작구보건소 방문', ARRAY['online', 'visit'],
  '검사의뢰서 발급 후 3개월 안에 검사 받기', NULL, 'none',
  '신분증', 'https://www.dongjak.go.kr/healthcare/main/contents.do?menuNo=300342',
  'high', 'verified', 'active',
  '[이호] 검사 항목: 여성 난소기능검사(AMH)·부인과초음파 / 남성 정액검사(정자정밀형태검사). 모자건강센터 02-820-9605.'
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-preconception-health-check' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sido_wide'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-preconception-health-check' AND r.code = '11'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sigungu_specific'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-preconception-health-check' AND r.code = '11590'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'dongjak-preconception-health-check' AND ls.code = 'pregnancy_prep'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'none', NULL, FALSE,
  NULL, NULL,
  NULL, NULL
FROM policy p WHERE p.canonical_slug = 'dongjak-preconception-health-check'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'manual', 'https://www.dongjak.go.kr/healthcare/main/contents.do?menuNo=300342'
FROM policy p WHERE p.canonical_slug = 'dongjak-preconception-health-check'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #26 동작구 임신부·배우자 백일해 예방접종 지원
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'dongjak-pertussis-vaccination', '동작구 임신부·배우자 백일해 예방접종 지원', NULL, '백일해(Tdap 혼합백신) 무료 접종. 임신부 임신 시마다 1회, 배우자 최근 10년 이내 미접종자 1회.', '서울특별시 동작구보건소 감염병관리과',
  (SELECT id FROM category WHERE code = 'service'), 'one_time',
  NULL, NULL, '백일해(Tdap 혼합백신) 무료 접종. 임신부 임신 시마다 1회, 배우자 최근 10년 이내 미접종자 1회.', NULL,
  '동작구 내 지정의료기관 79개소 방문 (보건소·보건지소는 접종 불가)', ARRAY['visit'],
  '임신 27~36주 사이에 접종 권장 (백신 소진 시 조기 종료)', NULL, 'none',
  '임신부: 신분증 + 산모수첩(원본). 배우자: 신분증 + 산모수첩(원본) + 주민등록등본(5일 이내 발급)', 'https://www.dongjak.go.kr/healthcare/main/contents.do?menuNo=300386',
  'high', 'verified', 'active',
  '[이호] 동작구보건소 감염병관리과 02-820-9506, 9510~1. 보건소·보건지소에서는 접종 불가 — 반드시 지정의료기관 방문.'
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-pertussis-vaccination' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sido_wide'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-pertussis-vaccination' AND r.code = '11'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sigungu_specific'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-pertussis-vaccination' AND r.code = '11590'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'dongjak-pertussis-vaccination' AND ls.code = 'pregnancy'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'none', NULL, FALSE,
  NULL, NULL,
  NULL, NULL
FROM policy p WHERE p.canonical_slug = 'dongjak-pertussis-vaccination'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'manual', 'https://www.dongjak.go.kr/healthcare/main/contents.do?menuNo=300386'
FROM policy p WHERE p.canonical_slug = 'dongjak-pertussis-vaccination'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #27 동작구 장난감도서관
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'dongjak-toy-library', '동작구 장난감도서관', NULL, '영유아 흥미·발달 단계별 장난감 무료 대여 (연회비 1만원). 1회 대여 한도 대형 1개 + 소형 1개. 대여 기간 14일.', '동작구청 / 서울가족플라자 (위탁)',
  (SELECT id FROM category WHERE code = 'service'), 'yearly',
  10000, 10000, '영유아 흥미·발달 단계별 장난감 무료 대여 (연회비 1만원). 1회 대여 한도 대형 1개 + 소형 1개. 대여 기간 14일.', NULL,
  '서울가족플라자 1층 장난감도서관 방문 (노량진로 10)', ARRAY['visit'],
  '동작구민·조부모 직계가족 또는 동작구 소재 직장인의 직계가족 영유아 대상', NULL, 'none',
  '주민등록등본 (직계가족 확인)', 'https://dongjak.go.kr/portal/main/contents.do?menuNo=201542',
  'high', 'verified', 'active',
  '[현민] 상도동·신대방동 이동 경로에 대형 차량이 직접 도서관 배송
[이호] 서울가족플라자 1층(노량진로 10) — 02-753-0222~3. 동작구 보유 가족지원시설. 서울장난감도서관과 통합 운영 가능성.'
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-toy-library' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sido_wide'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-toy-library' AND r.code = '11'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sigungu_specific'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-toy-library' AND r.code = '11590'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'dongjak-toy-library' AND ls.code = 'infant_0_36m'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;
INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'dongjak-toy-library' AND ls.code = 'post_birth_60d'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'none', NULL, FALSE,
  0, 72,
  '동작구 관내 주민등록 영유아', NULL
FROM policy p WHERE p.canonical_slug = 'dongjak-toy-library'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'manual', 'https://dongjak.go.kr/portal/main/contents.do?menuNo=201542'
FROM policy p WHERE p.canonical_slug = 'dongjak-toy-library'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #28 동작형 아동 석식 도시락
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'dongjak-child-dinner-lunchbox', '동작형 아동 석식 도시락', NULL, '동작구 관내 어린이집 연장보육반 유아 하원 시 양질의 석식 도시락 지원. 2세 이상 영유아까지 확대.', '서울특별시 동작구청 영유아보육과',
  (SELECT id FROM category WHERE code = 'service'), 'one_time',
  NULL, NULL, '동작구 관내 어린이집 연장보육반 유아 하원 시 양질의 석식 도시락 지원. 2세 이상 영유아까지 확대.', NULL,
  '동작구 관내 어린이집', NULL,
  '어린이집 연장보육반 등록 필요', NULL, 'none',
  NULL, 'https://www.sijung.co.kr/news/articleView.html?idxno=408905',
  'medium', 'needs_review', 'active',
  '[이호] 보도자료에 ‘전국 최초’ 명시. 2세 이상으로 대상 확대 시점은 2025년 기준.'
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-child-dinner-lunchbox' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sido_wide'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-child-dinner-lunchbox' AND r.code = '11'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sigungu_specific'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-child-dinner-lunchbox' AND r.code = '11590'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'dongjak-child-dinner-lunchbox' AND ls.code = 'infant_0_36m'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'none', NULL, FALSE,
  24, 84,
  NULL, NULL
FROM policy p WHERE p.canonical_slug = 'dongjak-child-dinner-lunchbox'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'manual', 'https://www.sijung.co.kr/news/articleView.html?idxno=408905'
FROM policy p WHERE p.canonical_slug = 'dongjak-child-dinner-lunchbox'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #29 미숙아 및 선천성이상아 의료비 지원
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'dongjak-premature-baby-medical', '미숙아 및 선천성이상아 의료비 지원', '미숙아 및 선천성이상아 대상 의료비 지원을 통해 환아 가정의 경제적 부담을 완화하고, 미숙아 등 고위험 신생아의 건강한 성장 발달을 도모합니다.', '미숙아: 전액본인부담금 및 비급여. 100만원 이하 100% / 100만원 초과 90% 지원. 체중별 한도 400만원~2,000만원. 선천성이상아: 동일 기준, 1인당 최대 700만원.', '서울특별시 동작구보건소 건강증진과 모자건강팀',
  (SELECT id FROM category WHERE code = 'service'), 'one_time',
  1000000, 20000000, '미숙아: 전액본인부담금 및 비급여. 100만원 이하 100% / 100만원 초과 90% 지원. 체중별 한도 400만원~2,000만원. 선천성이상아: 동일 기준, 1인당 최대 700만원.', NULL,
  'e-보건소 온라인(e-health.go.kr)|동작구보건소 8층 모자건강센터 방문', ARRAY['online', 'visit'],
  '퇴원일로부터 6개월(180일) 이내에 신청해야 함', NULL, 'none',
  '신청서, 진단서, 진료비 영수증, 주민등록등본 등', 'https://www.dongjak.go.kr/healthcare/main/contents.do?menuNo=300248',
  'high', 'needs_review', 'active',
  '[이호] 미숙아 기준: 임신 37주 미만 또는 출생 시 체중 2,500g 미만, 출생 후 24시간 이내 NICU 입원. 선천성이상아: Q코드 진단, 출생 후 2년 이내 입원·수술.'
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-premature-baby-medical' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sido_wide'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-premature-baby-medical' AND r.code = '11'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sigungu_specific'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-premature-baby-medical' AND r.code = '11590'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'dongjak-premature-baby-medical' AND ls.code = 'infant_0_36m'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;
INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'dongjak-premature-baby-medical' AND ls.code = 'post_birth_60d'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'requires_review', NULL, FALSE,
  0, 24,
  '미숙아 의료비 지원대상은 다음과 같습니다. 긴급한 수술 또는 치료가 필요하여 출생 후 24시간 이내에 신생아중환자실(NICU)에 입원한 미숙아* 신생아중환자실 부족에 따른 대기 또는 이송의 사유로 출생 후 24시간 이내에 신생아중환자실에 입원하지 못한 경우, 의료기관의 확인을 받아 지원 가능 지원 제외: 재입원, 외래 및 재활치료, 이송비, 제증명서 발급비용, 병실입원료, 보호자 식대, 미숙아용 기저귀, 치료와 직접 관련이 없는 소모품(체온계 등), 예방접종비…', '소득 조건 확인 필요'
FROM policy p WHERE p.canonical_slug = 'dongjak-premature-baby-medical'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'manual', 'https://www.dongjak.go.kr/healthcare/main/contents.do?menuNo=300248'
FROM policy p WHERE p.canonical_slug = 'dongjak-premature-baby-medical'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #30 서울시한의약난임치료지원
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'seoul-herbal-infertility-treatment', '서울시한의약난임치료지원', '○ 저출산·고령화에 대응하기 위한 출산장려 및 난임극복에 대한 사회적 분위기 확산', '첩약 치료비 90% 지원, 1인 최대 120만원 (기초생활수급자·차상위계층 100% 지원). 생애 최대 2회 (연 1회)', '서울특별시 동작구보건소 건강증진과 (서울시 사업 대행)',
  (SELECT id FROM category WHERE code = 'service'), 'yearly',
  1200000, 1200000, '첩약 치료비 90% 지원, 1인 최대 120만원 (기초생활수급자·차상위계층 100% 지원). 생애 최대 2회 (연 1회)', NULL,
  '서울시 임신출산 정보센터 온라인(seoul-agi.seoul.go.kr)', ARRAY['online'],
  '선발 후 지정 기간 내 치료 완료 필요', NULL, 'none',
  '신청서, 구비서류(사전 선별검사 결과 포함)', 'https://www.dongjak.go.kr/healthcare/main/contents.do?menuNo=300332',
  'high', 'verified', 'active',
  '[이호] 동작구보건소 건강증진과 02-820-9565. 자연임신 희망하는 원인불명 난임부부 한정. 일반 난임 시술비 지원(체외수정·인공수정)과 중복 적용 불가.'
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'seoul-herbal-infertility-treatment' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sido_wide'
FROM policy p, region r
WHERE p.canonical_slug = 'seoul-herbal-infertility-treatment' AND r.code = '11'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sigungu_specific'
FROM policy p, region r
WHERE p.canonical_slug = 'seoul-herbal-infertility-treatment' AND r.code = '11590'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'seoul-herbal-infertility-treatment' AND ls.code = 'pregnancy_prep'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'recipient_required', NULL, TRUE,
  NULL, NULL,
  '- 지원자격
- 법적 혼인상태에 있거나, 신청일 기준 최근 1년간 사실상 혼인관계를 유지하였다고 관할 보건소로부터 확인된 난임부부
※ 다만, 원인불명의 난임진단이 확인되어야 하고, 한의약 난임치료 신청 전 사전선별 검사 결과 지원 제한 요소가 없어야 함
- 신청일 기준, 서울시 거주로 확인된 자(여성, 남성 각각 확인)
- 부부 중 한 명은 대한민국 국적을 가지고 있어야 하며, 한 명이 외국 국적인 경우 모두 건강보험 가입자일 것 ○ 소득 기준 : 없음', 'none (기초·차상위는 100% 지원으로 우대)'
FROM policy p WHERE p.canonical_slug = 'seoul-herbal-infertility-treatment'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'manual', 'https://www.dongjak.go.kr/healthcare/main/contents.do?menuNo=300332'
FROM policy p WHERE p.canonical_slug = 'seoul-herbal-infertility-treatment'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #31 서울아기 건강 첫걸음(생애초기 건강관리)
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'seoul-baby-first-step-health', '서울아기 건강 첫걸음(생애초기 건강관리)', '서울아기 건강 첫걸음 사업(생애초기 건강관리 사업)에서는 임산부가 산전, 산후에 겪는 사회적, 심리적 어려움에 대처하고, 영유아 양육역량을 강화할 수 있도록 보편방문, 지속방문, 부모모임, 연계서비스 등을 제공하며, 영유아에게 최선의 건강발달이 이루어질 수 있도록 다양한 교육을 제공합니다.', '보편방문 1회(출산 후 8주 이내, 60~90분) 무료 가정방문 건강관리. 고위험 가구는 임신 20주~생후 24개월까지 총 25회 지속방문.', '서울특별시 동작구보건소 건강증진과 모자건강팀',
  (SELECT id FROM category WHERE code = 'service'), 'one_time',
  NULL, NULL, '보편방문 1회(출산 후 8주 이내, 60~90분) 무료 가정방문 건강관리. 고위험 가구는 임신 20주~생후 24개월까지 총 25회 지속방문.', NULL,
  '동작구보건소 8층 모자건강센터 방문|서울시 임신출산정보센터 온라인(seoul-agi.seoul.go.kr)', ARRAY['online', 'visit'],
  '출산 후 8주(56일) 이내에 서비스 신청 권장', NULL, 'none',
  '임신부 등록 확인 서류', 'https://www.dongjak.go.kr/healthcare/main/contents.do?menuNo=300048',
  'high', 'verified', 'active',
  '[현민] 올바른 수유 지도 및 신생아 발달 모니터링 무상 제공
[이호] 서울아기 방문간호사 02-820-9568, 9569. 보편방문: 산모·신생아 건강평가, 모유수유 교육, 산후우울증 검사 등 포함.'
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'seoul-baby-first-step-health' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sido_wide'
FROM policy p, region r
WHERE p.canonical_slug = 'seoul-baby-first-step-health' AND r.code = '11'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sigungu_specific'
FROM policy p, region r
WHERE p.canonical_slug = 'seoul-baby-first-step-health' AND r.code = '11590'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'seoul-baby-first-step-health' AND ls.code = 'infant_0_36m'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;
INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'seoul-baby-first-step-health' AND ls.code = 'post_birth_60d'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'none', NULL, FALSE,
  0, 24,
  '보건소에 등록, 서비스 신청한 임산부 및 만2세 미만 영유아 가정', NULL
FROM policy p WHERE p.canonical_slug = 'seoul-baby-first-step-health'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'manual', 'https://www.dongjak.go.kr/healthcare/main/contents.do?menuNo=300048'
FROM policy p WHERE p.canonical_slug = 'seoul-baby-first-step-health'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #32 선천성 난청검사 및 보청기 지원
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'dongjak-hearing-screening-aid', '선천성 난청검사 및 보청기 지원', '선천성 난청을 조기진단하고, 조기 재활을 통해 난청으로 인해 발생할 수 있는 언어 지능 발달장애 사회부적응 등을 예방하고 건강한 성장을 도모합니다.', '선별검사비 본인부담금 지원 (최대 2회, 재검 시 1회 추가). 확진검사비 7만원 한도 지원. 보청기 지원: 영유아 1인당 135만원 (1~2개).', '서울특별시 동작구보건소 건강증진과 모자건강팀',
  (SELECT id FROM category WHERE code = 'service'), 'one_time',
  70000, 1350000, '선별검사비 본인부담금 지원 (최대 2회, 재검 시 1회 추가). 확진검사비 7만원 한도 지원. 보청기 지원: 영유아 1인당 135만원 (1~2개).', NULL,
  '동작구보건소 방문', ARRAY['visit'],
  '선별검사비는 출생일 기준 1년 이내 신청', 365, 'birth',
  '신청서, 영수증 원본, 진료비 세부내역서, 통장사본, 검사 결과서', 'https://www.dongjak.go.kr/healthcare/main/contents.do?menuNo=300250',
  'high', 'needs_review', 'active',
  '[이호] 보청기 지원 대상: 만 12세 미만, 양측성 난청, 청력 40~59dB. 동작구보건소 방문 신청.'
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-hearing-screening-aid' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sido_wide'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-hearing-screening-aid' AND r.code = '11'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sigungu_specific'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-hearing-screening-aid' AND r.code = '11590'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'dongjak-hearing-screening-aid' AND ls.code = 'infant_0_36m'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;
INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'dongjak-hearing-screening-aid' AND ls.code = 'post_birth_60d'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'health_insurance_based', NULL, FALSE,
  0, 144,
  '- 선천성난청 검사비 지원대상 및 지원내용은 다음과 같습니다. 신생아 난청 외래 선별검사비의 (일부)본인부담금 지원
- 출생 후 28일 이내에 실시하여 건강보험이 적용된 선별검사를 대상으로 함
※ 단, 출생일 기준 28일 이후에 실시하였어도 건강보험이 적용된 선별검사는 지원 가능
- 1회 지원이 원칙이나, 재검(Refer) 판정 등에 따라 선별검사를 재실시한 경우에는 1회에 한하여 추가 지원 가능(최대 2회)
- 검사비 외 항목(진찰료 등)은 지원 제외 난청 선별…', '보청기 지원: 만 12세 미만, 양측성 난청, 청력역치 40~59dB 이상'
FROM policy p WHERE p.canonical_slug = 'dongjak-hearing-screening-aid'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'manual', 'https://www.dongjak.go.kr/healthcare/main/contents.do?menuNo=300250'
FROM policy p WHERE p.canonical_slug = 'dongjak-hearing-screening-aid'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #33 선천성대사이상 검사 및 환아관리
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'dongjak-metabolic-screening', '선천성대사이상 검사 및 환아관리', '선천성대사이상의 유무를 조기에 발견·치료함으로써 장애발생을 사전에 예방하여 영유아의 건강 증진을 도모합니다.', '선별검사: 출생 후 28일 이내 신생아 외래 선별검사비 본인부담금 지원. 확진검사: 본인부담금 지원(7만원 한도). 환아관리: 선천성대사이상 → 특수조제분유·저단백햇반 지원. 선천성 갑상선기능저하증 → 연 25만원 의료비.', '서울특별시 동작구보건소 건강증진과 모자건강팀',
  (SELECT id FROM category WHERE code = 'service'), 'yearly',
  70000, 250000, '선별검사: 출생 후 28일 이내 신생아 외래 선별검사비 본인부담금 지원. 확진검사: 본인부담금 지원(7만원 한도). 환아관리: 선천성대사이상 → 특수조제분유·저단백햇반 지원. 선천성 갑상선기능저하증 → 연 25만원 의료비.', NULL,
  '동작구보건소 8층 모자건강센터 방문', ARRAY['visit'],
  '검사비 신청은 출생일로부터 1년(365일) 이내', NULL, 'none',
  '신청서, 검사결과지, 영수증, 주민등록등본 등', 'https://www.dongjak.go.kr/healthcare/main/contents.do?menuNo=300249',
  'high', 'verified', 'active',
  '[이호] 정신지체 예방 목적. 선별검사 대상 질환 수·특수조제분유 품목은 보건복지부 고시에 따름.'
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-metabolic-screening' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sido_wide'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-metabolic-screening' AND r.code = '11'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sigungu_specific'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-metabolic-screening' AND r.code = '11590'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'dongjak-metabolic-screening' AND ls.code = 'infant_0_36m'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;
INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'dongjak-metabolic-screening' AND ls.code = 'post_birth_60d'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'requires_review', NULL, FALSE,
  0, 228,
  '선천성대사이상 지원대상은 다음과 같습니다. (선별검사) 신생아 선천성 대사이상 외래 선별검사를 받은 영아 (확진검사) 선천성 대사이상 선별검사 결과 유소견 판정 후, 선천성 대사이상 질환 관련 확진검사 결과 선천성대사이상 환아로 판정된 영아 환아관리 지원대상은 다음과 같습니다. 확진검사 결과 선천성대사이상 및 희귀 등 기타 질환으로 진단받아 특수식이 또는 의료비 지원이 필요한, 신청일 기준 만 19세 미만* 환아* 만 나이는 출생월 기준으로 산정하며, 만 19…', '소득 조건 확인 필요'
FROM policy p WHERE p.canonical_slug = 'dongjak-metabolic-screening'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'manual', 'https://www.dongjak.go.kr/healthcare/main/contents.do?menuNo=300249'
FROM policy p WHERE p.canonical_slug = 'dongjak-metabolic-screening'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #34 영유아 발달 정밀검사비 지원
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'dongjak-child-development-test', '영유아 발달 정밀검사비 지원', '영유아 건강검진 효과를 높이고 영유아 기초건강관리 강화를 위해 영유아 건강검진 발달평가 결과 ‘심화평가 권고’ 대상자에 대한 발달 정밀검사비 지원', '의료수급권자·기초생활수급자·차상위: 최대 40만원. 건강보험 가입자·피부양자: 최대 20만원. 법정 본인부담금 및 비급여 포함.', '서울특별시 동작구보건소 건강증진과',
  (SELECT id FROM category WHERE code = 'service'), 'one_time',
  200000, 400000, '의료수급권자·기초생활수급자·차상위: 최대 40만원. 건강보험 가입자·피부양자: 최대 20만원. 법정 본인부담금 및 비급여 포함.', NULL,
  '동작구보건소 8층 모자건강센터 방문', ARRAY['visit'],
  '심화평가 권고 통보 후 정밀검사 받고 구비서류 지참하여 신청', NULL, 'none',
  'K-DST 결과통보서, 진료비 영수증, 검사 결과서, 통장사본', 'https://www.dongjak.go.kr/healthcare/main/contents.do?menuNo=300251',
  'high', 'verified', 'active',
  '[이호] 동작구보건소 건강증진과 02-820-9564. 치료비·장애진단서 발급비·병실료 차액·특진비는 지원 제외.'
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-child-development-test' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sido_wide'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-child-development-test' AND r.code = '11'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sigungu_specific'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-child-development-test' AND r.code = '11590'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'dongjak-child-development-test' AND ls.code = 'infant_0_36m'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'recipient_required', NULL, TRUE,
  0, 71,
  '영유아 건강검진 발달평가 결과 ''심화평가 권고''로 평가된 대상', '수급 여부에 따라 지원 금액 차등 (수급자 40만원, 일반 20만원)'
FROM policy p WHERE p.canonical_slug = 'dongjak-child-development-test'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'manual', 'https://www.dongjak.go.kr/healthcare/main/contents.do?menuNo=300251'
FROM policy p WHERE p.canonical_slug = 'dongjak-child-development-test'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #35 임산부 엽산제, 철분제 지원
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'dongjak-folic-acid-iron-supplement', '임산부 엽산제, 철분제 지원', '(철분제) 임산부의 철분 결핍성 빈혈로 발생할 수 있는 조산, 유산, 산모 사망을 예방할 수 있는 철분제를 지원하여 안전한 분만유도 및 임산부 및 태아, 영유아의 건강증진을 도모하고자 함 (엽산제) 엽산제 지원을 통해 신경관 결손으로 발생할 수 있는 유사산, 선천성 기형아 출산 등을 사전에 예방하여 임산부와 태아의 건강증진 도모', '임산부 뱃지(엠블럼), 엽산제(임신 12주 이내 등록 시 1~3개월분), 철분제(임신 16주부터 최대 5개월분), 임신초기 검사(B형간염·빈혈·풍진·성병·소변), 임산부자동차 표지, 태아 기형아검사 지원(1차·2차)', '서울특별시 동작구보건소 건강증진과 모자건강팀',
  (SELECT id FROM category WHERE code = 'service'), 'monthly',
  NULL, NULL, '임산부 뱃지(엠블럼), 엽산제(임신 12주 이내 등록 시 1~3개월분), 철분제(임신 16주부터 최대 5개월분), 임신초기 검사(B형간염·빈혈·풍진·성병·소변), 임산부자동차 표지, 태아 기형아검사 지원(1차·2차)', NULL,
  '관할 동주민센터 방문|동작구보건소 방문|정부24 ''맘편한 임신'' 온라인', ARRAY['online', 'visit'],
  '엽산제 지원을 위해 임신 12주 이내 등록 권장', NULL, 'none',
  '신분증, 임신확인서', 'https://www.dongjak.go.kr/healthcare/main/contents.do?menuNo=300046',
  'high', 'verified', 'active',
  '[현민] 산부인과만 다니다 보건소 등록을 안 하면 못 받습니다
[이호] 건강증진과 모자건강팀 02-820-9567 / 모자건강센터 02-820-9605. 의약품 수령은 보건소 방문 필수(택배는 건강기능식품만).'
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-folic-acid-iron-supplement' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sido_wide'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-folic-acid-iron-supplement' AND r.code = '11'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sigungu_specific'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-folic-acid-iron-supplement' AND r.code = '11590'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'dongjak-folic-acid-iron-supplement' AND ls.code = 'pregnancy'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'none', NULL, FALSE,
  NULL, 3,
  '(엽산제) 임신 전후 3개월 ○ (철분제) 임신 16주 이상', NULL
FROM policy p WHERE p.canonical_slug = 'dongjak-folic-acid-iron-supplement'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'manual', 'https://www.dongjak.go.kr/healthcare/main/contents.do?menuNo=300046'
FROM policy p WHERE p.canonical_slug = 'dongjak-folic-acid-iron-supplement'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #36 정·난관 복원 시술비 지원 (동작구 안내)
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'dongjak-vasectomy-reversal-support', '정·난관 복원 시술비 지원 (동작구 안내)', NULL, '정·난관 복원 시술 관련 요양급여 비용 중 본인부담금 지원. 최대 100만원. 생애 1회 지원. 2026년 기준 남성 만 55세 이하(1970년생 이후), 여성 만 49세 이하(1976년생 이후).', '서울특별시 동작구보건소 건강증진과 (서울시 사업 안내)',
  (SELECT id FROM category WHERE code = 'service'), 'one_time',
  1000000, 1000000, '정·난관 복원 시술 관련 요양급여 비용 중 본인부담금 지원. 최대 100만원. 생애 1회 지원. 2026년 기준 남성 만 55세 이하(1970년생 이후), 여성 만 49세 이하(1976년생 이후).', NULL,
  '서울시 임신출산정보센터 온라인(seoul-agi.seoul.go.kr) 회원가입 후 신청 (사전 온라인 가입 필수)|동작구보건소 8층 모자건강센터 방문', ARRAY['online', 'visit'],
  '시술 당해 연도 내 신청 (12월 시술은 다음해 1월 말까지)', NULL, 'none',
  '신청서, 시술 관련 의료 서류, 통장사본', 'https://www.dongjak.go.kr/healthcare/main/contents.do?menuNo=300375',
  'high', 'verified', 'active',
  '[이호] 동작구보건소 건강증진과 02-820-9565. 대상자 본인 명의 계좌로만 지급. 사전 온라인 가입 필수.'
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-vasectomy-reversal-support' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sido_wide'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-vasectomy-reversal-support' AND r.code = '11'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sigungu_specific'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-vasectomy-reversal-support' AND r.code = '11590'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'dongjak-vasectomy-reversal-support' AND ls.code = 'pregnancy_prep'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'none', NULL, FALSE,
  NULL, NULL,
  NULL, NULL
FROM policy p WHERE p.canonical_slug = 'dongjak-vasectomy-reversal-support'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'manual', 'https://www.dongjak.go.kr/healthcare/main/contents.do?menuNo=300375'
FROM policy p WHERE p.canonical_slug = 'dongjak-vasectomy-reversal-support'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #37 동작구 다자녀 양육 가구 재산세 전액 감면
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'dongjak-multi-child-property-tax-exemption', '동작구 다자녀 양육 가구 재산세 전액 감면', NULL, '재산세(본세) 100% 감면. 환급 평균 1건당 약 14만원(2025년 환급 기준 약 1억 900만원/799건). 도시지역분·지방교육세는 제외.', '서울특별시 동작구청 세무1과 재산세팀',
  (SELECT id FROM category WHERE code = 'tax_benefit'), 'one_time',
  140000, 9000000, '재산세(본세) 100% 감면. 환급 평균 1건당 약 14만원(2025년 환급 기준 약 1억 900만원/799건). 도시지역분·지방교육세는 제외.', NULL,
  '우편·문자 안내 후 신청|지방세 환급 카카오톡 채널 신청|동작구청 세무1과 02-820-1588 문의', ARRAY['phone'],
  '과세 기준일(6/1) 기준 자녀 3명 이상 양육·동작구 주민등록 필수', NULL, 'none',
  '주민등록등본, 가족관계증명서', 'https://biz.heraldcorp.com/article/10619750',
  'high', 'verified', 'active',
  '[이호] 헤럴드경제·시정일보·서울경제·내외일보·local세계 등 다수 매체 보도. 박일하 구청장 추진. 환급률 11/19 기준 94%, 12월 중 100% 완료 예정. 동작구 자체 조례에 근거.'
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-multi-child-property-tax-exemption' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sido_wide'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-multi-child-property-tax-exemption' AND r.code = '11'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sigungu_specific'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-multi-child-property-tax-exemption' AND r.code = '11590'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'dongjak-multi-child-property-tax-exemption' AND ls.code = 'infant_0_36m'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'none', NULL, FALSE,
  NULL, 215,
  'multi_child / 출생순위: third_or_more / 소득: 관내 시가표준액 9억원 이하 1세대 1주택', '관내 시가표준액 9억원 이하 1세대 1주택'
FROM policy p WHERE p.canonical_slug = 'dongjak-multi-child-property-tax-exemption'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'manual', 'https://biz.heraldcorp.com/article/10619750'
FROM policy p WHERE p.canonical_slug = 'dongjak-multi-child-property-tax-exemption'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #38 임신부 백일해 예방접종
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'dongjak-pertussis-vaccination-pregnant', '임신부 백일해 예방접종', '임신부 백일해 예방접종 진료·상담 예방접종 임신부 백일해 예방접종 임신부 백일해 예방접종 일 시 : 2026. 3. 3.(화) ~ 12. 31.(백신 소진 시까지) 접종대상 : 접종일 기준 동작구 거주하는 임신 27주 ∼36주 임신부와 그 배우자 접종내용 : 백일해(Tdap 혼합백신) 무료 접종 접종기준 구분 접종기준 임신부 임신 시마다 1회 지원 배우자 최근 10년 이내 백일해(Tdap) 백신 미접종자 1회 접종장소 : 동작구 내 지정의료기관 79개소 <다운로드> ※ 보건소·보건지소에서 접종하지 않습니다. 준 비 물 임신부 : 신분증, 산모수첩(원본) 배우자 : 신분증, 산모수첩(원본), 주민등록등본(접종일 기준 5일 이내 발급) 문…', '- 백일해(Tdap 혼합백신) 무료 접종
- 동작구 내 지정의료기관에서 접종
- 보건소·보건지소 접종 아님', '동작구 보건소',
  (SELECT id FROM category WHERE code = 'service'), 'one_time',
  NULL, NULL, '- 백일해(Tdap 혼합백신) 무료 접종
- 동작구 내 지정의료기관에서 접종
- 보건소·보건지소 접종 아님', NULL,
  '- 동작구 지정의료기관 방문
- 임신부: 신분증, 산모수첩 원본
- 배우자: 신분증, 산모수첩 원본, 주민등록등본', ARRAY['visit'],
  '2026.03.03~2026.12.31(백신 소진 시까지)', NULL, 'none',
  NULL, 'https://dongjak.go.kr/healthcare/main/contents.do?menuNo=300386',
  'unrated', 'needs_review', 'active',
  NULL
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-pertussis-vaccination-pregnant' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sido_wide'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-pertussis-vaccination-pregnant' AND r.code = '11'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sigungu_specific'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-pertussis-vaccination-pregnant' AND r.code = '11590'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'dongjak-pertussis-vaccination-pregnant' AND ls.code = 'post_birth_60d'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;
INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'dongjak-pertussis-vaccination-pregnant' AND ls.code = 'pregnancy'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'none', NULL, FALSE,
  NULL, NULL,
  '접종일 기준 동작구 거주 임신 27~36주 임신부와 배우자', NULL
FROM policy p WHERE p.canonical_slug = 'dongjak-pertussis-vaccination-pregnant'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'manual', 'https://dongjak.go.kr/healthcare/main/contents.do?menuNo=300386'
FROM policy p WHERE p.canonical_slug = 'dongjak-pertussis-vaccination-pregnant'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #39 예비부부 및 임신준비부부 건강검진
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'dongjak-preconception-health-screening', '예비부부 및 임신준비부부 건강검진', '예비부부 및 임신준비부부 건강검진 진료·상담 건강검진 예비부부 및 임신준비부부 건강검진 위치 보건소 3층 건강검진실 (문의 : ☎ 02-820-9673) 대상 동작구 가임기 예비부부 및 임신준비 부부 이용시간 평일(월~금) 오전 9시~11시 비용 무료(연 1회) 검사항목 검사항목 구 분 항 목 기초검사 신장, 체중, 비만도, 혈압 흉부방사선 검사 결핵 유무 확인 혈액검사 혈액학 검사 8종(빈혈 등), 당뇨, 신장기능 3종, 간기능 9종, 고지혈증 3종, 갑상선(TSH), 성병(HIV,매독), (여)풍진항체검사 소변검사 당, 단백, 요잠혈 등 10종 준비사항 신분증, 주민등록등본(모바일 발급 가능, 사진 촬영본 불가) 예비부부 : 청첩장…', '- 기초검사: 신장, 체중, 비만도, 혈압
- 흉부방사선 검사: 결핵 유무
- 혈액검사: 빈혈, 당뇨, 신장기능, 간기능, 고지혈증, 갑상선, 성병, 풍진항체 등
- 소변검사: 당, 단백, 요잠혈 등', '02-820-9673',
  (SELECT id FROM category WHERE code = 'service'), 'one_time',
  NULL, NULL, '- 기초검사: 신장, 체중, 비만도, 혈압
- 흉부방사선 검사: 결핵 유무
- 혈액검사: 빈혈, 당뇨, 신장기능, 간기능, 고지혈증, 갑상선, 성병, 풍진항체 등
- 소변검사: 당, 단백, 요잠혈 등', NULL,
  '- 보건소 3층 건강검진실 방문
- 평일 09:00~11:00 이용
- 예약 없음
- 결과는 1주일 후 방문 또는 공공보건포털에서 확인', ARRAY['visit'],
  '평일 09:00~11:00, 연 1회', NULL, 'none',
  NULL, 'https://dongjak.go.kr/healthcare/main/contents.do?menuNo=300387',
  'unrated', 'needs_review', 'active',
  NULL
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-preconception-health-screening' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sido_wide'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-preconception-health-screening' AND r.code = '11'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sigungu_specific'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-preconception-health-screening' AND r.code = '11590'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'dongjak-preconception-health-screening' AND ls.code = 'pregnancy'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;
INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'dongjak-preconception-health-screening' AND ls.code = 'pregnancy_prep'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'none', NULL, FALSE,
  NULL, NULL,
  '동작구 가임기 예비부부 및 임신준비 부부', NULL
FROM policy p WHERE p.canonical_slug = 'dongjak-preconception-health-screening'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'manual', 'https://dongjak.go.kr/healthcare/main/contents.do?menuNo=300387'
FROM policy p WHERE p.canonical_slug = 'dongjak-preconception-health-screening'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #40 동작구 장애인가정 양육지원수당
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'dongjak-disabled-childcare-allowance', '동작구 장애인가정 양육지원수당', NULL, '자녀 1명당 월 10만원 (2자녀 월 20만원, 3자녀 월 30만원) — 신청월부터 자녀가 만 7세 되는 달의 전월까지', '서울특별시 동작구청 (장애인복지 담당)',
  (SELECT id FROM category WHERE code = 'cash'), 'monthly',
  100000, 300000, '자녀 1명당 월 10만원 (2자녀 월 20만원, 3자녀 월 30만원) — 신청월부터 자녀가 만 7세 되는 달의 전월까지', NULL,
  '거주지 관할 주민센터 방문', ARRAY['visit'],
  '연중 접수 (해당연도 12월 31일까지 신청)', NULL, 'none',
  '신분증, 통장사본, 주민등록등본 등', 'https://biz.heraldcorp.com/article/10722762',
  'medium', 'needs_review', 'active',
  '[이호] 2026년 신설. 매월 25일 대상자 계좌 지급. 시정일보·오마이뉴스·인사이드피플 등 다수 매체가 동작구 보도자료 기반으로 동일 보도.'
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-disabled-childcare-allowance' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sido_wide'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-disabled-childcare-allowance' AND r.code = '11'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sigungu_specific'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-disabled-childcare-allowance' AND r.code = '11590'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'dongjak-disabled-childcare-allowance' AND ls.code = 'infant_0_36m'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'none', NULL, FALSE,
  24, 83,
  'disabled', NULL
FROM policy p WHERE p.canonical_slug = 'dongjak-disabled-childcare-allowance'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'manual', 'https://biz.heraldcorp.com/article/10722762'
FROM policy p WHERE p.canonical_slug = 'dongjak-disabled-childcare-allowance'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #41 동작구 청년·신혼부부 월세 지원
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'dongjak-youth-newlywed-rent-support', '동작구 청년·신혼부부 월세 지원', NULL, '1인 가구 청년 월 최대 20만원, 신혼부부 월 최대 30만원. 최장 12개월간 분기별 지급. 또는 전세보증금 대출이자 지원 선택 가능.', '서울특별시 동작구청 청년청소년과',
  (SELECT id FROM category WHERE code = 'cash'), 'monthly',
  200000, 300000, '1인 가구 청년 월 최대 20만원, 신혼부부 월 최대 30만원. 최장 12개월간 분기별 지급. 또는 전세보증금 대출이자 지원 선택 가능.', NULL,
  '동작구청 청년청소년과 02-820-1691, 1692, 1693|온라인 공고 (서울청년포털)', ARRAY['online'],
  '공고 시 모집 — 39세 이하 무주택 청년·신혼부부 대상', NULL, 'none',
  '확인 필요 (신청서, 주민등록등본, 임대차계약서, 소득증빙)', 'https://www.sedaily.com/NewsView/2GXRTUNTSF',
  'medium', 'needs_review', 'active',
  '[이호] 동작구청 청년청소년과 추진. 임신 직전·임신 중·출산 직후 무주택 청년/신혼부부 핵심 카피 후보. 서울경제(2025-07) 보도 기준.'
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-youth-newlywed-rent-support' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sido_wide'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-youth-newlywed-rent-support' AND r.code = '11'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sigungu_specific'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-youth-newlywed-rent-support' AND r.code = '11590'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'dongjak-youth-newlywed-rent-support' AND ls.code = 'post_birth_60d'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;
INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'dongjak-youth-newlywed-rent-support' AND ls.code = 'pregnancy'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;
INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'dongjak-youth-newlywed-rent-support' AND ls.code = 'pregnancy_prep'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'median_income_percent', 150, FALSE,
  NULL, NULL,
  '소득: 기준 중위소득 150% 이하 (서울시 청년월세 기준 준용)', '기준 중위소득 150% 이하 (서울시 청년월세 기준 준용)'
FROM policy p WHERE p.canonical_slug = 'dongjak-youth-newlywed-rent-support'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);

INSERT INTO policy_household_type (policy_id, household_type_id, requirement_type)
SELECT p.id, ht.id, 'required'
FROM policy p, household_type ht
WHERE p.canonical_slug = 'dongjak-youth-newlywed-rent-support' AND ht.code = 'youth'
ON CONFLICT (policy_id, household_type_id) DO NOTHING;

INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'manual', 'https://www.sedaily.com/NewsView/2GXRTUNTSF'
FROM policy p WHERE p.canonical_slug = 'dongjak-youth-newlywed-rent-support'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #42 동작구 출산지원금 (동작천사축하금)
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'dongjak-birth-celebration-cash', '동작구 출산지원금 (동작천사축하금)', NULL, '첫째 30만원, 둘째 50만원, 셋째 100만원, 넷째 이상 200만원', '서울특별시 동작구청 복지정책과',
  (SELECT id FROM category WHERE code = 'cash'), 'one_time',
  300000, 2000000, '첫째 30만원, 둘째 50만원, 셋째 100만원, 넷째 이상 200만원', '[{"birth_order": 1, "amount": 300000}, {"birth_order": 2, "amount": 500000}, {"birth_order": 3, "amount": 1000000}, {"birth_order": "4+", "amount": 2000000}]'::jsonb,
  '동주민센터 방문 신청', ARRAY['visit'],
  '신청 전 동작구에 6개월 이상 거주 필요', NULL, 'none',
  '주민등록등본, 가족관계증명서, 통장사본, 출생증명서', 'https://www.law.go.kr/%EC%9E%90%EC%B9%98%EB%B2%95%EA%B7%9C/%EC%84%9C%EC%9A%B8%ED%8A%B9%EB%B3%84%EC%8B%9C%20%EB%8F%99%EC%9E%91%EA%B5%AC%20%EC%B6%9C%EC%82%B0%EC%A7%80%EC%9B%90%EA%B8%88%20%EC%A7%80%EA%B8%89%EC%97%90%20%EA%B4%80%ED%95%9C%20%EC%A1%B0%EB%A1%80',
  'medium', 'needs_review', 'active',
  '[이호] 동작구의 대표적 자체 사업. 2023-01부터 시행 중. 2025-2026년 인상·조건 변경은 확인되지 않음. orchestrator dedup 단계에서 research-dongjak-gov와 중복 우선순위 비교 필요.'
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-birth-celebration-cash' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sido_wide'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-birth-celebration-cash' AND r.code = '11'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sigungu_specific'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-birth-celebration-cash' AND r.code = '11590'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'dongjak-birth-celebration-cash' AND ls.code = 'post_birth_60d'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'none', NULL, FALSE,
  0, 6,
  NULL, NULL
FROM policy p WHERE p.canonical_slug = 'dongjak-birth-celebration-cash'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'manual', 'https://www.law.go.kr/%EC%9E%90%EC%B9%98%EB%B2%95%EA%B7%9C/%EC%84%9C%EC%9A%B8%ED%8A%B9%EB%B3%84%EC%8B%9C%20%EB%8F%99%EC%9E%91%EA%B5%AC%20%EC%B6%9C%EC%82%B0%EC%A7%80%EC%9B%90%EA%B8%88%20%EC%A7%80%EA%B8%89%EC%97%90%20%EA%B4%80%ED%95%9C%20%EC%A1%B0%EB%A1%80'
FROM policy p WHERE p.canonical_slug = 'dongjak-birth-celebration-cash'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #43 동작출산축하금 및 출산축하용품
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'dongjak-birth-celebration-cash-gift', '동작출산축하금 및 출산축하용품', '사회문제인 출산율 감소에 적극 대처하고 출산장려 분위기 조성', '첫째 30만원, 둘째 50만원, 셋째 100만원, 넷째 이상 200만원 (1회 지원)', '서울특별시 동작구청 영유아보육과',
  (SELECT id FROM category WHERE code = 'cash'), 'one_time',
  300000, 2000000, '첫째 30만원, 둘째 50만원, 셋째 100만원, 넷째 이상 200만원 (1회 지원)', '[{"birth_order": 1, "amount": 300000}, {"birth_order": 2, "amount": 500000}, {"birth_order": 3, "amount": 1000000}, {"birth_order": "4+", "amount": 2000000}]'::jsonb,
  '거주지 동주민센터 방문|정부24 온라인', ARRAY['online', 'visit'],
  '출생신고일로부터 1년 안에 신청해야 함', 365, 'birth',
  '신분증, 통장사본', 'https://www.dongjak.go.kr/portal/main/contents.do?menuNo=200286',
  'high', 'verified', 'active',
  '[현민] 주민등록 거주 기간 요건 확인 필요 (동작구청 공식 확인)
[이호] 동작구청 영유아보육과 02-820-9220 / 아동청소년과 02-820-1491. 동작구청 페이지(menuNo=200286)에는 항목명·신청기관·구비서류만 명시되어 있어 금액·거주요건은 시정일보 2021-04-23 보도(동작구 보도자료 기반)로 보강함.'
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-birth-celebration-cash-gift' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sido_wide'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-birth-celebration-cash-gift' AND r.code = '11'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sigungu_specific'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-birth-celebration-cash-gift' AND r.code = '11590'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'dongjak-birth-celebration-cash-gift' AND ls.code = 'infant_0_36m'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;
INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'dongjak-birth-celebration-cash-gift' AND ls.code = 'post_birth_60d'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'none', NULL, FALSE,
  0, 12,
  '- 1. 동작출산축하금 ○
- 지원대상 : 출생신고일 기준 동작구 관내에 6개월 이상 주민등록이 되어있는 부 또는 모(출생신고일 1년이내 신청)
※ 보호자(부·모)중 1인만 신생아의 주민등록이 같이 되어 있어도 지원 대상자가 됨. ○
- 지원내용 : 첫째 30만원, 둘째 50만원, 셋째 100만원, 넷째이상 200만원 지급 2, 동작출산축하용품 ○
- 지원대상 : 신청 당시 동작구에 주민등록이 되어 있는 부 또는 모(출생신고일 1년이내 신청) ○
- 지원내용 : 첫째 5, 둘째…', NULL
FROM policy p WHERE p.canonical_slug = 'dongjak-birth-celebration-cash-gift'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'manual', 'https://www.dongjak.go.kr/portal/main/contents.do?menuNo=200286'
FROM policy p WHERE p.canonical_slug = 'dongjak-birth-celebration-cash-gift'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #44 신생아 건강보험료 지원(둘째이상 신생아 상해질병 보험료 지원)
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'dongjak-newborn-insurance-premium', '신생아 건강보험료 지원(둘째이상 신생아 상해질병 보험료 지원)', '불의의 질병, 사고로 인한 다자녀 가정의 경제적 비용을 경감함으로써 저출산 문제를 극복하고 영유아의 건강한 양육을 위한 사회 환경 조성', '월 2만원씩 5년간 (총 약 120만원) 신생아 상해·질병 보험료 지원. 둘째아 이상 출생 신생아 대상.', '서울특별시 동작구청 영유아보육과',
  (SELECT id FROM category WHERE code = 'cash'), 'monthly',
  20000, 1200000, '월 2만원씩 5년간 (총 약 120만원) 신생아 상해·질병 보험료 지원. 둘째아 이상 출생 신생아 대상.', NULL,
  '동작구청 영유아보육과 02-820-1142 문의', ARRAY['phone'],
  '구체 신청기한은 동작구청 영유아보육과(02-820-1142) 문의 필요', NULL, 'none',
  '확인 필요 (출생증명서, 주민등록등본, 통장사본 등 추정)', 'https://www.sijung.co.kr/news/articleView.html?idxno=408700',
  'medium', 'needs_review', 'active',
  '[이호] 시정일보 보도(2025-03-12)에 ‘자치구 최초로 둘째아부터 신생아 상해·질병 보험료를 월 2만원씩 5년간 지원하고 있다’ 기재. 동작구 합계출산율 상승 사례로 함께 보도.'
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-newborn-insurance-premium' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sido_wide'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-newborn-insurance-premium' AND r.code = '11'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sigungu_specific'
FROM policy p, region r
WHERE p.canonical_slug = 'dongjak-newborn-insurance-premium' AND r.code = '11590'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'dongjak-newborn-insurance-premium' AND ls.code = 'infant_0_36m'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;
INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'dongjak-newborn-insurance-premium' AND ls.code = 'post_birth_60d'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'health_insurance_based', NULL, FALSE,
  0, 60,
  '신생아 출생일 현재 동작구에 주민등록이 되어있고 거주하고 있는 둘째 이상 자녀 * 출생 신고 후, 1년이내 가입신청 해야 함. * 부모 중 1인만 신생아와 주민등록이 같이 되어 있어도 지원 대상이 됨 * 첫째, 둘째아가 쌍생아 일 경우, 전원 지원 가능.', '건강보험료 기준'
FROM policy p WHERE p.canonical_slug = 'dongjak-newborn-insurance-premium'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'manual', 'https://www.sijung.co.kr/news/articleView.html?idxno=408700'
FROM policy p WHERE p.canonical_slug = 'dongjak-newborn-insurance-premium'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #45 다둥이 행복카드
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'seoul-multi-child-happy-card', '다둥이 행복카드', NULL, '교육·마트·문화·체육·도서·외식·출산·주유·영화·대중교통 등 5%~50% 할인 또는 무료 이용. 공공시설 이용료 감면(박물관 무료, 체육시설 50%), 주차료 50%, 하수도 요금 30% 감면', '서울특별시 여성가족정책실 저출생담당관',
  (SELECT id FROM category WHERE code = 'discount'), 'one_time',
  NULL, NULL, '교육·마트·문화·체육·도서·외식·출산·주유·영화·대중교통 등 5%~50% 할인 또는 무료 이용. 공공시설 이용료 감면(박물관 무료, 체육시설 50%), 주차료 50%, 하수도 요금 30% 감면', NULL,
  '카드사 영업점 방문(신한·우리)|서울온 앱 다운로드', ARRAY['online', 'visit'],
  '상시 발급, 막내 자녀 18세까지 유효', NULL, 'none',
  '신분증, 가족관계증명서, 주민등록등본', 'https://news.seoul.go.kr/welfare/archives/100261',
  'high', 'verified', 'active',
  '[현민] 서울시 공영주차장 요금 및 국공립 박물관 무료 등 할인 연계망 구축
[이호] 출산 후 임신 준비 단계의 가구에도 둘째 임신 전부터 발급 가능. 자치구별 협력업체 다름 — seouli.bccard.com에서 자치구별 확인. 동작구 거주자 동일 적용.'
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'seoul-multi-child-happy-card' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sido_wide'
FROM policy p, region r
WHERE p.canonical_slug = 'seoul-multi-child-happy-card' AND r.code = '11'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'seoul-multi-child-happy-card' AND ls.code = 'infant_0_36m'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;
INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'seoul-multi-child-happy-card' AND ls.code = 'post_birth_60d'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;
INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'seoul-multi-child-happy-card' AND ls.code = 'pregnancy'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'none', NULL, FALSE,
  0, 216,
  'multi_child / 출생순위: second_or_more', NULL
FROM policy p WHERE p.canonical_slug = 'seoul-multi-child-happy-card'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'manual', 'https://news.seoul.go.kr/welfare/archives/100261'
FROM policy p WHERE p.canonical_slug = 'seoul-multi-child-happy-card'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #46 서울시 24시간 긴급·틈새보육
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'seoul-24hr-emergency-childcare', '서울시 24시간 긴급·틈새보육', NULL, '운영팀 확인 필요', '서울시',
  (SELECT id FROM category WHERE code = 'childcare'), 'one_time',
  NULL, NULL, '운영팀 확인 필요', NULL,
  '서울시 신청 포털', NULL,
  '상시', NULL, 'none',
  NULL, 'https://umppa.seoul.go.kr/hmpg/main.do',
  'unrated', 'needs_review', 'active',
  NULL
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'seoul-24hr-emergency-childcare' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sido_wide'
FROM policy p, region r
WHERE p.canonical_slug = 'seoul-24hr-emergency-childcare' AND r.code = '11'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'seoul-24hr-emergency-childcare' AND ls.code = 'infant_0_36m'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'none', NULL, FALSE,
  NULL, NULL,
  '서울시 거주 영유아 양육가구', NULL
FROM policy p WHERE p.canonical_slug = 'seoul-24hr-emergency-childcare'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'manual', 'https://umppa.seoul.go.kr/hmpg/main.do'
FROM policy p WHERE p.canonical_slug = 'seoul-24hr-emergency-childcare'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #47 산모·신생아 건강관리 본인부담금 지원 (서울형 바우처)
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'seoul-postpartum-copay-voucher', '산모·신생아 건강관리 본인부담금 지원 (서울형 바우처)', NULL, '정부지원 산모신생아 건강관리 서비스 이용 시 본인부담금의 90% 지원 (생계·의료·주거·교육급여 수급자 및 차상위계층)', '서울특별시 시민건강국 + 25개 자치구 보건소',
  (SELECT id FROM category WHERE code = 'voucher'), 'one_time',
  NULL, NULL, '정부지원 산모신생아 건강관리 서비스 이용 시 본인부담금의 90% 지원 (생계·의료·주거·교육급여 수급자 및 차상위계층)', NULL,
  '복지로 온라인|서울시 임신·출산 정보센터|주민등록지 보건소 방문', ARRAY['online', 'visit'],
  '출산 후 30일 안에 신청해야 함', NULL, 'none',
  '산모수첩, 신분증, 본인부담금 환급 통장 사본', 'https://seoul-agi.seoul.go.kr/healthcare-co-payment',
  'medium', 'needs_review', 'active',
  '[이호] 중앙정부 사업(산모·신생아 건강관리 지원)의 본인부담금 보전을 서울시가 추가 부담. 자치구별 일부 중복지원 불가 — 동작구는 별도 중복지원 정책 확인 필요.'
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'seoul-postpartum-copay-voucher' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sido_wide'
FROM policy p, region r
WHERE p.canonical_slug = 'seoul-postpartum-copay-voucher' AND r.code = '11'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'seoul-postpartum-copay-voucher' AND ls.code = 'post_birth_60d'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'recipient_required', NULL, TRUE,
  0, 2,
  'basic_livelihood|near_poverty / 소득: 기초생활수급자 또는 차상위계층', '기초생활수급자 또는 차상위계층'
FROM policy p WHERE p.canonical_slug = 'seoul-postpartum-copay-voucher'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);

INSERT INTO policy_household_type (policy_id, household_type_id, requirement_type)
SELECT p.id, ht.id, 'required'
FROM policy p, household_type ht
WHERE p.canonical_slug = 'seoul-postpartum-copay-voucher' AND ht.code = 'basic_livelihood'
ON CONFLICT (policy_id, household_type_id) DO NOTHING;
INSERT INTO policy_household_type (policy_id, household_type_id, requirement_type)
SELECT p.id, ht.id, 'required'
FROM policy p, household_type ht
WHERE p.canonical_slug = 'seoul-postpartum-copay-voucher' AND ht.code = 'near_poverty'
ON CONFLICT (policy_id, household_type_id) DO NOTHING;

INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'manual', 'https://seoul-agi.seoul.go.kr/healthcare-co-payment'
FROM policy p WHERE p.canonical_slug = 'seoul-postpartum-copay-voucher'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #48 서울시 임산부 교통비 지원
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'seoul-pregnant-transport-subsidy', '서울시 임산부 교통비 지원', '교통약자인 임산부에게 교통 이동편의를 지원하여 출산 친화 환경 조성', '첫째 70만원, 둘째 80만원, 셋째 이상 100만원 (교통 포인트, 카드 바우처)', '서울특별시 여성가족정책실 저출생담당관',
  (SELECT id FROM category WHERE code = 'voucher'), 'one_time',
  700000, 1000000, '첫째 70만원, 둘째 80만원, 셋째 이상 100만원 (교통 포인트, 카드 바우처)', '[{"birth_order": 1, "amount": 700000}, {"birth_order": 2, "amount": 800000}, {"birth_order": "3+", "amount": 1000000}]'::jsonb,
  '탄생육아 몽땅정보통 온라인 신청|관할 동주민센터 방문', ARRAY['online', 'visit'],
  '출산 후 6개월 안에 신청하지 않으면 못 받음', 180, 'birth',
  '신청서, 임신확인서 또는 산모수첩, 본인 명의 신용/체크카드(협약카드사)', 'https://seoul-agi.seoul.go.kr/pregnant-transportation-support',
  'high', 'verified', 'active',
  '[현민] 2026.3.30 조례 개정 적용, 1.1 이후 신청자 소급 적용
[이호] 2026.7.1.부터 거주요건 ''서울시 3개월 이상 계속 거주''로 강화 예정. 협약카드사: 신한, 삼성, KB국민, 우리, 하나, BC. 동작구 거주자도 동일 적용 (광역).'
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'seoul-pregnant-transport-subsidy' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sido_wide'
FROM policy p, region r
WHERE p.canonical_slug = 'seoul-pregnant-transport-subsidy' AND r.code = '11'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'seoul-pregnant-transport-subsidy' AND ls.code = 'post_birth_60d'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;
INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'seoul-pregnant-transport-subsidy' AND ls.code = 'pregnancy'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'none', NULL, FALSE,
  NULL, 6,
  '서울시 거주 임신 3개월 ~ 출산 후 6개월 임산부(다문화가족 외국인 임산부 포함)', NULL
FROM policy p WHERE p.canonical_slug = 'seoul-pregnant-transport-subsidy'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);

INSERT INTO policy_household_type (policy_id, household_type_id, requirement_type)
SELECT p.id, ht.id, 'required'
FROM policy p, household_type ht
WHERE p.canonical_slug = 'seoul-pregnant-transport-subsidy' AND ht.code = 'multicultural'
ON CONFLICT (policy_id, household_type_id) DO NOTHING;

INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'manual', 'https://seoul-agi.seoul.go.kr/pregnant-transportation-support'
FROM policy p WHERE p.canonical_slug = 'seoul-pregnant-transport-subsidy'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #49 서울엄마아빠택시 지원
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'seoul-mom-dad-taxi', '서울엄마아빠택시 지원', '소지할 짐과 유아차로 인해 이동이 어려운 24개월 영아 동반 양육가정의 이동편의 지원하여 외출이 편하도록 도움', '영아 1인당 기본 10만원 포인트 + 운영업체 추가 최대 2만원 (총 12만원). 쌍둥이 가정 최대 24만원. 다자녀·한부모 1만원 추가', '서울특별시 여성가족정책실 저출생담당관',
  (SELECT id FROM category WHERE code = 'voucher'), 'one_time',
  10000, 240000, '영아 1인당 기본 10만원 포인트 + 운영업체 추가 최대 2만원 (총 12만원). 쌍둥이 가정 최대 24만원. 다자녀·한부모 1만원 추가', NULL,
  '탄생육아 몽땅정보통 온라인 신청 (비대면 자격 확인)', ARRAY['online'],
  '연중 신청 가능, 24개월 이내 영아', 720, 'none',
  '별도 서류 없이 비대면 자격 확인', 'https://news.seoul.go.kr/welfare/archives/568085',
  'high', 'verified', 'active',
  '[현민] 몰라서 그냥 일반 택시비 내는 부모 많음
[이호] 운영업체: 타다·파파 2개사. 카시트 24개월 이하 전 연령 일원화 + 공기청정기·손소독제 비치. 위탁가정도 신청 가능. 동작구 거주자 동일 적용.'
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'seoul-mom-dad-taxi' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sido_wide'
FROM policy p, region r
WHERE p.canonical_slug = 'seoul-mom-dad-taxi' AND r.code = '11'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'seoul-mom-dad-taxi' AND ls.code = 'infant_0_36m'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;
INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'seoul-mom-dad-taxi' AND ls.code = 'post_birth_60d'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'none', NULL, FALSE,
  0, 24,
  '- 서울시 거주, 신청당시 24개월 이하 영아를 실질적으로 양육하는 가정(다문화가정 포함)
- 실질적 양육자: 영아와 주민등록이 함께 등재된 부,모, (외)조부모, 3촌이내 친인척 * 예외 가정위탁아동(위탁자와 주소 상이해도 확인을 통해 신청 가능)', NULL
FROM policy p WHERE p.canonical_slug = 'seoul-mom-dad-taxi'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);

INSERT INTO policy_household_type (policy_id, household_type_id, requirement_type)
SELECT p.id, ht.id, 'required'
FROM policy p, household_type ht
WHERE p.canonical_slug = 'seoul-mom-dad-taxi' AND ht.code = 'multicultural'
ON CONFLICT (policy_id, household_type_id) DO NOTHING;

INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'manual', 'https://news.seoul.go.kr/welfare/archives/568085'
FROM policy p WHERE p.canonical_slug = 'seoul-mom-dad-taxi'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #50 서울형 가사서비스 지원사업
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'seoul-housework-service-voucher', '서울형 가사서비스 지원사업', '서울시 거주 중위소득 180%이하 임산부 맞벌이 다자녀 가정에게 가사서비스를 지원하여 일생활균형 지원 및 아이키우기 좋은환경 조성', '1가정당 연 70만원 상당 가사서비스 바우처 (신한 국민행복카드 포인트 또는 탄생육아 몽땅정보통 발급)', '서울특별시 여성가족정책실 저출생담당관',
  (SELECT id FROM category WHERE code = 'voucher'), 'yearly',
  700000, 700000, '1가정당 연 70만원 상당 가사서비스 바우처 (신한 국민행복카드 포인트 또는 탄생육아 몽땅정보통 발급)', NULL,
  '탄생육아 몽땅정보통 온라인 신청', ARRAY['online'],
  '선착순 마감, 사용기한 2026.11.30까지', NULL, 'none',
  '신청서, 소득 증빙(건강보험료 납부확인서 등)', 'https://umppa.seoul.go.kr/hmpg/sprt/bzin/bzmgComtDetail.do?biz_mng_no=9F04398B4B3648348729DB5796A4DC39',
  'high', 'verified', 'active',
  '[현민] 이월 불가능하며 연내 가사 청소 및 세탁 서비스 전액 소진 필요
[이호] 선착순으로 마감 가능성 있음 → 임신 알게 되면 빠른 신청 필요. 동작구 거주자 동일 적용.'
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'seoul-housework-service-voucher' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sido_wide'
FROM policy p, region r
WHERE p.canonical_slug = 'seoul-housework-service-voucher' AND r.code = '11'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'seoul-housework-service-voucher' AND ls.code = 'infant_0_36m'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;
INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'seoul-housework-service-voucher' AND ls.code = 'post_birth_60d'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;
INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'seoul-housework-service-voucher' AND ls.code = 'pregnancy'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'median_income_percent', 180, FALSE,
  0, 144,
  '(임산부) 임신3개월~출산 후 1년이내 (맞벌이) 12세이하 자녀를 양육하고 있는 맞벌이 부부 (다자녀) 18세이하 자녀를 2명이상 양육하는 다자녀가정(단 자녀중 1명은 반드시 12세 이하여야 함)', '기준 중위소득 180% 이하'
FROM policy p WHERE p.canonical_slug = 'seoul-housework-service-voucher'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);

INSERT INTO policy_household_type (policy_id, household_type_id, requirement_type)
SELECT p.id, ht.id, 'required'
FROM policy p, household_type ht
WHERE p.canonical_slug = 'seoul-housework-service-voucher' AND ht.code = 'multi_child'
ON CONFLICT (policy_id, household_type_id) DO NOTHING;

INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'manual', 'https://umppa.seoul.go.kr/hmpg/sprt/bzin/bzmgComtDetail.do?biz_mng_no=9F04398B4B3648348729DB5796A4DC39'
FROM policy p WHERE p.canonical_slug = 'seoul-housework-service-voucher'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #51 서울형 산후조리경비 지원
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'seoul-postpartum-care-expense', '서울형 산후조리경비 지원', '산모가 임신 및 출산과정에서 겪은 정서적,육체적 피로를 빠르게 회복할 수 있도록 지원', '단태아 첫째 100만원, 둘째 120만원, 셋째 이상 150만원 (출생아 1인당, 카드 바우처). 다태아 유·사산 산모는 단태아 기준 100만원', '서울특별시 여성가족정책실 저출생담당관',
  (SELECT id FROM category WHERE code = 'voucher'), 'one_time',
  1000000, 1500000, '단태아 첫째 100만원, 둘째 120만원, 셋째 이상 150만원 (출생아 1인당, 카드 바우처). 다태아 유·사산 산모는 단태아 기준 100만원', '[{"birth_order": 1, "amount": 1000000}, {"birth_order": 2, "amount": 1200000}, {"birth_order": "3+", "amount": 1500000}]'::jsonb,
  '탄생육아 몽땅정보통 온라인 신청 (본인 휴대폰 인증, 대리신청 불가)', ARRAY['online'],
  '출산 후 6개월 안에 신청하지 않으면 못 받음', 180, 'birth',
  '산모 본인 명의 협약카드사 신용/체크카드, (외국인 산모) 외국인등록 사실증명', 'https://seoul-agi.seoul.go.kr/postpartum-care',
  'high', 'verified', 'active',
  '[현민] 2026.1.1. 출생자부터 차등 지원 및 기한 180일로 연장
[이호] 사용처: 산모·신생아 건강관리, 의약품/건강식품, 한약조제, 산후운동, 심리상담. 2026.1월부터 서울맘케어시스템 → 탄생육아 몽땅정보통(umppa.seoul.go.kr)으로 신청 플랫폼 변경. 2026.3.30부터 다자녀 차등 적용. 협약카드사: 신한(국민행복카드), 삼성, KB국민, 우리, BC. 동작구 거주자 동일 적용.'
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'seoul-postpartum-care-expense' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sido_wide'
FROM policy p, region r
WHERE p.canonical_slug = 'seoul-postpartum-care-expense' AND r.code = '11'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'seoul-postpartum-care-expense' AND ls.code = 'post_birth_60d'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'none', NULL, FALSE,
  0, 6,
  '- 신청일 기준 산모·출생아 서울 거주, 출생자녀 서울시 출생신고 [주민등록등초본]
- 주민등록표 변동사유(''출생등록'' 및 ''가족관계등록부에 의거 신규등록'') [외국인등록 사실증명, 국내거소신고 사실증명]
- 신청일 기준 등록체류지(거소이전사항) 서울 및 체류기간 등', NULL
FROM policy p WHERE p.canonical_slug = 'seoul-postpartum-care-expense'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'manual', 'https://seoul-agi.seoul.go.kr/postpartum-care'
FROM policy p WHERE p.canonical_slug = 'seoul-postpartum-care-expense'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #52 서울시 엄마 북(Book)돋움
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'seoul-mom-book-support', '서울시 엄마 북(Book)돋움', '시민의 문해력 제고를 위해 태어나는 아기가 인생의 출발을 책과 함께 시작하고 임산부(예비부모)에게 양육책과 서울시 육아정보를 제공하여 서울시 양육정책에 기여', '예비부모 도서 1권 + 아기 첫 책 2권 + 서울시 육아정책 정보 도서 1권 = 총 4권 가정 배송', '서울특별시 서울도서관',
  (SELECT id FROM category WHERE code = 'service'), 'one_time',
  NULL, NULL, '예비부모 도서 1권 + 아기 첫 책 2권 + 서울시 육아정책 정보 도서 1권 = 총 4권 가정 배송', NULL,
  '탄생육아 몽땅정보통 온라인 신청 (임산부 교통비 신청 시 동시 신청)', ARRAY['online'],
  '출산 후 3개월 안에 신청 (임산부 교통비와 함께 신청)', 90, 'birth',
  '임산부 교통비 신청과 연동(별도 서류 불요)', 'https://lib.seoul.go.kr/rwww/html/ko/bookUp.jsp',
  'high', 'verified', 'active',
  '[이호] 거주요건은 임산부 교통비와 동일(신청일 기준 서울 6개월 이상 거주). 임산부 교통비 신청 시 추가 옵션으로 선택 가능. 동작구 거주자 동일 적용.'
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'seoul-mom-book-support' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sido_wide'
FROM policy p, region r
WHERE p.canonical_slug = 'seoul-mom-book-support' AND r.code = '11'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'seoul-mom-book-support' AND ls.code = 'post_birth_60d'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;
INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'seoul-mom-book-support' AND ls.code = 'pregnancy'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'none', NULL, FALSE,
  NULL, 3,
  '- 임신 3개월(12주차)~출산 후 3개월(서울시 임산부 교통비 지원사업 대상과 동일)
- 신청일 기준 서울시 거주 임산부
- 다문화가족 외국인 임산부의 경우, 부부 모두 외국인인 경우는 제외', NULL
FROM policy p WHERE p.canonical_slug = 'seoul-mom-book-support'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);

INSERT INTO policy_household_type (policy_id, household_type_id, requirement_type)
SELECT p.id, ht.id, 'required'
FROM policy p, household_type ht
WHERE p.canonical_slug = 'seoul-mom-book-support' AND ht.code = 'multicultural'
ON CONFLICT (policy_id, household_type_id) DO NOTHING;

INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'manual', 'https://lib.seoul.go.kr/rwww/html/ko/bookUp.jsp'
FROM policy p WHERE p.canonical_slug = 'seoul-mom-book-support'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #53 세쌍둥이 이상 출산가정 축하물품 지원
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'seoul-triplet-celebration-gift', '세쌍둥이 이상 출산가정 축하물품 지원', NULL, '라이온코리아(주) 생활용품 7종(세제, 손세정제, 바디워시, 식초 등) 가정 택배 배송', '서울특별시 여성가족정책실 저출생담당관',
  (SELECT id FROM category WHERE code = 'service'), 'one_time',
  NULL, NULL, '라이온코리아(주) 생활용품 7종(세제, 손세정제, 바디워시, 식초 등) 가정 택배 배송', NULL,
  '서울시 임신·출산 정보센터 온라인 신청', ARRAY['online'],
  '출산 후 90일 안에 신청해야 함', NULL, 'none',
  '주민등록등본, 출생증명서', 'https://seoul-agi.seoul.go.kr/triplets-gift',
  'medium', 'needs_review', 'active',
  '[이호] 2025년 1월 이후 출산한 세쌍둥이 이상 가정 한정. 동작구 거주자 동일 적용.'
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'seoul-triplet-celebration-gift' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sido_wide'
FROM policy p, region r
WHERE p.canonical_slug = 'seoul-triplet-celebration-gift' AND r.code = '11'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'seoul-triplet-celebration-gift' AND ls.code = 'post_birth_60d'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'none', NULL, FALSE,
  0, 3,
  'multi_child', NULL
FROM policy p WHERE p.canonical_slug = 'seoul-triplet-celebration-gift'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'manual', 'https://seoul-agi.seoul.go.kr/triplets-gift'
FROM policy p WHERE p.canonical_slug = 'seoul-triplet-celebration-gift'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #54 서울형 아이돌봄비 지원사업
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'seoul-childcare-subsidy', '서울형 아이돌봄비 지원사업', '양육공백 가정에 실질적인 양육 조력자를 지원하여 부모 부담을 완화하고 아이키우기 좋은 환경 마련', '- 월 40시간 이상 돌봄활동 /돌봄 서비스 이용 확인 후 지급 처리
- ① 친인척 육아조력자 : 월30만원 현금지급
- ② 민간 돌봄 서비스 이용 : 업체의 실적 보고에 따라 이용 비용 지급(1인당 월30만원 한도 내)', '서울특별시 여성가족실 가족담당관: 02-2133-6556',
  (SELECT id FROM category WHERE code = 'childcare'), 'monthly',
  300000, 300000, '- 월 40시간 이상 돌봄활동 /돌봄 서비스 이용 확인 후 지급 처리
- ① 친인척 육아조력자 : 월30만원 현금지급
- ② 민간 돌봄 서비스 이용 : 업체의 실적 보고에 따라 이용 비용 지급(1인당 월30만원 한도 내)', NULL,
  '- 지원방식 : 몽땅정보 만능키 홈페이지를 통해 신청 및 돌봄활동 확인 후 비용 지급
- 신청시기 : 매월 1~15일까지 신청(23개월이 되는 달부터 신청 가능)
- 돌봄활동 : 신청 접수 승인 이후 다음달부터 돌봄활동 개시
- 돌봄비 지급 : 지원 조건(월 40시간 이상 돌봄)이 충족된 대상 가정에 현금(계좌 입금) 지급 또는 민간서비스 이용권 지원', ARRAY['online'],
  '상시신청', NULL, 'none',
  NULL, 'https://www.bokjiro.go.kr/ssis-tbu/twataa/wlfareInfo/moveTWAT52011M.do?wlfareInfoId=WLF00005097&wlfareInfoReldBztpCd=02',
  'unrated', 'needs_review', 'active',
  NULL
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'seoul-childcare-subsidy' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sido_wide'
FROM policy p, region r
WHERE p.canonical_slug = 'seoul-childcare-subsidy' AND r.code = '11'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'seoul-childcare-subsidy' AND ls.code = 'child_3y_plus'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;
INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'seoul-childcare-subsidy' AND ls.code = 'infant_0_36m'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'median_income_percent', 150, FALSE,
  NULL, 36,
  '지원대상 : 24~36개월 이하 영아가 있는 기준 중위소득 150% 이하 양육공백이 발생한 가정', '중위소득 기준 (중위소득 150.0% 이하)'
FROM policy p WHERE p.canonical_slug = 'seoul-childcare-subsidy'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'api_central_welfare', 'https://www.bokjiro.go.kr/ssis-tbu/twataa/wlfareInfo/moveTWAT52011M.do?wlfareInfoId=WLF00005097&wlfareInfoReldBztpCd=02'
FROM policy p WHERE p.canonical_slug = 'seoul-childcare-subsidy'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #55 일반아동 보육료 차액지원
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'seoul-private-daycare-fee-gap', '일반아동 보육료 차액지원', '정부미지원시설인 민간·가정어린이집을 이용하고 있는 3~5세 아동에 대한 보육료 차액 지원을 통해 보호자의 육아 부담 해소와 건전한 양육 분위기를 조성', '- 보육료 수납한도액과 정부지원 보육료의 차액 만큼 차액보육료 지원
- 3세 : 월 208,300원
- 4~5세 : 월 187,300원', '서울다산콜 / 02-120',
  (SELECT id FROM category WHERE code = 'childcare'), 'monthly',
  187300, 208300, '- 보육료 수납한도액과 정부지원 보육료의 차액 만큼 차액보육료 지원
- 3세 : 월 208,300원
- 4~5세 : 월 187,300원', NULL,
  '원본 상세에는 별도 신청방법이 명시되어 있지 않음. 어린이집 보육료 지원 절차 및 서울시/어린이집 안내에 따라 확인', NULL,
  NULL, NULL, 'none',
  NULL, 'https://www.bokjiro.go.kr/ssis-tbu/twataa/wlfareInfo/moveTWAT52011M.do?wlfareInfoId=WLF00002815&wlfareInfoReldBztpCd=02',
  'unrated', 'needs_review', 'active',
  NULL
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'seoul-private-daycare-fee-gap' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sido_wide'
FROM policy p, region r
WHERE p.canonical_slug = 'seoul-private-daycare-fee-gap' AND r.code = '11'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'seoul-private-daycare-fee-gap' AND ls.code = 'child_3y_plus'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;
INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'seoul-private-daycare-fee-gap' AND ls.code = 'infant_0_36m'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'none', NULL, FALSE,
  36, 60,
  '정부미지원시설인 민간·가정어린이집을 이용하고 있는 3~5세 아동 (서울시 소재 어린이집을 이용하는 경우)', NULL
FROM policy p WHERE p.canonical_slug = 'seoul-private-daycare-fee-gap'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'api_central_welfare', 'https://www.bokjiro.go.kr/ssis-tbu/twataa/wlfareInfo/moveTWAT52011M.do?wlfareInfoId=WLF00002815&wlfareInfoReldBztpCd=02'
FROM policy p WHERE p.canonical_slug = 'seoul-private-daycare-fee-gap'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #56 1인 자영업자, 프리랜서 등 출산휴가급여(임산부, 배우자)
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'seoul-self-employed-maternity-benefit', '1인 자영업자, 프리랜서 등 출산휴가급여(임산부, 배우자)', '출산 육아지원제도 영역밖에 있는 1인 자영업자, 프리랜서 등에게 출산(휴가)급여 지원을 통해 소득지원, 및 출생아의 건강보호와 육아지원 도모', '(1인 자영업자 등 임산부 출산급여) 1인 자영업자, 프리랜서 임산부에게 고용보험 미적용자 출산급여 외 추가로 90만원 지원 (1인 자영업자 등 배우자 출산휴가급여) 출산 배우자를 둔 1인 자영업자, 프리랜서 남편에게 최대 15일, 120만원 지원(2026.1.1.출생아부터) * 2025년 출생아는 최대 10일, 80만원 지원', '서울시 저출생담당관: 02-2133-5027',
  (SELECT id FROM category WHERE code = 'service'), 'one_time',
  800000, 1200000, '(1인 자영업자 등 임산부 출산급여) 1인 자영업자, 프리랜서 임산부에게 고용보험 미적용자 출산급여 외 추가로 90만원 지원 (1인 자영업자 등 배우자 출산휴가급여) 출산 배우자를 둔 1인 자영업자, 프리랜서 남편에게 최대 15일, 120만원 지원(2026.1.1.출생아부터) * 2025년 출생아는 최대 10일, 80만원 지원', NULL,
  '온라인 신청 (몽땅정보 만능키) https://umppa.seoul.go.kr/hmpg/main.do', ARRAY['online'],
  '상시신청', NULL, 'none',
  NULL, 'https://www.gov.kr/portal/rcvfvrSvc/dtlEx/611000019649',
  'unrated', 'needs_review', 'active',
  NULL
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'seoul-self-employed-maternity-benefit' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sido_wide'
FROM policy p, region r
WHERE p.canonical_slug = 'seoul-self-employed-maternity-benefit' AND r.code = '11'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'seoul-self-employed-maternity-benefit' AND ls.code = 'child_3y_plus'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;
INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'seoul-self-employed-maternity-benefit' AND ls.code = 'post_birth_60d'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;
INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'seoul-self-employed-maternity-benefit' AND ls.code = 'pregnancy'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'requires_review', NULL, FALSE,
  3, NULL,
  '- 1) 1인 자영업자, 프리랜서 등 임산부 출산급여 지원(단태아 90만원, 다태아 170만원) * 유사산도 지원(유사산 산모는 임신기간에 따라 차등지원)
- 신청일 기준 지원대상자, 자녀 서울시 거주
- 자녀 서울시 출생신고
- 고용노동부, 고용보험 미적용자 출산급여 기 수혜자
- 출산일(유사산일) 로부터 1년 이내 신청 2) 1인 자영업자, 프리랜서 등 배우자 출산 휴가급여 : 최대 15일, 120만원 지원(2026.1.1. 이후 출생아부터) * ''25년 출생…', '소득 조건 확인 필요'
FROM policy p WHERE p.canonical_slug = 'seoul-self-employed-maternity-benefit'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'api_gov24', 'https://www.gov.kr/portal/rcvfvrSvc/dtlEx/611000019649'
FROM policy p WHERE p.canonical_slug = 'seoul-self-employed-maternity-benefit'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #57 서울시 다태아 안심보험 지원
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'seoul-multiple-birth-insurance', '서울시 다태아 안심보험 지원', '서울시 거주 다태아(쌍둥이) 출산가정을 대상으로 질병, 상해 등에 대비한 자녀보험 가입을 지원하여 출산 가정의 안심 양육 및 경제적 부담 경감', '- 지원대상 : ''24.1.1. 이후 출생한 서울시 주민등록 다태아(쌍둥이)
- 서울시 주민등록 시 자동가입(보험료 전액 지원)
- 타 시도에서 출생한 다태아 서울시 전입시 자동가입, 서울시에서 출생한 다태아 타 시도 전출시 자동해지
- 타 보험과 관계없이 중복 보장 가능 ○ 보장기간 : 출생일로부터 2년
- (예) ''24.1.1. 출생아는 ''24.1.1. ~ ''26.1.1. 기간 내 발생한 사고에 대하여 보장받을 수 있음
- 보험금 청구는 보험사고 발생시점으로부터 3년 이내에 가능 ○ 주요보장 : 응급실 내원비, 특정 전염병 진단비, 골절·화상 수술비, 상해 또는…', '- 메리츠화재보험 / 1522-6545
- 서울시여성가족재단: 02-810-5219',
  (SELECT id FROM category WHERE code = 'service'), 'one_time',
  NULL, NULL, '- 지원대상 : ''24.1.1. 이후 출생한 서울시 주민등록 다태아(쌍둥이)
- 서울시 주민등록 시 자동가입(보험료 전액 지원)
- 타 시도에서 출생한 다태아 서울시 전입시 자동가입, 서울시에서 출생한 다태아 타 시도 전출시 자동해지
- 타 보험과 관계없이 중복 보장 가능 ○ 보장기간 : 출생일로부터 2년
- (예) ''24.1.1. 출생아는 ''24.1.1. ~ ''26.1.1. 기간 내 발생한 사고에 대하여 보장받을 수 있음
- 보험금 청구는 보험사고 발생시점으로부터 3년 이내에 가능 ○ 주요보장 : 응급실 내원비, 특정 전염병 진단비, 골절·화상 수술비, 상해 또는…', NULL,
  '- 신청방법 : 다태아 안심보험 청구센터에서 청구(https://mbi.seoul.insboon.com/)
- 구비서류 : 보험금 청구서, 주민등록등본, 출생증명서, 진료비영수증, 통장사본 등', NULL,
  '상시신청', NULL, 'none',
  NULL, 'https://www.gov.kr/portal/rcvfvrSvc/dtlEx/611000019621',
  'unrated', 'needs_review', 'active',
  NULL
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'seoul-multiple-birth-insurance' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sido_wide'
FROM policy p, region r
WHERE p.canonical_slug = 'seoul-multiple-birth-insurance' AND r.code = '11'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'seoul-multiple-birth-insurance' AND ls.code = 'child_3y_plus'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;
INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'seoul-multiple-birth-insurance' AND ls.code = 'post_birth_60d'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;
INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'seoul-multiple-birth-insurance' AND ls.code = 'pregnancy'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'none', NULL, FALSE,
  NULL, NULL,
  '- 지원대상 : ''24.1.1. 이후 출생한 서울시 주민등록 다태아(쌍둥이)
- 서울시 주민등록 시 자동가입(보험료 전액 지원)
- 타 시도에서 출생한 다태아 서울시 전입시 자동가입, 서울시에서 출생한 다태아 타 시도 전출시 자동해지
- 타 보험과 관계없이 중복 보장 가능', NULL
FROM policy p WHERE p.canonical_slug = 'seoul-multiple-birth-insurance'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'api_gov24', 'https://www.gov.kr/portal/rcvfvrSvc/dtlEx/611000019621'
FROM policy p WHERE p.canonical_slug = 'seoul-multiple-birth-insurance'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #58 위기임신 및 보호출산 지원
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'seoul-crisis-pregnancy-support', '위기임신 및 보호출산 지원', '출산 및 양육에 어려움을 겪고 있는 임산부의 안전한 출산을 지원하고 그 태아 및 자녀인 아동의 안전한 양육 환경을 보장', '- ① (상담) 위기 임산부는 언제든지, 누구든지 아동을 직접 양육하기 위해 위기 임산부 상담 기관에게 임신･출산･양육 전반에 대한 상담 가능
- (상담 방법) 대면 상담, 온라인･모바일 상담, 전화 상담 등
- (상담 내용) 원 가정 양육을 위해 임신･출산･양육 시 지원 받을 수 있는 공적 제도 안내, 각종 민간 복지 자원 및 후원 연계 등
- ② (보호 출산) 원 가정 양육을 위한 상담에도 불구하고 보호 출산을 선택한 경우 위기 임산부는 보호 출산을 위한 상담을 추가로 받고, 보호 출산을 신청한 위기 임산부가 의료 기관에서 가명으로 산전 검진 및 출산할 수 있도록 비…', '- 위기임산부핫라인(통합전화) / 1308
- 아동권리보장원(중안상담지원기관): 02-6454-8641
- 애란원(서울특별시): 02-363-1421
- 마리아모성원(부산광역시): 051-250-5477
- 가톨릭푸름터(대구광역시): 053-763-1308
- 인천자모원(인천광역시): 032-772-2071
- 앤젤하우스(광주광역시) / 062-6…',
  (SELECT id FROM category WHERE code = 'service'), 'one_time',
  NULL, NULL, '- ① (상담) 위기 임산부는 언제든지, 누구든지 아동을 직접 양육하기 위해 위기 임산부 상담 기관에게 임신･출산･양육 전반에 대한 상담 가능
- (상담 방법) 대면 상담, 온라인･모바일 상담, 전화 상담 등
- (상담 내용) 원 가정 양육을 위해 임신･출산･양육 시 지원 받을 수 있는 공적 제도 안내, 각종 민간 복지 자원 및 후원 연계 등
- ② (보호 출산) 원 가정 양육을 위한 상담에도 불구하고 보호 출산을 선택한 경우 위기 임산부는 보호 출산을 위한 상담을 추가로 받고, 보호 출산을 신청한 위기 임산부가 의료 기관에서 가명으로 산전 검진 및 출산할 수 있도록 비…', NULL,
  '- 전화, 카카오톡, 온라인, 지역상담기관 전화, 방문 신청 ○ 전화상담 신청: 1308 ○ 카카오톡 채널 모바일 상담 신청: ‘위기임산부 상담 1308’> ‘1:1 채팅하기’ ○ 온라인신청 :
- ① 상담게시판 상담문의> 온라인 상담
- ② 이메일 지역상담기관 안내> 센터 찾기> 이메일 ○ 지역상담기관 신청: 지역상담기관 안내> 센터 찾기> 전화번호 ○ 지역상담기관 방문신청 : 지역상담기관 안내> 센터 찾기', ARRAY['online', 'phone', 'visit'],
  '상시신청', NULL, 'none',
  NULL, 'https://www.gov.kr/portal/rcvfvrSvc/dtlEx/135200005048',
  'unrated', 'needs_review', 'active',
  NULL
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'seoul-crisis-pregnancy-support' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sido_wide'
FROM policy p, region r
WHERE p.canonical_slug = 'seoul-crisis-pregnancy-support' AND r.code = '11'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'seoul-crisis-pregnancy-support' AND ls.code = 'child_3y_plus'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;
INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'seoul-crisis-pregnancy-support' AND ls.code = 'post_birth_60d'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;
INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'seoul-crisis-pregnancy-support' AND ls.code = 'pregnancy'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'none', NULL, FALSE,
  NULL, NULL,
  '위기 임산부, 보호 출산 산모, 보호 출산 아동 및 아동의 생부', NULL
FROM policy p WHERE p.canonical_slug = 'seoul-crisis-pregnancy-support'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'api_gov24', 'https://www.gov.kr/portal/rcvfvrSvc/dtlEx/135200005048'
FROM policy p WHERE p.canonical_slug = 'seoul-crisis-pregnancy-support'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #59 다자녀 가구 하수도사용료 감면
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'seoul-multi-child-sewage-discount', '다자녀 가구 하수도사용료 감면', '저출산 고령화 시대를 맞아 출산장려 정책에 기여하고 다자녀가구에 실질적인 혜택을 제공하기 위해 17.1.1.부터 다자녀 가구 하수도사용료 감면을 시행', '하수도사용료의 100분의 30에 대하여 감면', '- 서울특별시 물순환안전국 물재생계획과: 02-2133-3854
- 다산콜센터 / 02-120',
  (SELECT id FROM category WHERE code = 'service'), 'one_time',
  NULL, NULL, '하수도사용료의 100분의 30에 대하여 감면', NULL,
  '방문 신청', ARRAY['visit'],
  '상시신청', NULL, 'none',
  NULL, 'https://www.gov.kr/portal/rcvfvrSvc/dtlEx/611000019615',
  'unrated', 'needs_review', 'active',
  NULL
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'seoul-multi-child-sewage-discount' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sido_wide'
FROM policy p, region r
WHERE p.canonical_slug = 'seoul-multi-child-sewage-discount' AND r.code = '11'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'seoul-multi-child-sewage-discount' AND ls.code = 'child_3y_plus'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;
INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'seoul-multi-child-sewage-discount' AND ls.code = 'infant_0_36m'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;
INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'seoul-multi-child-sewage-discount' AND ls.code = 'post_birth_60d'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'none', NULL, FALSE,
  NULL, NULL,
  '18세 이하 미성년 자녀가 세 명 이상 있는 다자녀 가구', NULL
FROM policy p WHERE p.canonical_slug = 'seoul-multi-child-sewage-discount'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);

INSERT INTO policy_household_type (policy_id, household_type_id, requirement_type)
SELECT p.id, ht.id, 'required'
FROM policy p, household_type ht
WHERE p.canonical_slug = 'seoul-multi-child-sewage-discount' AND ht.code = 'multi_child'
ON CONFLICT (policy_id, household_type_id) DO NOTHING;

INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'api_gov24', 'https://www.gov.kr/portal/rcvfvrSvc/dtlEx/611000019615'
FROM policy p WHERE p.canonical_slug = 'seoul-multi-child-sewage-discount'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #60 서울시 1인 자영업자 등 배우자 출산휴가급여 지원
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'seoul-self-employed-paternity-benefit', '서울시 1인 자영업자 등 배우자 출산휴가급여 지원', '자영업자 등의 모성보호와 경제적 부담 완화', '- 1인 자영업자 등에 배우자 출산휴가급여 2026년 출생아는 최대 15일분 120만 원 지원(2025년 출생아는 최대 10일분 80만원 지원)
※ 지원대상 계좌로 급여 이체
- 지원대상 계좌로 지급하는 것이 원칙이나 예외적으로 압류방지계좌만 보유, 채무불이행으로 금전채권 압류 등 제3자 계좌로 지급
- 온라인으로 신청한 후 대리수령 신청서 구청방문 제출(제3자 계좌 등록)', '다산콜센터 / 120',
  (SELECT id FROM category WHERE code = 'service'), 'one_time',
  800000, 1200000, '- 1인 자영업자 등에 배우자 출산휴가급여 2026년 출생아는 최대 15일분 120만 원 지원(2025년 출생아는 최대 10일분 80만원 지원)
※ 지원대상 계좌로 급여 이체
- 지원대상 계좌로 지급하는 것이 원칙이나 예외적으로 압류방지계좌만 보유, 채무불이행으로 금전채권 압류 등 제3자 계좌로 지급
- 온라인으로 신청한 후 대리수령 신청서 구청방문 제출(제3자 계좌 등록)', NULL,
  '온라인(https://umppa.seoul.go.kr)만 신청', ARRAY['online'],
  NULL, NULL, 'none',
  NULL, 'https://www.bokjiro.go.kr/ssis-tbu/twataa/wlfareInfo/moveTWAT52011M.do?wlfareInfoId=WLF00005866&wlfareInfoReldBztpCd=02',
  'unrated', 'needs_review', 'active',
  NULL
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'seoul-self-employed-paternity-benefit' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sido_wide'
FROM policy p, region r
WHERE p.canonical_slug = 'seoul-self-employed-paternity-benefit' AND r.code = '11'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'seoul-self-employed-paternity-benefit' AND ls.code = 'child_3y_plus'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;
INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'seoul-self-employed-paternity-benefit' AND ls.code = 'infant_0_36m'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;
INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'seoul-self-employed-paternity-benefit' AND ls.code = 'post_birth_60d'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'requires_review', NULL, FALSE,
  3, NULL,
  '- 신청일 기준 주민등록상 서울에 거주하는 출산한 배우자를 둔 1인 자영업자, 프리랜서, 노무제공자 등
- ① 배우자가 출산한 날부터 2026년 출생아는 120일 이내, 2025년 출생아는 90일 이내에 배우자 출산휴가 사용
- ② 출생자녀 서울에 출생신고
- ③ 신청일 기준 지원대상자, 출생자녀 주민등록상 서울 거주
- ④ 출산일 이전 18개월 중 3개월 이상 소득활동이 있는 경우
- 예외적으로 배우자 출산일 이전 3개월 보조인력을 고용하거나 배우자 출산휴가 기간 중 대체인력…', '소득 조건 확인 필요'
FROM policy p WHERE p.canonical_slug = 'seoul-self-employed-paternity-benefit'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'api_central_welfare', 'https://www.bokjiro.go.kr/ssis-tbu/twataa/wlfareInfo/moveTWAT52011M.do?wlfareInfoId=WLF00005866&wlfareInfoReldBztpCd=02'
FROM policy p WHERE p.canonical_slug = 'seoul-self-employed-paternity-benefit'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #61 서울시 중소기업 워라밸 포인트제 서울형 출산휴가급여 지원
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'seoul-sme-maternity-leave-benefit', '서울시 중소기업 워라밸 포인트제 서울형 출산휴가급여 지원', '서울시 중소기업 워라밸 포인트제''는 서울시 소재 중소기업이 아이 키우기 좋은 기업으로 성장할 수 있도록 서울시 소재 중소기업에 양육친화, 일·생활 균형 실적에 따라 인센티브를 지원하는 사업입니다. ''서울형 출산휴가급여 지원''은 ''서울시 중소기업 워라밸 포인트제'' 참여기업에 제공되는 인센티브 중 하나로, 서울시 중소기업 워라밸 포인트제 소속 출산휴가자의 출산휴가 마지막 30일에 대한 근로자…', '- 서울시 중소기업 워라밸 포인트제'' 참여 기업에서 근무하는 출산휴가자를 지원합니다.
- 출산전후휴가 90일 중 마지막 30일에 대한 통상임금에서 정부지원금을 제외한 출산휴가 급여 지원(최대 90만원)
※ 고용노동부 ‘출산전후휴가 급여’ 지급 결정된 출산휴가자에 한함', '서울특별시 여성가족재단: 02-3280-6360',
  (SELECT id FROM category WHERE code = 'service'), 'one_time',
  900000, 900000, '- 서울시 중소기업 워라밸 포인트제'' 참여 기업에서 근무하는 출산휴가자를 지원합니다.
- 출산전후휴가 90일 중 마지막 30일에 대한 통상임금에서 정부지원금을 제외한 출산휴가 급여 지원(최대 90만원)
※ 고용노동부 ‘출산전후휴가 급여’ 지급 결정된 출산휴가자에 한함', NULL,
  '- ■
- ① 서울시 중소기업 워라밸 포인트제 홈페이지를(https://pointseoul.or.kr/) 통해 온라인 신청을 합니다. ■
- ② 서울시여성가족재단에서 기업에 방문하여 포인트를 산정하고, ''서울시 워라밸 포인트 기업''으로 선정합니다. ■
- ③ ''서울시 워라밸 포인트 기업'' 소속 근로자가 출산휴가자를 갑니다. ■
- ④ 고용24 홈페이지 등을 통해 고용노동부 ''출산전후휴가 급여''를 신청하고 결정통지서를 받습니다. ■
- ⑤ 다시 서울시 중소기업 워라밸 포인트제 홈페이…', ARRAY['online', 'visit'],
  NULL, NULL, 'none',
  NULL, 'https://www.bokjiro.go.kr/ssis-tbu/twataa/wlfareInfo/moveTWAT52011M.do?wlfareInfoId=WLF00006026&wlfareInfoReldBztpCd=02',
  'unrated', 'needs_review', 'active',
  NULL
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'seoul-sme-maternity-leave-benefit' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sido_wide'
FROM policy p, region r
WHERE p.canonical_slug = 'seoul-sme-maternity-leave-benefit' AND r.code = '11'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'seoul-sme-maternity-leave-benefit' AND ls.code = 'child_3y_plus'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;
INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'seoul-sme-maternity-leave-benefit' AND ls.code = 'infant_0_36m'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;
INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'seoul-sme-maternity-leave-benefit' AND ls.code = 'post_birth_60d'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'requires_review', NULL, FALSE,
  NULL, NULL,
  '- 서울시 중소기업 워라밸 포인트제'' 참여 기업에서 근무하는 출산휴가자를 지원합니다.
※ 고용노동부 ‘출산전후휴가 급여’ 지급 결정된 출산휴가자에 한함', '소득 조건 확인 필요'
FROM policy p WHERE p.canonical_slug = 'seoul-sme-maternity-leave-benefit'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'api_central_welfare', 'https://www.bokjiro.go.kr/ssis-tbu/twataa/wlfareInfo/moveTWAT52011M.do?wlfareInfoId=WLF00006026&wlfareInfoReldBztpCd=02'
FROM policy p WHERE p.canonical_slug = 'seoul-sme-maternity-leave-benefit'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #62 꿈드림박스 (한부모/미혼모 출산축하 성장용품)
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'seoul-single-parent-dream-box', '꿈드림박스 (한부모/미혼모 출산축하 성장용품)', NULL, '현물 (포대기·물티슈 등 육아 필수품)', '서울시',
  (SELECT id FROM category WHERE code = 'service'), 'one_time',
  NULL, NULL, '현물 (포대기·물티슈 등 육아 필수품)', NULL,
  '서울시 신청 포털', NULL,
  '운영팀 확인 필요', NULL, 'none',
  NULL, 'https://umppa.seoul.go.kr/hmpg/main.do',
  'unrated', 'needs_review', 'active',
  '[현민] 한부모 한정이라는 점 모르고 지원 대상에서 제외된 줄 알기 쉬움'
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'seoul-single-parent-dream-box' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sido_wide'
FROM policy p, region r
WHERE p.canonical_slug = 'seoul-single-parent-dream-box' AND r.code = '11'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'seoul-single-parent-dream-box' AND ls.code = 'pregnancy'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'none', NULL, FALSE,
  NULL, NULL,
  '서울시 거주 한부모 / 미혼모 / 미혼 임신모', NULL
FROM policy p WHERE p.canonical_slug = 'seoul-single-parent-dream-box'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);

INSERT INTO policy_household_type (policy_id, household_type_id, requirement_type)
SELECT p.id, ht.id, 'required'
FROM policy p, household_type ht
WHERE p.canonical_slug = 'seoul-single-parent-dream-box' AND ht.code = 'single_parent'
ON CONFLICT (policy_id, household_type_id) DO NOTHING;

INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'manual', 'https://umppa.seoul.go.kr/hmpg/main.do'
FROM policy p WHERE p.canonical_slug = 'seoul-single-parent-dream-box'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #63 35세 이상 임신부 의료비 지원
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'seoul-over35-pregnancy-medical', '35세 이상 임신부 의료비 지원', '35세 이상 임신부 의료비 지원 보건사업 의료비지원 35세 이상 임신부 의료비 지원 목적 35세 이상 임산부에게 의료비를 지원하여 출산 가정의 경제적 부담을 경감하고 건강한 출산을 지원 지원대상 신청일 기준 서울시에 거주하는 35세 이상 임산부 다문화가족 외국인 임산부 포함(단, 부부 모두 외국인인 경우 지원제외) 연령기준 분만예정연도(임신확인서 기재 예정일기준)에 35세 이상이면 신청가능 2026년 출산 예정인경우 1991년생, 2027년 출산 예정인경우 1992년생까지 신청가능 ※ 국민행복카드 임산부 바우처 와 동시 사용 불가 ※ 신청 시 영수증 모아서 1회에 한하여 신청 사업내용 지원내용 : 임신확인서에 기재된 임신확인일부터 출산…', '임신 확인일~출산 전까지 산전 외래 진료·검사비 최대 50만원 환급', '서울특별시 시민건강국 + 자치구 보건소',
  (SELECT id FROM category WHERE code = 'cash'), 'one_time',
  500000, 500000, '임신 확인일~출산 전까지 산전 외래 진료·검사비 최대 50만원 환급', NULL,
  '탄생육아 몽땅정보통 온라인 신청|거주지 관할 보건소 방문', ARRAY['online', 'visit'],
  '출산 후 6개월 안에 신청해야 함', 180, 'birth',
  '임신확인서(임신출산진료비지급신청서), 진료비 영수증, 진료비 세부내역서', 'https://seoul-agi.seoul.go.kr/preg-med-support',
  'high', 'verified', 'active',
  '[현민] 타과 진료비 가능하나, 국민행복카드 바우처와 중복 결제 불가
[이호] 국민행복카드 임산부 바우처와 중복 사용 불가. 2026년 분만예정자는 1991년생부터 해당. 동작구 거주자 동일 적용.'
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'seoul-over35-pregnancy-medical' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sido_wide'
FROM policy p, region r
WHERE p.canonical_slug = 'seoul-over35-pregnancy-medical' AND r.code = '11'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'seoul-over35-pregnancy-medical' AND ls.code = 'pregnancy'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'none', NULL, FALSE,
  NULL, NULL,
  '신청일 기준 서울시에 거주하는 35세 이상 임산부
- 다문화가족 외국인 임산부 포함
- 부부 모두 외국인인 경우 제외', NULL
FROM policy p WHERE p.canonical_slug = 'seoul-over35-pregnancy-medical'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);

INSERT INTO policy_household_type (policy_id, household_type_id, requirement_type)
SELECT p.id, ht.id, 'required'
FROM policy p, household_type ht
WHERE p.canonical_slug = 'seoul-over35-pregnancy-medical' AND ht.code = 'multicultural'
ON CONFLICT (policy_id, household_type_id) DO NOTHING;

INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'manual', 'https://seoul-agi.seoul.go.kr/preg-med-support'
FROM policy p WHERE p.canonical_slug = 'seoul-over35-pregnancy-medical'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #64 서울 난자동결 시술비용 지원사업
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'seoul-egg-freezing-support', '서울 난자동결 시술비용 지원사업', NULL, '난자채취 사전 검사비 및 시술비의 50%, 최대 200만원 (생애 1회)', '서울특별시 여성가족재단',
  (SELECT id FROM category WHERE code = 'cash'), 'one_time',
  2000000, 2000000, '난자채취 사전 검사비 및 시술비의 50%, 최대 200만원 (생애 1회)', NULL,
  '탄생육아 몽땅정보통 온라인 신청', ARRAY['online'],
  '시술 전 사전 신청 필요', NULL, 'none',
  'AMH 검사결과지(1.5ng/ml 이하), 주민등록초본(거주이력), 소득증빙', 'https://seoul-agi.seoul.go.kr/sofp-csp',
  'high', 'verified', 'active',
  '[이호] 거주요건: 서울시 6개월 이상 계속 거주, 20~49세 여성, AMH 1.5ng/ml 이하. 동작구 거주자 동일 적용.'
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'seoul-egg-freezing-support' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sido_wide'
FROM policy p, region r
WHERE p.canonical_slug = 'seoul-egg-freezing-support' AND r.code = '11'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'seoul-egg-freezing-support' AND ls.code = 'pregnancy_prep'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'median_income_percent', 180, FALSE,
  NULL, NULL,
  '소득: 기준 중위소득 180% 이하', '기준 중위소득 180% 이하'
FROM policy p WHERE p.canonical_slug = 'seoul-egg-freezing-support'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'manual', 'https://seoul-agi.seoul.go.kr/sofp-csp'
FROM policy p WHERE p.canonical_slug = 'seoul-egg-freezing-support'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #65 서울시 1인 자영업자 등 임산부 출산급여 지원
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'seoul-self-employed-maternity-cash', '서울시 1인 자영업자 등 임산부 출산급여 지원', '1인 자영업자등의 모성보호와 경제적 부담 완화', '고용보험 미적용자 출산급여(고용노동부 150만원)에 서울시 90만원 추가 지원 (단태아 총 240만원, 다태아 총 170만원 추가)', '서울특별시 여성가족정책실 저출생담당관',
  (SELECT id FROM category WHERE code = 'cash'), 'one_time',
  900000, 2400000, '고용보험 미적용자 출산급여(고용노동부 150만원)에 서울시 90만원 추가 지원 (단태아 총 240만원, 다태아 총 170만원 추가)', NULL,
  '탄생육아 몽땅정보통 온라인 신청', ARRAY['online'],
  '출산 후 1년 안에 신청해야 함', 365, 'birth',
  '고용보험 미적용자 출산급여 지급결정통지서(직인 포함), 가족관계증명서', 'https://seoul-agi.seoul.go.kr/self-employed-support',
  'high', 'verified', 'active',
  '[이호] 선결조건: 고용노동부 고용보험 미적용자 출산급여(150만원) 먼저 수혜 필요. 처리기간 14일. 별도로 ''배우자 출산휴가급여 지원'' 사업도 운영. 동작구 거주자 동일 적용.'
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'seoul-self-employed-maternity-cash' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sido_wide'
FROM policy p, region r
WHERE p.canonical_slug = 'seoul-self-employed-maternity-cash' AND r.code = '11'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'seoul-self-employed-maternity-cash' AND ls.code = 'infant_0_36m'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;
INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'seoul-self-employed-maternity-cash' AND ls.code = 'post_birth_60d'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'none', NULL, FALSE,
  0, 12,
  '- 지원대상 출산(유·사산)한 1인 자영업자 및 프리랜서 등 임산부 자격요건
- ① 고용노동부 ‘고용보험 미적용자 출산급여’ 수혜자
- ② 신청일 기준 서울시 거주 및 출생자녀 서울시 출생신고
- ③ 출산일로부터 1년 이내 신청', '고용보험 미적용자 출산급여 수혜자'
FROM policy p WHERE p.canonical_slug = 'seoul-self-employed-maternity-cash'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'manual', 'https://seoul-agi.seoul.go.kr/self-employed-support'
FROM policy p WHERE p.canonical_slug = 'seoul-self-employed-maternity-cash'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #66 서울시 난임부부 시술비 지원
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'seoul-infertility-treatment', '서울시 난임부부 시술비 지원', '- 난임부부의 난임시술비 지원을 추가 확대하여 경제적 부담을 실효성 있게 경감 - 효과적인 난임치료를 받도록 하여 희망하는 소중한 생명의 임신과 출산을 적극 지원', '회당 신선배아 110만원, 동결배아 50만원, 인공수정 30만원. 출산당 25회까지 (시술칸막이 없음)', '서울특별시 시민건강국 + 25개 자치구 보건소',
  (SELECT id FROM category WHERE code = 'cash'), 'per_visit',
  300000, 1100000, '회당 신선배아 110만원, 동결배아 50만원, 인공수정 30만원. 출산당 25회까지 (시술칸막이 없음)', NULL,
  'e보건소 온라인|정부24 온라인|주민등록지 보건소 방문', ARRAY['online', 'visit'],
  '시술 시작 전 보건소 신청 필요', NULL, 'none',
  '난임진단서, 부부 신분증, 건강보험증, 소득증빙(필요시), 주민등록등본', 'https://seoul-agi.seoul.go.kr/ifc-csp',
  'high', 'verified', 'active',
  '[이호] 보조생식술 시작일 2024.11.1 이후 시술 적용. 추가 ''서울형 난임시술 중단 의료비 지원''(시술 중단 시) 별도 사업 있음. 자치구 보건소가 접수 — 동작구 보건소도 동일 신청 처리.'
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'seoul-infertility-treatment' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sido_wide'
FROM policy p, region r
WHERE p.canonical_slug = 'seoul-infertility-treatment' AND r.code = '11'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'seoul-infertility-treatment' AND ls.code = 'pregnancy_prep'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'requires_review', NULL, FALSE,
  NULL, NULL,
  '- 지원자격
- 법적 혼인상태에 있거나, 신청일 기준 1년 이상 사실상 혼인 관계를 유지하였다고 관할 보건소로부터 확인된 난임부부(지원신청 접수일 기준)
- 신청일 기준 서울시 거주(여성기준)가 확인된 자
- 부부 중 최소한 한 명은 주민등록이 되어 있는 대한민국 국적 소유자이면서, 부부 모두 건강보험 가입 및 보험료 고지 여부가 확인되는 자 ○ 소득 기준 : 없음', '소득 조건 확인 필요'
FROM policy p WHERE p.canonical_slug = 'seoul-infertility-treatment'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'manual', 'https://seoul-agi.seoul.go.kr/ifc-csp'
FROM policy p WHERE p.canonical_slug = 'seoul-infertility-treatment'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #67 서울형 손주돌봄수당 (친인척형 + 민간형)
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'seoul-grandparent-childcare-allowance', '서울형 손주돌봄수당 (친인척형 + 민간형)', NULL, '친인척형: 영아 1명 월 30만원, 2명 월 45만원, 3명 월 60만원. 민간형: 영아 1명 시간당 7,500원(월 15~30만원), 2명 시간당 11,250원(월 22.5~45만원), 3명 시간당 15,000원(월 30~60만원)', '서울특별시 여성가족정책실 저출생담당관',
  (SELECT id FROM category WHERE code = 'cash'), 'monthly',
  7500, 600000, '친인척형: 영아 1명 월 30만원, 2명 월 45만원, 3명 월 60만원. 민간형: 영아 1명 시간당 7,500원(월 15~30만원), 2명 시간당 11,250원(월 22.5~45만원), 3명 시간당 15,000원(월 30~60만원)', NULL,
  '탄생육아 몽땅정보통 온라인 신청', ARRAY['online'],
  '매월 1~15일 신청, 24~36개월 영아 대상', NULL, 'none',
  '가족관계증명서, 소득증빙, 돌봄제공자 신원확인, (민간형) 지정기관 이용 계약서', 'https://umppa.seoul.go.kr/hmpg/sprt/bzin/bzmgComtDetail.do?biz_mng_no=59F45FE9BC024848AD07143C962E6869',
  'high', 'verified', 'active',
  '[현민] 조부모의 비공식 돌봄 노동의 비용 보장 및 민간 연계 가능
[이호] 친인척형: 4촌 이내, 서울 외 거주 친인척도 가능. 민간형 지정기관: 맘시터 프로케어, 째깍악어, 우리동네돌봄히어로. 동작구 거주자 동일 적용.'
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'seoul-grandparent-childcare-allowance' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sido_wide'
FROM policy p, region r
WHERE p.canonical_slug = 'seoul-grandparent-childcare-allowance' AND r.code = '11'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'seoul-grandparent-childcare-allowance' AND ls.code = 'infant_0_36m'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'median_income_percent', 150, FALSE,
  23, 36,
  '소득: 기준 중위소득 150% 이하 (맞벌이 가정 부부 합산소득 25% 경감 적용)', '기준 중위소득 150% 이하 (맞벌이 가정 부부 합산소득 25% 경감 적용)'
FROM policy p WHERE p.canonical_slug = 'seoul-grandparent-childcare-allowance'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'manual', 'https://umppa.seoul.go.kr/hmpg/sprt/bzin/bzmgComtDetail.do?biz_mng_no=59F45FE9BC024848AD07143C962E6869'
FROM policy p WHERE p.canonical_slug = 'seoul-grandparent-childcare-allowance'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #68 서울형 청소년(한)부모 아동양육비 지원
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'seoul-teen-parent-childcare', '서울형 청소년(한)부모 아동양육비 지원', NULL, '청소년 부모(중위소득 63% 이하): 월 45만원(중앙 25만원+서울형 20만원). 63~90%는 월 20만원. 청소년 한부모(중위소득 65% 이하): 월 57만원(중앙 37만원+서울형 20만원). 65~90%는 월 20만원', '서울특별시 여성가족정책실 가족담당관',
  (SELECT id FROM category WHERE code = 'cash'), 'monthly',
  200000, 570000, '청소년 부모(중위소득 63% 이하): 월 45만원(중앙 25만원+서울형 20만원). 63~90%는 월 20만원. 청소년 한부모(중위소득 65% 이하): 월 57만원(중앙 37만원+서울형 20만원). 65~90%는 월 20만원', NULL,
  '동주민센터 방문|복지로 온라인(청소년 한부모)', ARRAY['online', 'visit'],
  '24세 이하 부모, 연중 신청', NULL, 'none',
  '주민등록등본, 가족관계증명서, 소득증빙', 'https://news.seoul.go.kr/welfare/archives/554926',
  'high', 'verified', 'active',
  '[이호] 기존 중앙정부 청소년 한부모 아동양육비(월 37만원) 위에 서울시가 월 20만원 추가. 동작구 거주자 동일 적용.'
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'seoul-teen-parent-childcare' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sido_wide'
FROM policy p, region r
WHERE p.canonical_slug = 'seoul-teen-parent-childcare' AND r.code = '11'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'seoul-teen-parent-childcare' AND ls.code = 'infant_0_36m'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;
INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'seoul-teen-parent-childcare' AND ls.code = 'post_birth_60d'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'median_income_percent', 90, FALSE,
  0, 216,
  'single_parent / 소득: 기준 중위소득 90% 이하', '기준 중위소득 90% 이하'
FROM policy p WHERE p.canonical_slug = 'seoul-teen-parent-childcare'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'manual', 'https://news.seoul.go.kr/welfare/archives/554926'
FROM policy p WHERE p.canonical_slug = 'seoul-teen-parent-childcare'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #69 자녀출산 무주택가구 주거비 지원
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'seoul-newborn-housing-subsidy', '자녀출산 무주택가구 주거비 지원', '무주택 가구의 주거비 부담을 줄여 안정된 주거환경 속에서 자녀를 출산 할 수 있도록 지원하고자 함', '월 최대 30만원, 2년간 최대 720만원 (추가 출산 시 최장 4년 연장)', '서울특별시 여성가족정책실 저출생담당관',
  (SELECT id FROM category WHERE code = 'cash'), 'monthly',
  300000, 7200000, '월 최대 30만원, 2년간 최대 720만원 (추가 출산 시 최장 4년 연장)', NULL,
  '탄생육아 몽땅정보통 온라인 신청', ARRAY['online'],
  '출산 후 1년 안에 신청해야 함', 365, 'birth',
  '확정일자 임대차계약서 사본, 금융거래확인서(전세) 또는 월세 이체증, 청약홈 주택소유현황(부·모), 가족관계증명서(부·모)', 'https://seoul-agi.seoul.go.kr/non-homeowner-support',
  'high', 'needs_review', 'active',
  '[현민] 2026년 주택 기준 전세 5억으로 상향 완화, 특례 대출자 제외
[이호] 주택조건: 부·모 모두 무주택, 공공임대 미거주자, 전세 5억 이하 또는 보증금+월세 환산 229만원 이하. 자치구 위탁 운영 아닌 서울시 직접 사업. 동작구 거주자 동일 적용.'
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'seoul-newborn-housing-subsidy' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sido_wide'
FROM policy p, region r
WHERE p.canonical_slug = 'seoul-newborn-housing-subsidy' AND r.code = '11'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'seoul-newborn-housing-subsidy' AND ls.code = 'infant_0_36m'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;
INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'seoul-newborn-housing-subsidy' AND ls.code = 'post_birth_60d'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'median_income_percent', 180, FALSE,
  0, 12,
  '- 25.1.1.이후 자녀를 출산(입양)한 서울시 거주 무주택 가구
※ 입양아는 신청일 기준 출생일로부터 48개월 이하인 아동', '기준 중위소득 180% 이하'
FROM policy p WHERE p.canonical_slug = 'seoul-newborn-housing-subsidy'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'manual', 'https://seoul-agi.seoul.go.kr/non-homeowner-support'
FROM policy p WHERE p.canonical_slug = 'seoul-newborn-housing-subsidy'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #70 저소득 한부모가족 지원 (아동양육비·생활보조금·교통비)
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'seoul-single-parent-allowance', '저소득 한부모가족 지원 (아동양육비·생활보조금·교통비)', NULL, '아동양육비 자녀 1인당 월 23만원, 추가아동양육비(조손·35세 이상 미혼·25~34세 한부모) 월 10만원, 아동교육지원비 연 10만원, 생활보조금 가구당 월 10만원, 교통비 자녀 1인당 분기 108,000원, 입학금/수업료 실비', '서울특별시 여성가족정책실 가족담당관',
  (SELECT id FROM category WHERE code = 'cash'), 'monthly',
  100000, 230000, '아동양육비 자녀 1인당 월 23만원, 추가아동양육비(조손·35세 이상 미혼·25~34세 한부모) 월 10만원, 아동교육지원비 연 10만원, 생활보조금 가구당 월 10만원, 교통비 자녀 1인당 분기 108,000원, 입학금/수업료 실비', NULL,
  '가구주 주민등록 소재지 관할 동주민센터|복지로 온라인', ARRAY['online', 'visit'],
  '한부모가족 인정 시 즉시 신청, 매월 정기 지급', NULL, 'none',
  '한부모가족 증명서, 주민등록등본, 소득증빙, 통장사본', 'https://news.seoul.go.kr/welfare/archives/548149',
  'high', 'verified', 'active',
  '[이호] 중앙정부(여성가족부) 사업의 서울시 운영. 자녀 만 18세 미만(취학 시 22세 미만). 동작구 거주자 동일 적용, 신청은 동작구 동주민센터.'
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'seoul-single-parent-allowance' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;
INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'sido_wide'
FROM policy p, region r
WHERE p.canonical_slug = 'seoul-single-parent-allowance' AND r.code = '11'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'seoul-single-parent-allowance' AND ls.code = 'infant_0_36m'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;
INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'seoul-single-parent-allowance' AND ls.code = 'post_birth_60d'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'median_income_percent', 65, FALSE,
  0, 216,
  'single_parent / 소득: 기준 중위소득 65% 이하', '기준 중위소득 65% 이하'
FROM policy p WHERE p.canonical_slug = 'seoul-single-parent-allowance'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'manual', 'https://news.seoul.go.kr/welfare/archives/548149'
FROM policy p WHERE p.canonical_slug = 'seoul-single-parent-allowance'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #71 출산가구 전기요금 경감
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'national-birth-family-electricity-discount', '출산가구 전기요금 경감', NULL, '월 전기요금의 30% 할인, 월 한도 16,000원. 출생일로부터 36개월 미만 영아가 있는 가구', '한국전력공사 (KEPCO) / 산업통상자원부',
  (SELECT id FROM category WHERE code = 'discount'), 'monthly',
  16000, 16000, '월 전기요금의 30% 할인, 월 한도 16,000원. 출생일로부터 36개월 미만 영아가 있는 가구', NULL,
  '한전 사이버지점 online.kepco.co.kr|한전 고객센터 국번없이 123|전국 한전 지사 방문|정부24 보조금24', ARRAY['visit'],
  '기한은 없지만 신청한 날부터 일할 적용 — 빨리 신청할수록 할인 기간 길어짐', NULL, 'none',
  '주민등록등본(영아 포함), 신청서', 'https://www.korea.kr/news/policyNewsView.do?newsId=148885177',
  'medium', 'needs_review', 'active',
  '[이호] 2025년 정책브리핑 기준 30% / 월 16,000원 한도. 2026 변경 사항 미확인 — 사람 검수 권장'
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'national-birth-family-electricity-discount' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'national-birth-family-electricity-discount' AND ls.code = 'infant_0_36m'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;
INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'national-birth-family-electricity-discount' AND ls.code = 'post_birth_60d'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'none', NULL, FALSE,
  0, 36,
  NULL, NULL
FROM policy p WHERE p.canonical_slug = 'national-birth-family-electricity-discount'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'manual', 'https://www.korea.kr/news/policyNewsView.do?newsId=148885177'
FROM policy p WHERE p.canonical_slug = 'national-birth-family-electricity-discount'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #72 난임시술 지원결정통지서 유효기간 연장 (3개월→6개월)
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'national-infertility-validity-extension', '난임시술 지원결정통지서 유효기간 연장 (3개월→6개월)', NULL, '지원결정통지서 발급 후 유효기간 6개월 (기존 3개월에서 확대). 시술비 본체 금액은 별도 — 체외수정 신선배아 110만원, 동결배아 50만원, 인공수정 30만원 (1회당)', '보건복지부 인구아동정책관 출산정책과',
  (SELECT id FROM category WHERE code = 'information'), 'one_time',
  300000, 1100000, '지원결정통지서 발급 후 유효기간 6개월 (기존 3개월에서 확대). 시술비 본체 금액은 별도 — 체외수정 신선배아 110만원, 동결배아 50만원, 인공수정 30만원 (1회당)', NULL,
  '관할 보건소 방문|정부24 온라인|e보건소 온라인', ARRAY['online', 'visit'],
  '지원결정통지서 발급 후 6개월 내 시술 시작', NULL, 'none',
  '난임진단서, 부부 건강보험증, 주민등록등본', 'https://www.korea.kr/news/policyNewsView.do?newsId=148956615',
  'high', 'verified', 'active',
  '[이호] 2026-01-01 시행. 시술 일정 조정·병원 대기로 재신청 불편 해소 목적. 「2026년 보건·복지 정책 이렇게 달라집니다」 정책브리핑에 명시.'
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'national-infertility-validity-extension' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'national-infertility-validity-extension' AND ls.code = 'pregnancy_prep'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'none', NULL, FALSE,
  NULL, NULL,
  '소득: none (소득기준 폐지 유지)', 'none (소득기준 폐지 유지)'
FROM policy p WHERE p.canonical_slug = 'national-infertility-validity-extension'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'manual', 'https://www.korea.kr/news/policyNewsView.do?newsId=148956615'
FROM policy p WHERE p.canonical_slug = 'national-infertility-validity-extension'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #73 건강보험 임신·출산 진료비 지원
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'national-pregnancy-medical-voucher', '건강보험 임신·출산 진료비 지원', '임산부와 영유아의 의료비 부담을 경감하여 출산 친화적 환경을 조성하고, 주기적인 산전 진찰로 건강한 태아를 분만할 수 있도록 임산부와 2세 미만 영유아의 진료비 등의 본인부담금(급여·비급여) 결제에 사용할 수 있는 이용권을 제공하는 제도', '단태아 100만원, 다태아(쌍둥이 이상) 140만원. 분만취약지 거주 시 +20만원, 만19세 이하 청소년산모 +120만원', '국민건강보험공단 / 보건복지부',
  (SELECT id FROM category WHERE code = 'voucher'), 'one_time',
  200000, 1400000, '단태아 100만원, 다태아(쌍둥이 이상) 140만원. 분만취약지 거주 시 +20만원, 만19세 이하 청소년산모 +120만원', NULL,
  '국민건강보험공단 1577-1000|공단 홈페이지 nhis.or.kr|BC·KB·삼성·롯데·신한·NH 등 카드사 홈페이지·전화|요양기관(병원) 정보마당', ARRAY['online', 'phone'],
  '임신확인 즉시 신청 가능. 출산 후 2년 안에 사용하지 않으면 잔액 소멸', 730, 'birth',
  '임신확인서, 신분증, 국민행복카드', 'https://www.nhis.or.kr/static/html/wbma/c/wbmac0212.html',
  'medium', 'needs_review', 'active',
  '[현민] 산모 + 만 2세 이하 영아 의료비까지 사용 가능
[이호] voucher.go.kr 및 다수 출처는 출산 후 2년 사용. nhis.or.kr 정적 페이지는 옛 1년 표기 잔존'
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'national-pregnancy-medical-voucher' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'national-pregnancy-medical-voucher' AND ls.code = 'pregnancy'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'health_insurance_based', NULL, FALSE,
  NULL, NULL,
  '- 임신‧출산(유산·사산 포함)이 확인된 건강보험 가입자 또는 피부양자 ○ 2세 미만인 가입자 또는 피부양자의 법정대리인(출산한 가입자 또는 피부양자가 사망한 경우) * 제외
- 대상 : (의료급여법)에 따라 의료급여를 받는 자(수급권자), 건강보험 적용배제 신청자, 건강보험 자격상실자, 급여정지자', NULL
FROM policy p WHERE p.canonical_slug = 'national-pregnancy-medical-voucher'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'manual', 'https://www.nhis.or.kr/static/html/wbma/c/wbmac0212.html'
FROM policy p WHERE p.canonical_slug = 'national-pregnancy-medical-voucher'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #74 기저귀·조제분유 지원 (장애인·다자녀 소득기준 완화)
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'national-diaper-formula-extended', '기저귀·조제분유 지원 (장애인·다자녀 소득기준 완화)', NULL, '기저귀 월 9만원, 조제분유 월 11만원 (만 2세 미만 영아)', '보건복지부 인구아동정책관 출산정책과',
  (SELECT id FROM category WHERE code = 'voucher'), 'monthly',
  90000, 110000, '기저귀 월 9만원, 조제분유 월 11만원 (만 2세 미만 영아)', NULL,
  '관할 보건소 방문|복지로 온라인', ARRAY['online', 'visit'],
  NULL, NULL, 'none',
  '출생증명서, 소득증빙, 장애인등록증 또는 다자녀 증빙', 'https://www.korea.kr/news/policyNewsView.do?newsId=148956615',
  'high', 'verified', 'active',
  '[이호] 2026-07-01 시행. 기존 장애인·다자녀(2인 이상) 가구 기준 80%→100%로 완화. 기초생활·차상위·한부모 가구는 소득 무관 유지.'
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'national-diaper-formula-extended' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'national-diaper-formula-extended' AND ls.code = 'infant_0_36m'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;
INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'national-diaper-formula-extended' AND ls.code = 'post_birth_60d'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'median_income_percent', 100, TRUE,
  0, 24,
  'disabled|multi_child|basic_livelihood|near_poverty|single_parent / 소득: 기초생활보장·차상위·한부모는 무관, 장애인·다자녀(2인 이상) 가구는 기준중위소득 100% 이하 (2026-07-01부터 80%→100%로 완화)', '기초생활보장·차상위·한부모는 무관, 장애인·다자녀(2인 이상) 가구는 기준중위소득 100% 이하 (2026-07-01부터 80%→100%로 완화)'
FROM policy p WHERE p.canonical_slug = 'national-diaper-formula-extended'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);

INSERT INTO policy_household_type (policy_id, household_type_id, requirement_type)
SELECT p.id, ht.id, 'required'
FROM policy p, household_type ht
WHERE p.canonical_slug = 'national-diaper-formula-extended' AND ht.code = 'multi_child'
ON CONFLICT (policy_id, household_type_id) DO NOTHING;
INSERT INTO policy_household_type (policy_id, household_type_id, requirement_type)
SELECT p.id, ht.id, 'required'
FROM policy p, household_type ht
WHERE p.canonical_slug = 'national-diaper-formula-extended' AND ht.code = 'single_parent'
ON CONFLICT (policy_id, household_type_id) DO NOTHING;
INSERT INTO policy_household_type (policy_id, household_type_id, requirement_type)
SELECT p.id, ht.id, 'required'
FROM policy p, household_type ht
WHERE p.canonical_slug = 'national-diaper-formula-extended' AND ht.code = 'disabled'
ON CONFLICT (policy_id, household_type_id) DO NOTHING;
INSERT INTO policy_household_type (policy_id, household_type_id, requirement_type)
SELECT p.id, ht.id, 'required'
FROM policy p, household_type ht
WHERE p.canonical_slug = 'national-diaper-formula-extended' AND ht.code = 'basic_livelihood'
ON CONFLICT (policy_id, household_type_id) DO NOTHING;
INSERT INTO policy_household_type (policy_id, household_type_id, requirement_type)
SELECT p.id, ht.id, 'required'
FROM policy p, household_type ht
WHERE p.canonical_slug = 'national-diaper-formula-extended' AND ht.code = 'near_poverty'
ON CONFLICT (policy_id, household_type_id) DO NOTHING;

INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'manual', 'https://www.korea.kr/news/policyNewsView.do?newsId=148956615'
FROM policy p WHERE p.canonical_slug = 'national-diaper-formula-extended'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #75 외국인 아동 보육료 지원
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'national-foreign-child-daycare', '외국인 아동 보육료 지원', '어린이집 외국인 재원 아동에 대한 보육료 지원으로 영유아의 차별받지 않는 보육환경 조성 및 안정적 보육서비스 제공', '어린이집 이용 0~5세 무상보육. 만 0세 약 514,000원/월, 만 1세 약 452,000원/월, 만 2세 약 375,000원/월, 만 3~5세 약 280,000원/월 (어린이집에 직접 지급)', '보건복지부 보육정책과',
  (SELECT id FROM category WHERE code = 'voucher'), 'monthly',
  NULL, NULL, '어린이집 이용 0~5세 무상보육. 만 0세 약 514,000원/월, 만 1세 약 452,000원/월, 만 2세 약 375,000원/월, 만 3~5세 약 280,000원/월 (어린이집에 직접 지급)', NULL,
  '읍면동 행정복지센터 방문|복지로 온라인|정부24 온라인|어린이집 입소 시 일괄', ARRAY['online', 'visit'],
  '어린이집 입소 시 신청 — 부모는 차감된 고지서만 부담', NULL, 'none',
  '신분증, 어린이집 재원증명', 'https://www.bokjiro.go.kr/ssis-tbu/twataa/wlfareInfo/moveTWAT52011M.do?wlfareInfoId=WLF00003250',
  'high', 'needs_review', 'active',
  '[이호] 0세 부모급여 100만 중 약 51만 4천원이 보육료 바우처로, 차액(약 48만 6천원)이 현금. 1세도 마찬가지로 50만 중 약 45만이 보육료'
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'national-foreign-child-daycare' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'national-foreign-child-daycare' AND ls.code = 'infant_0_36m'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'none', NULL, FALSE,
  0, 71,
  '서울시 어린이집 재원 외국인 영유아(0~5세)', NULL
FROM policy p WHERE p.canonical_slug = 'national-foreign-child-daycare'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'api_central_welfare', 'https://www.bokjiro.go.kr/ssis-tbu/twataa/wlfareInfo/moveTWAT52011M.do?wlfareInfoId=WLF00003250'
FROM policy p WHERE p.canonical_slug = 'national-foreign-child-daycare'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #76 저소득층 기저귀·조제분유 지원
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'national-low-income-diaper-formula', '저소득층 기저귀·조제분유 지원', NULL, '기저귀 월 90,000원 / 조제분유 월 110,000원 / 둘 다 받으면 월 200,000원 (국민행복카드 바우처)', '보건복지부 출산정책과 / 시군구 보건소',
  (SELECT id FROM category WHERE code = 'voucher'), 'monthly',
  90000, 200000, '기저귀 월 90,000원 / 조제분유 월 110,000원 / 둘 다 받으면 월 200,000원 (국민행복카드 바우처)', NULL,
  '관할 보건소 방문|복지로 온라인|정부24 온라인', ARRAY['online', 'visit'],
  '출생 후 60일 안에 신청해야 24개월 전액 지원', NULL, 'none',
  '신분증, 출생증명서, 수급 자격 증빙', 'https://www.bokjiro.go.kr/ssis-tbu/twataa/wlfareInfo/moveTWAT52011M.do?wlfareInfoId=WLF00000092',
  'high', 'verified', 'active',
  '[현민] 국민행복카드 바우처 생성형 충전 방식, 3개월 주기 충전
[이호] 민감정보 매칭 필요(한부모·장애·기초생활) — 부모로 결정 C3 트리거'
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'national-low-income-diaper-formula' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'national-low-income-diaper-formula' AND ls.code = 'infant_0_36m'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;
INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'national-low-income-diaper-formula' AND ls.code = 'post_birth_60d'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'median_income_percent', 80, TRUE,
  0, 24,
  'basic_livelihood|near_poverty|single_parent|disabled|multi_child / 소득: 기초생활보장·차상위·한부모 / 기준중위소득 80% 이하 장애인·다자녀(2인 이상) (2026-07-01부터 100% 이하로 확대)', '기초생활보장·차상위·한부모 / 기준중위소득 80% 이하 장애인·다자녀(2인 이상) (2026-07-01부터 100% 이하로 확대)'
FROM policy p WHERE p.canonical_slug = 'national-low-income-diaper-formula'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);

INSERT INTO policy_household_type (policy_id, household_type_id, requirement_type)
SELECT p.id, ht.id, 'required'
FROM policy p, household_type ht
WHERE p.canonical_slug = 'national-low-income-diaper-formula' AND ht.code = 'multi_child'
ON CONFLICT (policy_id, household_type_id) DO NOTHING;
INSERT INTO policy_household_type (policy_id, household_type_id, requirement_type)
SELECT p.id, ht.id, 'required'
FROM policy p, household_type ht
WHERE p.canonical_slug = 'national-low-income-diaper-formula' AND ht.code = 'single_parent'
ON CONFLICT (policy_id, household_type_id) DO NOTHING;
INSERT INTO policy_household_type (policy_id, household_type_id, requirement_type)
SELECT p.id, ht.id, 'required'
FROM policy p, household_type ht
WHERE p.canonical_slug = 'national-low-income-diaper-formula' AND ht.code = 'disabled'
ON CONFLICT (policy_id, household_type_id) DO NOTHING;
INSERT INTO policy_household_type (policy_id, household_type_id, requirement_type)
SELECT p.id, ht.id, 'required'
FROM policy p, household_type ht
WHERE p.canonical_slug = 'national-low-income-diaper-formula' AND ht.code = 'basic_livelihood'
ON CONFLICT (policy_id, household_type_id) DO NOTHING;
INSERT INTO policy_household_type (policy_id, household_type_id, requirement_type)
SELECT p.id, ht.id, 'required'
FROM policy p, household_type ht
WHERE p.canonical_slug = 'national-low-income-diaper-formula' AND ht.code = 'near_poverty'
ON CONFLICT (policy_id, household_type_id) DO NOTHING;

INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'api_central_welfare', 'https://www.bokjiro.go.kr/ssis-tbu/twataa/wlfareInfo/moveTWAT52011M.do?wlfareInfoId=WLF00000092'
FROM policy p WHERE p.canonical_slug = 'national-low-income-diaper-formula'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #77 첫만남이용권
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'national-first-meeting-voucher', '첫만남이용권', '출생 아동에게 200만원 이상의 첫만남 이용권을 지급하여 생애초기 아동양육에 따른 경제적 부담을 경감합니다.', '첫째아 200만원, 둘째아 이상 300만원 (국민행복카드 바우처 포인트로 일시 지급)', '보건복지부 출산정책과',
  (SELECT id FROM category WHERE code = 'voucher'), 'one_time',
  2000000, 3000000, '첫째아 200만원, 둘째아 이상 300만원 (국민행복카드 바우처 포인트로 일시 지급)', NULL,
  '읍면동 행정복지센터 방문|복지로 온라인|정부24 온라인|행복출산 원스톱', ARRAY['online', 'visit'],
  '출생 후 1년 안에 신청. 바우처는 출생 후 2년까지 사용 가능, 미사용 시 소멸', 365, 'birth',
  '신분증, 국민행복카드 (없으면 카드사 신규 발급)', 'https://www.bokjiro.go.kr/ssis-tbu/twataa/wlfareInfo/moveTWAT52011M.do?wlfareInfoId=WLF00004656',
  'high', 'verified', 'active',
  '[현민] 행복출산 원스톱으로 출생신고 시 함께 신청 가능
[이호] 2024-01-01 이후 출생아부터 둘째 이상 300만원 확대 적용. mohw.go.kr 임신·출산 지원 페이지 최종수정 2025-03-21. 2026년 동일 금액 유지'
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'national-first-meeting-voucher' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'national-first-meeting-voucher' AND ls.code = 'post_birth_60d'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'none', NULL, FALSE,
  0, 24,
  '출생아로서 출생신고되어 정상적으로 주민등록번호를 부여받은 아동(2024년 이후 출생아로서 주민등록상 생년월일로부터 2년이 초과되지 않는 출생아)을 대상으로 합니다.', NULL
FROM policy p WHERE p.canonical_slug = 'national-first-meeting-voucher'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'api_central_welfare', 'https://www.bokjiro.go.kr/ssis-tbu/twataa/wlfareInfo/moveTWAT52011M.do?wlfareInfoId=WLF00004656'
FROM policy p WHERE p.canonical_slug = 'national-first-meeting-voucher'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #78 12세 이하 어린이 국가예방접종사업
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'national-child-vaccination', '12세 이하 어린이 국가예방접종사업', '국가가 예방접종비용을 부담하여 예방접종 접근성 제고 및 감염병 퇴치기반 강화와 가계부담 경감에 기여', '18종 백신 무료 접종 (BCG, B형간염, DTaP, IPV, Hib, PCV, 로타바이러스, MMR, 수두, 일본뇌염, A형간염, 인플루엔자 등). 지정 위탁의료기관·보건소에서 무료', '질병관리청 예방접종관리과',
  (SELECT id FROM category WHERE code = 'service'), 'one_time',
  NULL, NULL, '18종 백신 무료 접종 (BCG, B형간염, DTaP, IPV, Hib, PCV, 로타바이러스, MMR, 수두, 일본뇌염, A형간염, 인플루엔자 등). 지정 위탁의료기관·보건소에서 무료', NULL,
  '지정 위탁의료기관 방문|보건소 방문|예방접종도우미 앱', ARRAY['online', 'visit'],
  '백신마다 적정 시기 다름 — 예방접종도우미 앱·홈페이지에서 일정 확인', NULL, 'none',
  '아기수첩, 건강보험증', 'https://nip.kdca.go.kr/irhp/infm/goVcntInfo.do?menuLv=1&menuCd=131',
  'high', 'needs_review', 'active',
  '[이호] 2026년 새로 추가·확대된 백신 항목 별도 확인 필요'
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'national-child-vaccination' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'national-child-vaccination' AND ls.code = 'infant_0_36m'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;
INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'national-child-vaccination' AND ls.code = 'post_birth_60d'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'none', NULL, FALSE,
  0, 156,
  '- 12세 이하 어린이(2013. 1. 1. 이후 출생자, 2026년 기준)
- BCG(피내용): 5세 미만(생후 59개월 이하)까지 지원 * 단, 3개월 이상 영유아는 TST 결과 음성인 경우 지원
- Hib(b형헤모필루스인플루엔자), PCV(폐렴구균 단백결합): 5세 미만(생후 59개월 이하) * 단, Hib 및 폐렴구균 감염 고위험군 소아는 5세 이상에게도 지원
- Rota: 생후 8개월 이전 영아
※ DTaP, IPV, Hib, PCV, IJEV, Ro…', NULL
FROM policy p WHERE p.canonical_slug = 'national-child-vaccination'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'manual', 'https://nip.kdca.go.kr/irhp/infm/goVcntInfo.do?menuLv=1&menuCd=131'
FROM policy p WHERE p.canonical_slug = 'national-child-vaccination'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #79 산모신생아 건강관리 지원사업
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'national-postpartum-care-service', '산모신생아 건강관리 지원사업', '서울시 모든 출산가정에 산모신생아 건강관리사를 파견하여 산모의 산후 회복과 신생아 양육을 지원하고 출산가정의 경제적 부담 경감', '출산가정에 산후도우미를 파견. 태아 유형(단태아/쌍태아/삼태아 이상)·출산순위·서비스 기간(단축/표준/연장)에 따라 차등 지원. 본인부담금은 소득구간별 차등', '보건복지부 / 사회서비스원',
  (SELECT id FROM category WHERE code = 'service'), 'one_time',
  NULL, NULL, '출산가정에 산후도우미를 파견. 태아 유형(단태아/쌍태아/삼태아 이상)·출산순위·서비스 기간(단축/표준/연장)에 따라 차등 지원. 본인부담금은 소득구간별 차등', NULL,
  '관할 보건소 방문|복지로 online.bokjiro.go.kr 온라인', ARRAY['online', 'visit'],
  '출산 후 30일 안에 신청해야 함', NULL, 'none',
  '건강보험증, 산모수첩 또는 출생증명서, 신분증', 'https://www.bokjiro.go.kr/ssis-tbu/twataa/wlfareInfo/moveTWAT52011M.do?wlfareInfoId=WLF00001188',
  'medium', 'needs_review', 'active',
  '[이호] 사회서비스 전자바우처(socialservice.or.kr) 시스템으로 운영. 단축/표준/연장 + 단태아/쌍태아 매트릭스'
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'national-postpartum-care-service' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'national-postpartum-care-service' AND ls.code = 'post_birth_60d'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;
INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'national-postpartum-care-service' AND ls.code = 'pregnancy'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'median_income_percent', 150, FALSE,
  0, 2,
  '서울시 모든 출산가정', '기준중위소득 150% 이하 우선 (시도별 예외 확장 있음)'
FROM policy p WHERE p.canonical_slug = 'national-postpartum-care-service'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'api_central_welfare', 'https://www.bokjiro.go.kr/ssis-tbu/twataa/wlfareInfo/moveTWAT52011M.do?wlfareInfoId=WLF00001188'
FROM policy p WHERE p.canonical_slug = 'national-postpartum-care-service'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #80 아이돌봄서비스
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'national-childcare-service', '아이돌봄서비스', '맞벌이를 하거나 갑자기 아이를 돌볼 수 없는 일이 생겼을 때 육아 도우미가 방문하여 12세 이하 자녀의 양육을 도와줍니다.', '시간제 기본형 시간당 12,790원, 시간제 종합형 16,620원. 소득에 따라 최대 90% 정부지원(가형 75%이하·나형 120%이하·다형 200%이하·라형 250%이하). 2026년 4인가구 기준중위소득 약 649만원', '여성가족부 / 한국건강가정진흥원',
  (SELECT id FROM category WHERE code = 'service'), 'per_visit',
  12790, 6490000, '시간제 기본형 시간당 12,790원, 시간제 종합형 16,620원. 소득에 따라 최대 90% 정부지원(가형 75%이하·나형 120%이하·다형 200%이하·라형 250%이하). 2026년 4인가구 기준중위소득 약 649만원', NULL,
  '아이돌봄서비스 idolbom.go.kr 온라인|복지로 온라인|읍면동 행정복지센터', ARRAY['online'],
  '필요할 때 신청 — 자격 결정 후 이용 (수일~수주 소요)', NULL, 'none',
  '신분증, 가족관계증명서, 소득 증빙(건강보험료 납입 확인서 등)', 'https://www.mogef.go.kr/nw/ntc/nw_ntc_s001d.do?mid=news400&bbtSn=710732',
  'high', 'needs_review', 'active',
  '[현민] 중위소득 250%는 의외로 넓은 범위 - 신청 자격 있을 가능성 높음
[이호] 2026 신규: ①소득기준 200%→250% 확대 ②야간돌봄(22시 이후) 50% 할증분도 정부지원 ③시간당 단가 인상'
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'national-childcare-service' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'national-childcare-service' AND ls.code = 'infant_0_36m'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;
INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'national-childcare-service' AND ls.code = 'post_birth_60d'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'median_income_percent', 250, FALSE,
  3, 144,
  '- 아동 연령 기준, 부모의 취업 등 양육 공백, 자녀양육 정부지원 중복금지 기준, 가구 소득기준을 모두 충족한 경우 정부 지원 ○ 아동 연령 기준
- 영아종일제 : 생후 3개월 ~ 36개월 이하
- 시간제(종합형 포함) : 생후 3개월 이상 ~ 12세 이하 ○ 양육 공백 기준
- 한부모가정(한부모로서 취업을 하였거나, 비취업인 경우 장애인 또는 다자녀를 양육하는 경우)
- 장애부모 가정(가정에서 아동을 양육하는 부 또는 모가 ''장애인복지법 제2조''의 규정에…', '기준중위소득 250% 이하 정부지원 (2026 확대)'
FROM policy p WHERE p.canonical_slug = 'national-childcare-service'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);

INSERT INTO policy_household_type (policy_id, household_type_id, requirement_type)
SELECT p.id, ht.id, 'required'
FROM policy p, household_type ht
WHERE p.canonical_slug = 'national-childcare-service' AND ht.code = 'multi_child'
ON CONFLICT (policy_id, household_type_id) DO NOTHING;
INSERT INTO policy_household_type (policy_id, household_type_id, requirement_type)
SELECT p.id, ht.id, 'required'
FROM policy p, household_type ht
WHERE p.canonical_slug = 'national-childcare-service' AND ht.code = 'single_parent'
ON CONFLICT (policy_id, household_type_id) DO NOTHING;
INSERT INTO policy_household_type (policy_id, household_type_id, requirement_type)
SELECT p.id, ht.id, 'required'
FROM policy p, household_type ht
WHERE p.canonical_slug = 'national-childcare-service' AND ht.code = 'disabled'
ON CONFLICT (policy_id, household_type_id) DO NOTHING;

INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'manual', 'https://www.mogef.go.kr/nw/ntc/nw_ntc_s001d.do?mid=news400&bbtSn=710732'
FROM policy p WHERE p.canonical_slug = 'national-childcare-service'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #81 영유아 건강검진
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'national-infant-health-checkup', '영유아 건강검진', NULL, '생후 14일부터 만 6세까지 총 8회 일반검진 + 4회 구강검진 무료. 검진비 전액 건보 부담', '국민건강보험공단 / 보건복지부',
  (SELECT id FROM category WHERE code = 'service'), 'one_time',
  NULL, NULL, '생후 14일부터 만 6세까지 총 8회 일반검진 + 4회 구강검진 무료. 검진비 전액 건보 부담', NULL,
  'The건강보험 앱|공단 홈페이지 nhis.or.kr|지정 검진기관 직접 예약', ARRAY['online'],
  '정해진 시기 안에 받지 않으면 다음 차수로 넘어감 — 안내문 도착 시 빠르게 예약', NULL, 'none',
  '건강보험증, 문진표', 'https://www.nhis.or.kr/nhis/healthin/retrieveInfntExmdDtInq.do',
  'high', 'verified', 'active',
  '[현민] 시기 놓치면 자비 부담 - 안내문 챙기기
[이호] 구강검진은 18~29개월, 42~53개월, 54~65개월, 66~71개월 차수에 함께 진행'
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'national-infant-health-checkup' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'national-infant-health-checkup' AND ls.code = 'infant_0_36m'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;
INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'national-infant-health-checkup' AND ls.code = 'post_birth_60d'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'none', NULL, FALSE,
  0, 71,
  '영유아', NULL
FROM policy p WHERE p.canonical_slug = 'national-infant-health-checkup'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'manual', 'https://www.nhis.or.kr/nhis/healthin/retrieveInfntExmdDtInq.do'
FROM policy p WHERE p.canonical_slug = 'national-infant-health-checkup'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #82 임신 사전건강관리 지원사업
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'national-preconception-health-check', '임신 사전건강관리 지원사업', '임신 및 출산에 장애가 될 수 있는 건강위험요인의 조기 발견 기회를 제공하고, 임신전 건강관리를 위한 의료.보건학적 지원을 통해 건강한 임신 출산 환경을 조성합니다.', '여성(난소기능검사 AMH, 부인과 초음파) 최대 13만원 / 남성(정액검사) 최대 5만원. 주기별 1회씩 평생 최대 3회', '보건복지부 출산정책과 / 시군구 보건소',
  (SELECT id FROM category WHERE code = 'service'), 'one_time',
  50000, 130000, '여성(난소기능검사 AMH, 부인과 초음파) 최대 13만원 / 남성(정액검사) 최대 5만원. 주기별 1회씩 평생 최대 3회', NULL,
  'e보건소 공공보건포털 온라인|관할 보건소 방문', ARRAY['online', 'visit'],
  '임신 준비 단계에서 언제든 신청 가능 (주기당 1회)', NULL, 'none',
  '신분증, 검사 청구서, 검사기관 영수증', 'https://www.e-health.go.kr/gh/caSrvcGud/selectMdclSupGudInfo.do?heBiz=PG00003&menuId=200097',
  'high', 'needs_review', 'active',
  '[이호] 2025년부터 미혼 남녀도 대상 포함 (보건복지부 보도자료)'
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'national-preconception-health-check' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'national-preconception-health-check' AND ls.code = 'pregnancy_prep'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'none', NULL, FALSE,
  NULL, NULL,
  '주민등록 주소지 기준 관할 보건소에 신청하는 모든 20~49세 남녀 중 가임력 검사 희망자', 'none (결혼·자녀 여부 무관)'
FROM policy p WHERE p.canonical_slug = 'national-preconception-health-check'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'manual', 'https://www.e-health.go.kr/gh/caSrvcGud/selectMdclSupGudInfo.do?heBiz=PG00003&menuId=200097'
FROM policy p WHERE p.canonical_slug = 'national-preconception-health-check'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #83 국민연금 출산크레딧 확대 (첫째아부터 12개월)
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'national-pension-birth-credit', '국민연금 출산크레딧 확대 (첫째아부터 12개월)', NULL, '국민연금 가입기간 인정 — 첫째아 12개월 (기존 둘째아부터 → 첫째아부터 인정으로 확대)', '보건복지부 연금정책국',
  (SELECT id FROM category WHERE code = 'tax_benefit'), 'one_time',
  NULL, NULL, '국민연금 가입기간 인정 — 첫째아 12개월 (기존 둘째아부터 → 첫째아부터 인정으로 확대)', NULL,
  '국민연금공단 방문|온라인', ARRAY['online', 'visit'],
  NULL, NULL, 'none',
  '가족관계증명서, 자녀 출생증명서', 'https://www.korea.kr/news/policyNewsView.do?newsId=148956615',
  'medium', 'needs_review', 'active',
  '[이호] 2026 시행 (정책브리핑 명시). 기존 둘째아부터 12개월 → 첫째아부터 12개월로 인정 확대. 부모로 서비스의 단계 매칭은 신중 — 즉각 현금 혜택이 아닌 노후 수령액 가산이므로 별도 트랙 검토 필요.'
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'national-pension-birth-credit' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'national-pension-birth-credit' AND ls.code = 'infant_0_36m'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;
INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'national-pension-birth-credit' AND ls.code = 'post_birth_60d'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'none', NULL, FALSE,
  0, NULL,
  NULL, NULL
FROM policy p WHERE p.canonical_slug = 'national-pension-birth-credit'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'manual', 'https://www.korea.kr/news/policyNewsView.do?newsId=148956615'
FROM policy p WHERE p.canonical_slug = 'national-pension-birth-credit'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #84 자녀 세액공제 (자녀·출산입양)
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'national-child-tax-deduction', '자녀 세액공제 (자녀·출산입양)', NULL, '자녀 세액공제: 8세 이상 자녀 1명 25만원, 2명 55만원, 3명 95만원, 4명 135만원/연. 출산·입양 공제: 첫째 30만원, 둘째 50만원, 셋째 이상 70만원', '국세청',
  (SELECT id FROM category WHERE code = 'tax_benefit'), 'yearly',
  250000, 1350000, '자녀 세액공제: 8세 이상 자녀 1명 25만원, 2명 55만원, 3명 95만원, 4명 135만원/연. 출산·입양 공제: 첫째 30만원, 둘째 50만원, 셋째 이상 70만원', '[{"birth_order": 1, "amount": 300000}, {"birth_order": 2, "amount": 500000}, {"birth_order": "3+", "amount": 700000}]'::jsonb,
  '연말정산(회사)|홈택스 온라인|세무서', ARRAY['online'],
  '연말정산 또는 종합소득세 신고 시 자동 반영', NULL, 'none',
  '자녀 가족관계증명서, 출산·입양 신고서', 'https://www.nts.go.kr/nts/cm/cntnts/cntntsView.do?cntntsId=7875&mi=6596',
  'medium', 'needs_review', 'active',
  '[이호] 8세 미만은 자녀세액공제 대상 아님(아동수당과 중복방지 목적). 출산·입양 공제는 출생연도에 한해 적용'
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'national-child-tax-deduction' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'national-child-tax-deduction' AND ls.code = 'infant_0_36m'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;
INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'national-child-tax-deduction' AND ls.code = 'post_birth_60d'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'none', NULL, FALSE,
  0, 240,
  '소득: 기본공제대상자(연소득 100만원 이하)', '기본공제대상자(연소득 100만원 이하)'
FROM policy p WHERE p.canonical_slug = 'national-child-tax-deduction'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'manual', 'https://www.nts.go.kr/nts/cm/cntnts/cntntsView.do?cntntsId=7875&mi=6596'
FROM policy p WHERE p.canonical_slug = 'national-child-tax-deduction'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #85 2세미만 영유아 입원진료비 본인부담금 면제
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'national-infant-hospital-free', '2세미만 영유아 입원진료비 본인부담금 면제', '생애 초기부터 촘촘한 신체 건강 관리 체계 강화', '- 입원 진료 시 진료비 중 본인 부담금 면제
※ 식대, 선별 급여 등은 제외', '보건복지상담센터 / 129',
  (SELECT id FROM category WHERE code = 'childcare'), 'one_time',
  NULL, NULL, '- 입원 진료 시 진료비 중 본인 부담금 면제
※ 식대, 선별 급여 등은 제외', NULL,
  '해당 서비스는 신청없이 자격대상자에게 자동적으로 제공됩니다.', NULL,
  '상시신청', NULL, 'none',
  NULL, 'https://www.gov.kr/portal/rcvfvrSvc/dtlEx/135200005050',
  'unrated', 'needs_review', 'active',
  NULL
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'national-infant-hospital-free' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'national-infant-hospital-free' AND ls.code = 'infant_0_36m'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'none', NULL, FALSE,
  NULL, NULL,
  '2세 미만 영유아', NULL
FROM policy p WHERE p.canonical_slug = 'national-infant-hospital-free'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'api_gov24', 'https://www.gov.kr/portal/rcvfvrSvc/dtlEx/135200005050'
FROM policy p WHERE p.canonical_slug = 'national-infant-hospital-free'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #86 그 밖의 연장형 보육료 등 지원
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'national-extended-daycare-fee', '그 밖의 연장형 보육료 등 지원', '그 밖의 연장형 어린이집(야간연장, 휴일, 24시 등)을 이용하는 영유아에 대하여 보육료를 지원함으로써 부모의 자녀양육 부담을 덜고 원활한 경제활동을 돕습니다.', '- 야간 연장 보육료
- 야간연장 보육료는 매월 지원한도액 : 60시간(''26.3~ 한도없이 지원)
- 보육시간 : 기준 시간 초과(19:30~24:00), 토요일(15:30~24:00)
- 보육료(연령에 관계없이 동일)
- 시간당 일반 아동 : 4,000원
- 장애 아동 : 5,000원
※ 아침저녁 급식비는 기타 필요경비 지침에 따라 수납 가능 ○ 야간12시간 보육료
- 보육시간 : 19:30~익일 07:30
- 주간에 어린이집을 이용하지 않는 아동이 야간에 이용하는 경우에만 야간 보육료 지원 가능함
- 지원 단가
- 만 0세 : 584천원
- 만 1세 : 515…', '교육부상담센터: 02-6222-6060',
  (SELECT id FROM category WHERE code = 'childcare'), 'monthly',
  4000, 5000, '- 야간 연장 보육료
- 야간연장 보육료는 매월 지원한도액 : 60시간(''26.3~ 한도없이 지원)
- 보육시간 : 기준 시간 초과(19:30~24:00), 토요일(15:30~24:00)
- 보육료(연령에 관계없이 동일)
- 시간당 일반 아동 : 4,000원
- 장애 아동 : 5,000원
※ 아침저녁 급식비는 기타 필요경비 지침에 따라 수납 가능 ○ 야간12시간 보육료
- 보육시간 : 19:30~익일 07:30
- 주간에 어린이집을 이용하지 않는 아동이 야간에 이용하는 경우에만 야간 보육료 지원 가능함
- 지원 단가
- 만 0세 : 584천원
- 만 1세 : 515…', NULL,
  '그밖의 연장형 보육 최초 이용 전까지 신청서를 해당 어린이집에 제출', NULL,
  '접수기관 별 상이', NULL, 'none',
  NULL, 'https://www.bokjiro.go.kr/ssis-tbu/twataa/wlfareInfo/moveTWAT52011M.do?wlfareInfoId=WLF00001147&wlfareInfoReldBztpCd=01',
  'unrated', 'needs_review', 'active',
  NULL
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'national-extended-daycare-fee' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'national-extended-daycare-fee' AND ls.code = 'child_3y_plus'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;
INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'national-extended-daycare-fee' AND ls.code = 'infant_0_36m'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'recipient_required', NULL, TRUE,
  36, 144,
  '- 그 밖의 연장형 보육료 지원 대상은 만 0세～2세 연장보육료, 만 3~5세 누리과정 보육료, 다문화 보육료 및 장애아 보육료(취학 전) 지원 아동을 원칙으로 함.
- 다만, 만 12세 이하 취학아동 중 법정 저소득층과 장애아동(복지카드소지자)에 대해서는 야간 연장 보육료에 한하여 지원 가능 ○ 야간12시간 보육료, 24시간 보육료는 24시간 지정 어린이집을 이용하는 경우만 지원 가능 ○ 기타 기준 : 원장 겸 교사의 자녀에 대해서는 지원하지 않음', '수급자/차상위/저소득'
FROM policy p WHERE p.canonical_slug = 'national-extended-daycare-fee'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);

INSERT INTO policy_household_type (policy_id, household_type_id, requirement_type)
SELECT p.id, ht.id, 'required'
FROM policy p, household_type ht
WHERE p.canonical_slug = 'national-extended-daycare-fee' AND ht.code = 'multicultural'
ON CONFLICT (policy_id, household_type_id) DO NOTHING;
INSERT INTO policy_household_type (policy_id, household_type_id, requirement_type)
SELECT p.id, ht.id, 'required'
FROM policy p, household_type ht
WHERE p.canonical_slug = 'national-extended-daycare-fee' AND ht.code = 'disabled'
ON CONFLICT (policy_id, household_type_id) DO NOTHING;

INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'api_central_welfare', 'https://www.bokjiro.go.kr/ssis-tbu/twataa/wlfareInfo/moveTWAT52011M.do?wlfareInfoId=WLF00001147&wlfareInfoReldBztpCd=01'
FROM policy p WHERE p.canonical_slug = 'national-extended-daycare-fee'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #87 민간어린이집 실내환경 개선 지원(국산목재)
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'national-daycare-wood-improvement', '민간어린이집 실내환경 개선 지원(국산목재)', '국산목재를 이용한 어린이 이용시설 실내환경 개선을 통해 영유아부터 목재를 만지고 느껴보며 알게 된 사실이 생활 속 실천으로 확산되는 전국민 탄소중립 참여기반 확립', '- 어린이집 실내환경을 국산목재로 개선
- 우리나라에 심고 가꾸어 수확한 나무로 만든 국산목재 제품만 사용 가능', '산림청 목재산업과: 042-481-4203',
  (SELECT id FROM category WHERE code = 'childcare'), 'one_time',
  NULL, NULL, '- 어린이집 실내환경을 국산목재로 개선
- 우리나라에 심고 가꾸어 수확한 나무로 만든 국산목재 제품만 사용 가능', NULL,
  '어린이 이용시설 목조화사업 공모계획''에 명시된 사업신청서 및 첨부서류를 작성하여 시·군·구청에 제출', NULL,
  '접수기관 별 상이', NULL, 'none',
  NULL, 'https://www.gov.kr/portal/rcvfvrSvc/dtlEx/140000000222',
  'unrated', 'needs_review', 'active',
  NULL
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'national-daycare-wood-improvement' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'national-daycare-wood-improvement' AND ls.code = 'infant_0_36m'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'none', NULL, FALSE,
  NULL, NULL,
  '「영유아보육법」제10조의 어린이집', NULL
FROM policy p WHERE p.canonical_slug = 'national-daycare-wood-improvement'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'api_gov24', 'https://www.gov.kr/portal/rcvfvrSvc/dtlEx/140000000222'
FROM policy p WHERE p.canonical_slug = 'national-daycare-wood-improvement'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #88 보육교직원 인건비 지원
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'national-daycare-staff-salary', '보육교직원 인건비 지원', '국공립, 사회복지법인, 법인 단체 등 어린이집 및 취약보육서비스를 제공하는 보육교직원 인건비 지원을 통해 안정적 보육서비스를 제공합니다.', '어린이집 원장·보육교사 등 보육교직원 인건비를 월 단위로 지원하여 안정적인 보육서비스 제공을 지원', '교육부 상담센터 / 02-6222-6060',
  (SELECT id FROM category WHERE code = 'childcare'), 'monthly',
  NULL, NULL, '어린이집 원장·보육교사 등 보육교직원 인건비를 월 단위로 지원하여 안정적인 보육서비스 제공을 지원', NULL,
  '어린이집 또는 지자체가 보육통합정보시스템/관할 시군구 행정 절차에 따라 신청·정산. 세부 절차는 관할 지자체 확인', NULL,
  '관할 지자체 사업 일정에 따름', NULL, 'none',
  NULL, 'https://www.bokjiro.go.kr/ssis-tbu/twataa/wlfareInfo/moveTWAT52011M.do?wlfareInfoId=WLF00000842&wlfareInfoReldBztpCd=01',
  'unrated', 'needs_review', 'active',
  NULL
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'national-daycare-staff-salary' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'national-daycare-staff-salary' AND ls.code = 'infant_0_36m'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'none', NULL, FALSE,
  NULL, NULL,
  '국공립, 사회복지법인, 법인·단체 등 정부 인건비 지원 어린이집과 취약보육서비스 제공 어린이집의 보육교직원', NULL
FROM policy p WHERE p.canonical_slug = 'national-daycare-staff-salary'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'api_central_welfare', 'https://www.bokjiro.go.kr/ssis-tbu/twataa/wlfareInfo/moveTWAT52011M.do?wlfareInfoId=WLF00000842&wlfareInfoReldBztpCd=01'
FROM policy p WHERE p.canonical_slug = 'national-daycare-staff-salary'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #89 시간제보육 지원
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'national-hourly-daycare', '시간제보육 지원', '가정 양육 시에도 필요한 때에 필요한 만큼 이용할 수 있는 보육 서비스를 제공하여 자녀 양육에 대한 부담을 경감하고 부모의 보육 서비스 선택권을 보장합니다.', '부모급여(현금) 또는 가정양육수당 수급 영아* 대상 시간당 보육료 5천원 중 3천원 지원(최대 월 60시간까지 지원) / 그 외 대상자는 시간당 5천원 전액 부담 * (독립반) 6개월~36개월 미만 영아, (통합반) 6개월~2세반(2세반 출생일 기준 ''23.1.1.~23.12.31.) 영아', '시간제보육 대표번호 / 1661-9361',
  (SELECT id FROM category WHERE code = 'childcare'), 'monthly',
  NULL, NULL, '부모급여(현금) 또는 가정양육수당 수급 영아* 대상 시간당 보육료 5천원 중 3천원 지원(최대 월 60시간까지 지원) / 그 외 대상자는 시간당 5천원 전액 부담 * (독립반) 6개월~36개월 미만 영아, (통합반) 6개월~2세반(2세반 출생일 기준 ''23.1.1.~23.12.31.) 영아', NULL,
  '(회원가입 및 아동등록) 임신육아종합포털 아이사랑(pc/모바일)에서 회원가입 또는 육아종합지원센터 및 어린이집에서 아동 등록 ㅇ (이용 예약) 임신육아종합포털 아이사랑(pc/모바일) 예약 또는 시간제보육 대표번호(1661-9361) 전화 예약', ARRAY['phone'],
  '상시신청', NULL, 'none',
  NULL, 'https://www.bokjiro.go.kr/ssis-tbu/twataa/wlfareInfo/moveTWAT52011M.do?wlfareInfoId=WLF00000037&wlfareInfoReldBztpCd=01',
  'unrated', 'needs_review', 'active',
  NULL
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'national-hourly-daycare' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'national-hourly-daycare' AND ls.code = 'child_3y_plus'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;
INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'national-hourly-daycare' AND ls.code = 'infant_0_36m'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'none', NULL, FALSE,
  NULL, 35,
  '- 어린이집, 유치원을 이용하지 않고 부모급여(현금) 또는 양육수당 수급 중인 영아
- 독립반 : 6~36개월 미만 영아, 통합반 : 6개월~2세반* 영아 * 2세반 출생일 기준 ''23.1.1.~23.12.31.', NULL
FROM policy p WHERE p.canonical_slug = 'national-hourly-daycare'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'api_central_welfare', 'https://www.bokjiro.go.kr/ssis-tbu/twataa/wlfareInfo/moveTWAT52011M.do?wlfareInfoId=WLF00000037&wlfareInfoReldBztpCd=01'
FROM policy p WHERE p.canonical_slug = 'national-hourly-daycare'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #90 아동 공동생활 가정 운영 지원
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'national-child-group-home', '아동 공동생활 가정 운영 지원', '보호가 필요한 아동에게 가정과 같은 주거여건과 보호, 양육 등 서비스를 제공하는 것을 목적으로 하는 아동 공동생활 가정의 운영 지원', '인건비: 32,125천원/인, 연(年) ○ 운영비 : 470천원/개소, 월(月) ○ 연장근로수당 : 사회복지생활시설 종사자 지원 기준 따름', '보건복지상담센터 / 129',
  (SELECT id FROM category WHERE code = 'childcare'), 'monthly',
  NULL, NULL, '인건비: 32,125천원/인, 연(年) ○ 운영비 : 470천원/개소, 월(月) ○ 연장근로수당 : 사회복지생활시설 종사자 지원 기준 따름', NULL,
  '설치 신고서 등 구비서류를 시군구의 장에게 제출(아동복지법 시행규칙 제23조 참조)', NULL,
  '접수기관 별 상이', NULL, 'none',
  NULL, 'https://www.gov.kr/portal/rcvfvrSvc/dtlEx/135200000010',
  'unrated', 'needs_review', 'active',
  NULL
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'national-child-group-home' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'national-child-group-home' AND ls.code = 'child_3y_plus'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'none', NULL, FALSE,
  NULL, 3,
  '- 기준 : 3인 이상 전액, 1~2인 전액(발생일로부터 3개월까지) 1/2(4개월째부터) ○
- 대상 : 공동생활가정(그룹홈) 시설장 및 종사자', NULL
FROM policy p WHERE p.canonical_slug = 'national-child-group-home'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'api_gov24', 'https://www.gov.kr/portal/rcvfvrSvc/dtlEx/135200000010'
FROM policy p WHERE p.canonical_slug = 'national-child-group-home'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #91 어린이 급식관리 지원
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'national-child-meal-management', '어린이 급식관리 지원', '어린이를 대상으로 단체급식을 제공하는 급식소 중 영양사 고용의무가 없는 급식시설에 체계적인 위생 및 영양관리를 함으로써 어린이 건강증진 도모', '- 어린이 급식소 관리 체크리스트를 활용한 순회 방문지도
- 위생, 안전 관리
- 영양관리 ○ 대상별 교육지원 : 어린이, 조리원, 원장 및 교사, 학부모 등 ○ 정보제공
- 어린이 급식용 식단 개발 및 지원
- 표준 레시피 개발 및 보급
- 가정통신문 개발 및 보급
- 정보 잡지 개발 및 보급', '해당지역 시군구청 / 0000000000',
  (SELECT id FROM category WHERE code = 'childcare'), 'one_time',
  NULL, NULL, '- 어린이 급식소 관리 체크리스트를 활용한 순회 방문지도
- 위생, 안전 관리
- 영양관리 ○ 대상별 교육지원 : 어린이, 조리원, 원장 및 교사, 학부모 등 ○ 정보제공
- 어린이 급식용 식단 개발 및 지원
- 표준 레시피 개발 및 보급
- 가정통신문 개발 및 보급
- 정보 잡지 개발 및 보급', NULL,
  '웹사이트, 방문, 우편, FAX, 이메일', ARRAY['visit'],
  '접수기관 별 상이', NULL, 'none',
  NULL, 'https://www.gov.kr/portal/rcvfvrSvc/dtlEx/SD0000003440',
  'unrated', 'needs_review', 'active',
  NULL
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'national-child-meal-management' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'national-child-meal-management' AND ls.code = 'infant_0_36m'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'none', NULL, FALSE,
  NULL, NULL,
  '어린이에게 단체급식을 제공하는 어린이 급식소', NULL
FROM policy p WHERE p.canonical_slug = 'national-child-meal-management'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'api_gov24', 'https://www.gov.kr/portal/rcvfvrSvc/dtlEx/SD0000003440'
FROM policy p WHERE p.canonical_slug = 'national-child-meal-management'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #92 영유아 보육시설 지방세 감면
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'national-daycare-tax-reduction', '영유아 보육시설 지방세 감면', '영유아보육 시설을 설치ㆍ운영하기 위하여 취득하는 부동산 취득세 등 지방세를 감면하여 보육 시설의 설치 운영을 지원', '「영유아보육법」에 따른 어린이집 및 「유아교육법」에 따른 유치원(이하 이 조에서 “유치원등”이라 한다)을 직접 사용하기 위하여 취득하는 부동산 및 「영유아보육법」 제10조제4호에 따른 직장어린이집을 법인ㆍ단체 또는 개인에게 위탁하여 운영하기 위하여 취득하는 부동산에 대해서는 취득세를 2027년 12월 31일까지 면제', '지방세 상담센터 / 1577-5700',
  (SELECT id FROM category WHERE code = 'childcare'), 'monthly',
  NULL, NULL, '「영유아보육법」에 따른 어린이집 및 「유아교육법」에 따른 유치원(이하 이 조에서 “유치원등”이라 한다)을 직접 사용하기 위하여 취득하는 부동산 및 「영유아보육법」 제10조제4호에 따른 직장어린이집을 법인ㆍ단체 또는 개인에게 위탁하여 운영하기 위하여 취득하는 부동산에 대해서는 취득세를 2027년 12월 31일까지 면제', NULL,
  '시군구청에 방문하여 신청', ARRAY['visit'],
  '접수기관 별 상이', NULL, 'none',
  NULL, 'https://www.gov.kr/portal/rcvfvrSvc/dtlEx/131200000010',
  'unrated', 'needs_review', 'active',
  NULL
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'national-daycare-tax-reduction' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'national-daycare-tax-reduction' AND ls.code = 'infant_0_36m'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'none', NULL, FALSE,
  NULL, NULL,
  '「영유아보육법」에 따른 어린이집 및 「유아교육법」에 따른 유치원 설치ㆍ운영하기 위하여 취득하는 부동산, 「영유아보육법」 제10조제4호에 따른 직장어린이집을 법인ㆍ단체 또는 개인에게 위탁하여 운영하기 위하여 취득하는 부동산', NULL
FROM policy p WHERE p.canonical_slug = 'national-daycare-tax-reduction'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'api_gov24', 'https://www.gov.kr/portal/rcvfvrSvc/dtlEx/131200000010'
FROM policy p WHERE p.canonical_slug = 'national-daycare-tax-reduction'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #93 유아교육비·보육료 추가지원
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'national-early-education-fee', '유아교육비·보육료 추가지원', '학부모 양육비 부담 경감을 위해 유아교육비·보육료 월 5만원 추가지원', '- (지원대상) 유아학비·누리보육료 지원 대상 유아
- 취학대상 아동이 취학을 유예하는 경우, 유예한 1년에 한하여 5세 유아 무상교육비·누리보육료 지원(취학유예 통지서 제출)
※ 취학유예(입학연기 포함) 아동에 대해서도 무상교육 기간은 3년을 초과할 수 없음
※ ｢주민등록법｣ 제6조 제1항 제3호에 따라 (재)등록된 재외국민 유아 포함 ○ (지원금액) 유아 1인당 월 50,000원', '교육부 민원상담센터: 02-6222-6060',
  (SELECT id FROM category WHERE code = 'childcare'), 'monthly',
  50000, 50000, '- (지원대상) 유아학비·누리보육료 지원 대상 유아
- 취학대상 아동이 취학을 유예하는 경우, 유예한 1년에 한하여 5세 유아 무상교육비·누리보육료 지원(취학유예 통지서 제출)
※ 취학유예(입학연기 포함) 아동에 대해서도 무상교육 기간은 3년을 초과할 수 없음
※ ｢주민등록법｣ 제6조 제1항 제3호에 따라 (재)등록된 재외국민 유아 포함 ○ (지원금액) 유아 1인당 월 50,000원', NULL,
  '유치원 : 유아 나이스 시스템 / e-유치원 시스템 ○ 어린이집 : 보육통합정보시스템', NULL,
  '기관별 신청기간에 신청', NULL, 'none',
  NULL, 'https://www.gov.kr/portal/rcvfvrSvc/dtlEx/134200005047',
  'unrated', 'needs_review', 'active',
  NULL
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'national-early-education-fee' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'national-early-education-fee' AND ls.code = 'child_3y_plus'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;
INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'national-early-education-fee' AND ls.code = 'infant_0_36m'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'none', NULL, FALSE,
  NULL, NULL,
  '- (지원대상) 유아학비·누리보육료 지원 대상 유아
- 취학대상 아동이 취학을 유예하는 경우, 유예한 1년에 한하여 5세 유아 무상교육비·누리보육료 지원(취학유예 통지서 제출)
※ 취학유예(입학연기 포함) 아동에 대해서도 무상교육 기간은 3년을 초과할 수 없음
※ ｢주민등록법｣ 제6조 제1항 제3호에 따라 (재)등록된 재외국민 유아 포함 ○ (지원금액) 유아 1인당 월 50,000원', NULL
FROM policy p WHERE p.canonical_slug = 'national-early-education-fee'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'api_gov24', 'https://www.gov.kr/portal/rcvfvrSvc/dtlEx/134200005047'
FROM policy p WHERE p.canonical_slug = 'national-early-education-fee'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #94 유아학비 지원(3~5세 누리과정 지원)
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'national-childcare-allowance', '유아학비 지원(3~5세 누리과정 지원)', '국공사립유치원에 재원하는 유아를 대상으로 보호자의 소득수준에 관계없이 전 계층에 유아학비를 지원하여 실질적 교육기회 보장을 지원합니다.', '- 3~5세에 대해 교육비를 지급합니다.
- 국공립 100,000원, 사립 280,000원 ○ 3~5세에 대해 방과후과정비를 지급합니다.
- 국공립 50,000원, 사립 70,000원 ○ 사립유치원을 다니는 법정저소득층 유아에게 저소득층 유아학비를 추가 지급합니다.
- 사립 200,000원', '- 교육부: 02-6222-6060
- 0079에듀콜 / 1544-0079-5-1',
  (SELECT id FROM category WHERE code = 'childcare'), 'one_time',
  50000, 280000, '- 3~5세에 대해 교육비를 지급합니다.
- 국공립 100,000원, 사립 280,000원 ○ 3~5세에 대해 방과후과정비를 지급합니다.
- 국공립 50,000원, 사립 70,000원 ○ 사립유치원을 다니는 법정저소득층 유아에게 저소득층 유아학비를 추가 지급합니다.
- 사립 200,000원', NULL,
  '- 유아의 보호자가 가까운 읍면동 주민센터 방문 또는 인터넷을 이용하여 온라인 신청 (복지로 http://www.bokjiro.go.kr) 이 가능합니다.
- 주의: 온라인 신청은 부모만 가능
※ 부모 이외의 보호자인 경우(자녀의 친권자 또는 후견인 보호자, 조부모, 사회복지시설장 등) 등 담당공무원의 확인이 필요한 경우는 온라인으로 신청하실수 없으므로 번거로우시더라도 읍면동 주민센터(주소지 시군구)에서 방문 신청하시기 바랍니다. ○ 신청 후 학부모 인증 신청…', ARRAY['online', 'visit'],
  '상시신청', NULL, 'none',
  NULL, 'https://www.bokjiro.go.kr/ssis-tbu/twataa/wlfareInfo/moveTWAT52011M.do?wlfareInfoId=WLF00000969&wlfareInfoReldBztpCd=01',
  'unrated', 'needs_review', 'active',
  NULL
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'national-childcare-allowance' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'national-childcare-allowance' AND ls.code = 'infant_0_36m'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'requires_review', NULL, FALSE,
  36, 60,
  '- 지원대상 : 국공립 및 사립유치원에 다니는 3~5세 유아
- ''23년 1~2월생으로 유치원 입학을 희망하여 3세반에 취원한 유아도 지원 대상
- 취학대상 아동(''19.1.1~12.31.출생)이 취학을 유예하는 경우, 유예한 1년에 한하여 5세 유아 무상교육비 지원(취학유예 통지서 제출)
※ 단, 지원기간은 3년을 초과할 수 없음. ○ 추가지원 : 저소득층 유아(유아학비 지원 대상 자격이 있고, 사립유치원에 다니는 법정저소득층(기초생활수급자, 차상위계층, 한…', '소득 조건 확인 필요'
FROM policy p WHERE p.canonical_slug = 'national-childcare-allowance'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);

INSERT INTO policy_household_type (policy_id, household_type_id, requirement_type)
SELECT p.id, ht.id, 'required'
FROM policy p, household_type ht
WHERE p.canonical_slug = 'national-childcare-allowance' AND ht.code = 'basic_livelihood'
ON CONFLICT (policy_id, household_type_id) DO NOTHING;
INSERT INTO policy_household_type (policy_id, household_type_id, requirement_type)
SELECT p.id, ht.id, 'required'
FROM policy p, household_type ht
WHERE p.canonical_slug = 'national-childcare-allowance' AND ht.code = 'near_poverty'
ON CONFLICT (policy_id, household_type_id) DO NOTHING;

INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'api_central_welfare', 'https://www.bokjiro.go.kr/ssis-tbu/twataa/wlfareInfo/moveTWAT52011M.do?wlfareInfoId=WLF00000969&wlfareInfoReldBztpCd=01'
FROM policy p WHERE p.canonical_slug = 'national-childcare-allowance'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #95 육아종합지원서비스 제공
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'national-home-childcare-allowance', '육아종합지원서비스 제공', '영유아와 부모를 위한 종합적인 육아종합서비스를 제공하는 육아종합지원센터 운영비를 지원합니다.', '부모상담, 부모교육, 보육교직원 교육, 장난감·도서 대여, 시간제보육 등 육아종합지원센터 운영 서비스 제공', '중앙육아종합지원센터 / 02-6901-0202',
  (SELECT id FROM category WHERE code = 'childcare'), 'one_time',
  NULL, NULL, '부모상담, 부모교육, 보육교직원 교육, 장난감·도서 대여, 시간제보육 등 육아종합지원센터 운영 서비스 제공', NULL,
  '지역 육아종합지원센터 홈페이지, 전화 또는 방문으로 프로그램별 신청', ARRAY['online', 'phone', 'visit'],
  '센터별 프로그램 일정에 따름', NULL, 'none',
  NULL, 'https://www.bokjiro.go.kr/ssis-tbu/twataa/wlfareInfo/moveTWAT52011M.do?wlfareInfoId=WLF00000030&wlfareInfoReldBztpCd=01',
  'unrated', 'needs_review', 'active',
  NULL
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'national-home-childcare-allowance' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'national-home-childcare-allowance' AND ls.code = 'infant_0_36m'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'none', NULL, FALSE,
  NULL, NULL,
  '영유아 자녀를 둔 부모, 어린이집, 보육교직원 등 육아종합지원센터 서비스를 이용하는 대상', NULL
FROM policy p WHERE p.canonical_slug = 'national-home-childcare-allowance'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'api_central_welfare', 'https://www.bokjiro.go.kr/ssis-tbu/twataa/wlfareInfo/moveTWAT52011M.do?wlfareInfoId=WLF00000030&wlfareInfoReldBztpCd=01'
FROM policy p WHERE p.canonical_slug = 'national-home-childcare-allowance'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #96 직장어린이집 설치 지원
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'national-parent-allowance', '직장어린이집 설치 지원', '근로자의 육아부담 완화와 여성의 경제활동 참여 촉진 및 직장어린이집 운영의 내실화를 도모합니다.', '- 직장어린이집 설치 지원 내용은 다음과 같습니다. 시설설치비 : 시설전환 소요비용의 60%~90% 지원
- 대규모기업 : 단독형(3억), 공동형(6억) / 우선지원대상기업 : 단독형(4억), 공동(10억~20억) 한도에서 지원- 단, 시설매입비는 우선지원대상기업만 40% 한도에서 지원 교재교구비 : 소요비용의 60%~90%
- 신규 : 대규모기업(5천만원), 우선지원대상기업(7천만원) / 교체비 : 3천만원 한도에서 지원 직장보육교사 등 인건비 지원 내용은 다음과 같습니다. 보육교사 및 보육시설의 장, 조리원 1인당 월 60만원(중소기업 월 138만원) 한도로 월평균…', '한국정보화진흥원 / 1588-2670',
  (SELECT id FROM category WHERE code = 'childcare'), 'monthly',
  600000, 1380000, '- 직장어린이집 설치 지원 내용은 다음과 같습니다. 시설설치비 : 시설전환 소요비용의 60%~90% 지원
- 대규모기업 : 단독형(3억), 공동형(6억) / 우선지원대상기업 : 단독형(4억), 공동(10억~20억) 한도에서 지원- 단, 시설매입비는 우선지원대상기업만 40% 한도에서 지원 교재교구비 : 소요비용의 60%~90%
- 신규 : 대규모기업(5천만원), 우선지원대상기업(7천만원) / 교체비 : 3천만원 한도에서 지원 직장보육교사 등 인건비 지원 내용은 다음과 같습니다. 보육교사 및 보육시설의 장, 조리원 1인당 월 60만원(중소기업 월 138만원) 한도로 월평균…', NULL,
  '사후관리기관목록: 담당 시/군/구청 또는 근로복지공단 직장보육지원센터(직장어린이집 설치 및 교재교구지원)에서 서비스 제공 이후 대상자의 상황 관리', NULL,
  '공모시(공모시기는 연중계획에 따름)', NULL, 'none',
  NULL, 'https://www.bokjiro.go.kr/ssis-tbu/twataa/wlfareInfo/moveTWAT52011M.do?wlfareInfoId=WLF00001163&wlfareInfoReldBztpCd=01',
  'unrated', 'needs_review', 'active',
  NULL
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'national-parent-allowance' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'national-parent-allowance' AND ls.code = 'child_3y_plus'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;
INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'national-parent-allowance' AND ls.code = 'infant_0_36m'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'none', NULL, FALSE,
  NULL, NULL,
  '직장 어린이집을 설치, 운영하는 고용보험 가입 사업주나 사업주 단체를지원합니다.', NULL
FROM policy p WHERE p.canonical_slug = 'national-parent-allowance'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'api_central_welfare', 'https://www.bokjiro.go.kr/ssis-tbu/twataa/wlfareInfo/moveTWAT52011M.do?wlfareInfoId=WLF00001163&wlfareInfoReldBztpCd=01'
FROM policy p WHERE p.canonical_slug = 'national-parent-allowance'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #97 경력단절 여성과학기술인 복귀 지원
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'national-infant-daycare-fee', '경력단절 여성과학기술인 복귀 지원', '임신, 출산, 육아, 가족 구성원 돌봄 등의 이유로 경력이 단절된 여성과학기술인에게는 재취업 기회를 제공하고, 연구기관에는 경력이 있는 여성인력의 채용을 지원', '- 지원내용
- 복귀 인력의 연구비 지원(정부 지원금 2천2백만 원 내외)
- 경력단절 여성과학기술인의 연구역량 강화 및 경력개발을 위한 교육 멘토링 ○ 지원 기간 : 최대 3년(12개월 단위로 연차평가 실시하여 계속지원 여부 평가)', '한국여성과학기술인육성재단: 02-6411-1010',
  (SELECT id FROM category WHERE code = 'service'), 'monthly',
  NULL, NULL, '- 지원내용
- 복귀 인력의 연구비 지원(정부 지원금 2천2백만 원 내외)
- 경력단절 여성과학기술인의 연구역량 강화 및 경력개발을 위한 교육 멘토링 ○ 지원 기간 : 최대 3년(12개월 단위로 연차평가 실시하여 계속지원 여부 평가)', NULL,
  '온라인 신청 ○ 신청 및 접수 → 신청자격 평가 → 서비스 실시', ARRAY['online'],
  '홈페이지(www.wbridge.or.kr) 참고', NULL, 'none',
  NULL, 'https://www.gov.kr/portal/rcvfvrSvc/dtlEx/PTR000052170',
  'unrated', 'needs_review', 'active',
  NULL
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'national-infant-daycare-fee' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'national-infant-daycare-fee' AND ls.code = 'child_3y_plus'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;
INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'national-infant-daycare-fee' AND ls.code = 'infant_0_36m'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;
INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'national-infant-daycare-fee' AND ls.code = 'post_birth_60d'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;
INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'national-infant-daycare-fee' AND ls.code = 'pregnancy'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'none', NULL, FALSE,
  6, NULL,
  '- 개인
- 과학기술 분야에 취업하였으나, 임신, 출산, 육아, 가족 구성원 돌봄 등의 이유로 경력이 단절된 여성과학기술인
- 학위 취득 후, 임신, 출산, 육아, 가족 구성원 돌봄 등의 이유로 미취업 중인 여성과학기술인
- 이공계 학사이상 학위 소지자(학사 학위자의 경우, 6개월 이상 경력이 있는 자) ○ 기관
- 경력단절 여성과학기술인을 활용하고자 하는 기관
- 과학기술 분야 연구기관 및 대학, 민간기업 연구소', NULL
FROM policy p WHERE p.canonical_slug = 'national-infant-daycare-fee'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'api_gov24', 'https://www.gov.kr/portal/rcvfvrSvc/dtlEx/PTR000052170'
FROM policy p WHERE p.canonical_slug = 'national-infant-daycare-fee'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #98 아가와 엄마를 위한 무료 공익보험(우체국대한민국 엄마보험)
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'national-child-allowance', '아가와 엄마를 위한 무료 공익보험(우체국대한민국 엄마보험)', '자녀의 희귀질환과 엄마의 임신질환을 보장하는 공익보험으로 별도의 조건없이 국가(우체국)에서 보험료 전액을 지원합니다.', '- 보장내용 (주계약) 태아의 희귀질환 진단보험금 100만원(최초 1회에 한함) (특약) 임신중 질환별(임신중독증 10만원, 임신고혈압 5만원, 임신성당뇨병 3만원) 진단보험금(최초 1회에 한함)
※ ''희귀질환''이라 함은 희귀질환관리법 및 관련 법령 등에 따라 질병관리청장이 공고한 질환을 말합니다. 보험료 : 우체국에서 전액 부담 납입기간 : 전기납(연납) 국가(우체국)에서 부담', NULL,
  (SELECT id FROM category WHERE code = 'service'), 'yearly',
  30000, 1000000, '- 보장내용 (주계약) 태아의 희귀질환 진단보험금 100만원(최초 1회에 한함) (특약) 임신중 질환별(임신중독증 10만원, 임신고혈압 5만원, 임신성당뇨병 3만원) 진단보험금(최초 1회에 한함)
※ ''희귀질환''이라 함은 희귀질환관리법 및 관련 법령 등에 따라 질병관리청장이 공고한 질환을 말합니다. 보험료 : 우체국에서 전액 부담 납입기간 : 전기납(연납) 국가(우체국)에서 부담', NULL,
  '사후관리기관목록: 담당 시/군/구청 또는 과학기술정보통신부 우정사업본부에서 서비스 제공 이후 대상자의 상황 관리', NULL,
  NULL, NULL, 'none',
  NULL, 'https://www.bokjiro.go.kr/ssis-tbu/twataa/wlfareInfo/moveTWAT52011M.do?wlfareInfoId=WLF00005631&wlfareInfoReldBztpCd=01',
  'unrated', 'needs_review', 'active',
  NULL
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'national-child-allowance' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'national-child-allowance' AND ls.code = 'child_3y_plus'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;
INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'national-child-allowance' AND ls.code = 'post_birth_60d'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;
INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'national-child-allowance' AND ls.code = 'pregnancy'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'none', NULL, FALSE,
  204, 540,
  '가입나이 : (주계약) 태아, (특약) 17~45세(22주 이내 임신부) 다태아의 경우 각각 가입하되 특약은 다태아 중 1명만 가입 가능 엄마(특약)를 제외한 자녀만 가입할 경우에는 22주 이후에도 가입 가능(출산 전까지) 보험기간 : (주계약) 자녀-10년 만기, (특약) 엄마-분만시까지(최대 10개월) 자세한 내용은 우체국보험 홈페이지와 모바일앱(잇다 보험) 참고', NULL
FROM policy p WHERE p.canonical_slug = 'national-child-allowance'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'api_central_welfare', 'https://www.bokjiro.go.kr/ssis-tbu/twataa/wlfareInfo/moveTWAT52011M.do?wlfareInfoId=WLF00005631&wlfareInfoReldBztpCd=01'
FROM policy p WHERE p.canonical_slug = 'national-child-allowance'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #99 어린이집지원(교사근무환경개선비,교사겸직원장지원비)
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'national-maternity-leave-benefit', '어린이집지원(교사근무환경개선비,교사겸직원장지원비)', '어린이집 보육교사와 교사를 겸직하는 원장의 근로여건개선을 위해 근무환경 개선비를 지원합니다.', '- 보육교사 및 교사겸직원장의 근로여건 개선을 위해 근무환경개선비를 지원합니다. (교사근무환경개선비)
- 일 8시간 근무 기본보육 담임교사 및 대체교사 : 월 28만원
- 일 4시간 근무 연장보육 전담교사 및 대체교사 : 월 14만원 * 평일기준 8시간 근무일수와 4시간 근무일수를 합하여 월 15일 이상인 경우 월 14만원 지급 (교사겸직원장지원) 월 7만 5천원', NULL,
  (SELECT id FROM category WHERE code = 'service'), 'monthly',
  140000, 280000, '- 보육교사 및 교사겸직원장의 근로여건 개선을 위해 근무환경개선비를 지원합니다. (교사근무환경개선비)
- 일 8시간 근무 기본보육 담임교사 및 대체교사 : 월 28만원
- 일 4시간 근무 연장보육 전담교사 및 대체교사 : 월 14만원 * 평일기준 8시간 근무일수와 4시간 근무일수를 합하여 월 15일 이상인 경우 월 14만원 지급 (교사겸직원장지원) 월 7만 5천원', NULL,
  '사후관리기관목록: 담당 시/군/구청 또는 어린이집에서 서비스 제공 이후 대상자의 상황 관리', NULL,
  NULL, NULL, 'none',
  NULL, 'https://www.bokjiro.go.kr/ssis-tbu/twataa/wlfareInfo/moveTWAT52011M.do?wlfareInfoId=WLF00001094&wlfareInfoReldBztpCd=01',
  'unrated', 'needs_review', 'active',
  NULL
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'national-maternity-leave-benefit' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'national-maternity-leave-benefit' AND ls.code = 'infant_0_36m'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;
INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'national-maternity-leave-benefit' AND ls.code = 'pregnancy'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'none', NULL, FALSE,
  36, 60,
  '- 교사근무환경개선비 지원대상은 다음과 같습니다. (지원조건)
- 어린이집 또는 시간제보육제공기관에서 반을 맡고 있는 담임교사(보육교사 또는 특수교사) 및 연장보육 전담교사, 담임교사와 연장보육 전담교사를 대체하는 대체교사
- 평일 8시간을 원칙으로 월 15일 이상 어린이집 또는 시간제보육 제공기관에서 실제 근무 또는 평일 4시간을 원칙으로 월 15일 이상 어린이집 및 시간제보육 제공기관에서 실제 근무 * 월급여 야간연장 교사는 일 6시간 이상 8시간 이내 근무…', NULL
FROM policy p WHERE p.canonical_slug = 'national-maternity-leave-benefit'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'api_central_welfare', 'https://www.bokjiro.go.kr/ssis-tbu/twataa/wlfareInfo/moveTWAT52011M.do?wlfareInfoId=WLF00001094&wlfareInfoReldBztpCd=01'
FROM policy p WHERE p.canonical_slug = 'national-maternity-leave-benefit'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #100 예술인ㆍ노무제공자 출산전후급여등
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'national-parental-leave-benefit', '예술인ㆍ노무제공자 출산전후급여등', '출산 또는 유산ㆍ사산을 이유로 노무를 제공할 수 없는 고용보험 가입 예술인ㆍ노무제공자에게 출산전후급여 등을 지급함으로써 모성보호 및 생계보장 지원', '- 출산전후급여등 지급수준
- 출산(유산·사산)일 현재 고용보험 피보험자격을 유지한 경우: 출산(유산·사산)일 직전 1년 동안의 월평균보수에 해당하는 금액
- 출산(유산·사산)일 현재 고용보험 피보험자격을 상실한 경우: 출산(유산·사산)일 직전 18개월 동안의 월평균보수에 해당하는 금액
- 상한액 및 하한액: 매년 고용노동부장관이 고시하는 금액 * (예술인) ''25년 고시 금액: 상한액 월 210만원, 하한액 월 60만원 (노무제공자) ''25년 고시 금액: 상한액 월 210만원, 하한액 월 80만원 ○ 출산전후급여등 지급기간
- 출산한 경우: 출산 전후 90일(미숙…', '고용노동부 고객상담센터 / 1350',
  (SELECT id FROM category WHERE code = 'service'), 'monthly',
  600000, 2100000, '- 출산전후급여등 지급수준
- 출산(유산·사산)일 현재 고용보험 피보험자격을 유지한 경우: 출산(유산·사산)일 직전 1년 동안의 월평균보수에 해당하는 금액
- 출산(유산·사산)일 현재 고용보험 피보험자격을 상실한 경우: 출산(유산·사산)일 직전 18개월 동안의 월평균보수에 해당하는 금액
- 상한액 및 하한액: 매년 고용노동부장관이 고시하는 금액 * (예술인) ''25년 고시 금액: 상한액 월 210만원, 하한액 월 60만원 (노무제공자) ''25년 고시 금액: 상한액 월 210만원, 하한액 월 80만원 ○ 출산전후급여등 지급기간
- 출산한 경우: 출산 전후 90일(미숙…', NULL,
  '가까운 고용센터를 방문하거나 온라인(고용24 홈페이지: www.work24.go.kr) 또는 우편으로 신청', ARRAY['online', 'visit'],
  '출산 또는 유산ㆍ사산을 한 날부터 12개월 이내', 360, 'birth',
  NULL, 'https://www.gov.kr/portal/rcvfvrSvc/dtlEx/149200005017',
  'unrated', 'needs_review', 'active',
  NULL
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'national-parental-leave-benefit' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'national-parental-leave-benefit' AND ls.code = 'post_birth_60d'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;
INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'national-parental-leave-benefit' AND ls.code = 'pregnancy'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'requires_review', NULL, FALSE,
  3, NULL,
  '- 고용보험 피보험 단위기간이 3개월 이상일 것
- 출산(유산·사산)일 현재 고용보험 피보험자격을 유지한 경우: 출산(유산·사산)일 이전에 예술인 또는 노무제공자로서 피보험 단위기간이 3개월 이상일 것
- 출산(유산·사산)일 현재 고용보험 피보험자격을 상실한 경우: 출산(유산·사산)일 이전 18개월 동안 예술인 또는 노무제공자로서의 피보험 단위기간이 3개월 이상일 것 ○ 출산전후급여등 지급기간에 노무제공을 하지 않을 것
- 다만, 그 지급기간 중 노무제공 또는…', '소득 조건 확인 필요'
FROM policy p WHERE p.canonical_slug = 'national-parental-leave-benefit'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'api_gov24', 'https://www.gov.kr/portal/rcvfvrSvc/dtlEx/149200005017'
FROM policy p WHERE p.canonical_slug = 'national-parental-leave-benefit'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #101 인플루엔자 국가예방접종 지원사업
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'national-reduced-hours-benefit', '인플루엔자 국가예방접종 지원사업', '어르신, 임신부 및 어린이의 인플루엔자 접종률 향상과 질병부담 감소를 위해 인플루엔자 예방접종을 국가에서 지원합니다.', '- (지원대상
- 생후 6개월~ 13세 어린이) 2회접종 사업기간 : 2025. 9. 22.(월)~2026. 4. 30.(목) 1회접종 사업기간 : 2025. 9. 29.(월)~2026. 4. 30.(목)
- 생후 6개월~9세 미만 어린이 중 인플루엔자 예방접종을 처음 접종 또는 2025.6.30까지 인플루엔자 백신을 총 1회만 접종한 어린이는 2회 접종 대상 ○ (지원대상
- 임신부) 사업기간 : 2025. 9. 29.(월)~2026. 4. 30.(목) ○ (지원대상
- 65세 이상 어르신) 75세 이상 사업기간 : 2025. 10. 15.(수)~2026. 4.…', '- 질병관리청 콜센터 / 1339
- 질병관리청 예방접종관리과: 043-913-2258
- 질병관리청 예방접종관리과: 043-719-8376
- 질병관리청 예방접종관리과: 043-719-8396',
  (SELECT id FROM category WHERE code = 'service'), 'one_time',
  NULL, NULL, '- (지원대상
- 생후 6개월~ 13세 어린이) 2회접종 사업기간 : 2025. 9. 22.(월)~2026. 4. 30.(목) 1회접종 사업기간 : 2025. 9. 29.(월)~2026. 4. 30.(목)
- 생후 6개월~9세 미만 어린이 중 인플루엔자 예방접종을 처음 접종 또는 2025.6.30까지 인플루엔자 백신을 총 1회만 접종한 어린이는 2회 접종 대상 ○ (지원대상
- 임신부) 사업기간 : 2025. 9. 29.(월)~2026. 4. 30.(목) ○ (지원대상
- 65세 이상 어르신) 75세 이상 사업기간 : 2025. 10. 15.(수)~2026. 4.…', NULL,
  '주소지 보건소 또는 지정 위탁기관에 방문하여 신청', ARRAY['visit'],
  '접종 대상자 및 연령별 지원 기간 상이', NULL, 'none',
  NULL, 'https://www.bokjiro.go.kr/ssis-tbu/twataa/wlfareInfo/moveTWAT52011M.do?wlfareInfoId=WLF00003213&wlfareInfoReldBztpCd=01',
  'unrated', 'needs_review', 'active',
  NULL
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'national-reduced-hours-benefit' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'national-reduced-hours-benefit' AND ls.code = 'pregnancy'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'none', NULL, FALSE,
  780, 888,
  '- 어린이 인플루엔자 국가예방접종 지원
- 지원대상: 생후 6개월~13세 어린이(2012.1.1.~2025.8.31.출생자) * 실제 생년월일과 주민등록상 생년월일이 상이할 경우, 실제 생년월일 기준으로 접종 및 비용 지원
- 지원기간: 2회접종대상 : 2025. 9. 22. ~ 2026. 4. 30. 1회접종대상 : 2025. 9. 29. ~ 2026. 4. 30.
- 지정 의료기관 및 보건소를 이용하면 주소지에 관계없이 전국 어디서나 무료로 인플루엔자 예방…', NULL
FROM policy p WHERE p.canonical_slug = 'national-reduced-hours-benefit'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'api_central_welfare', 'https://www.bokjiro.go.kr/ssis-tbu/twataa/wlfareInfo/moveTWAT52011M.do?wlfareInfoId=WLF00003213&wlfareInfoReldBztpCd=01'
FROM policy p WHERE p.canonical_slug = 'national-reduced-hours-benefit'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #102 임산부 외래진료비 본인부담률 경감
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'national-spouse-maternity-leave-benefit', '임산부 외래진료비 본인부담률 경감', '임신부들의 요양 기관 이용에 대한 편의 증진', '임신 기간 중 진료 과목 상관없이 요양 급여 비용 총액의 일정 비율 경감(상급 종합병원 40%, 종합병원 30%, 병원 20%, 의원 10%)', '보건복지상담센터 / 129',
  (SELECT id FROM category WHERE code = 'service'), 'one_time',
  NULL, NULL, '임신 기간 중 진료 과목 상관없이 요양 급여 비용 총액의 일정 비율 경감(상급 종합병원 40%, 종합병원 30%, 병원 20%, 의원 10%)', NULL,
  '해당 서비스는 신청없이 자격대상자에게 자동적으로 제공됩니다.', NULL,
  '상시신청', NULL, 'none',
  NULL, 'https://www.gov.kr/portal/rcvfvrSvc/dtlEx/135200005046',
  'unrated', 'needs_review', 'active',
  NULL
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'national-spouse-maternity-leave-benefit' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'national-spouse-maternity-leave-benefit' AND ls.code = 'pregnancy'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'none', NULL, FALSE,
  NULL, NULL,
  '임산부', NULL
FROM policy p WHERE p.canonical_slug = 'national-spouse-maternity-leave-benefit'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'api_gov24', 'https://www.gov.kr/portal/rcvfvrSvc/dtlEx/135200005046'
FROM policy p WHERE p.canonical_slug = 'national-spouse-maternity-leave-benefit'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #103 출산전후(유산ㆍ사산)휴가 급여
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'national-work-family-balance-subsidy', '출산전후(유산ㆍ사산)휴가 급여', '출산전후(유산ㆍ사산)휴가 기간에 대해 급여를 지급함으로써 여성근로자의 모성보호 및 출산으로 인한 경력단절 예방', '- 출산전후휴가
- 임신 중의 여성에게 출산 전과 후를 통하여 90일(미숙아 100일, 다태아 120일) 부여, 출산 후 45일(다태아 60일) 이상 배정 * ''25.2.23.부터 미숙아 출산 시 휴가 기간 100일로 확대 ○ 출산전후휴가 급여
- 출산전후휴가를 사용한 근로자에게 급여 지원
- 지급 기간
- 우선지원대상기업 소속 근로자: 출산전후휴가 기간(90일, 미숙아 100일, 다태아 120일)
- 대규모기업 소속 근로자: 출산전후휴가 기간 중 60일(다태아 75일)을 초과한 일수(30일 한도, 미숙아 40일 한도, 다태아 45일 한도) * ''25.2.23.부터…', '고용노동부 고객상담센터 / 1350',
  (SELECT id FROM category WHERE code = 'service'), 'one_time',
  NULL, NULL, '- 출산전후휴가
- 임신 중의 여성에게 출산 전과 후를 통하여 90일(미숙아 100일, 다태아 120일) 부여, 출산 후 45일(다태아 60일) 이상 배정 * ''25.2.23.부터 미숙아 출산 시 휴가 기간 100일로 확대 ○ 출산전후휴가 급여
- 출산전후휴가를 사용한 근로자에게 급여 지원
- 지급 기간
- 우선지원대상기업 소속 근로자: 출산전후휴가 기간(90일, 미숙아 100일, 다태아 120일)
- 대규모기업 소속 근로자: 출산전후휴가 기간 중 60일(다태아 75일)을 초과한 일수(30일 한도, 미숙아 40일 한도, 다태아 45일 한도) * ''25.2.23.부터…', NULL,
  '가까운 관할 고용센터를 방문하거나 온라인(고용24 홈페이지: www.work24.go.kr) 또는 우편으로 신청', ARRAY['online', 'visit'],
  '휴가를 시작한 날 이후 1개월부터 휴가가 끝난 날 이후 12개월 이내', 360, 'none',
  NULL, 'https://www.gov.kr/portal/rcvfvrSvc/dtlEx/WII000001460',
  'unrated', 'needs_review', 'active',
  '[현민] 다태아 출산 시 휴가 기간은 120일로 자동 연장'
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'national-work-family-balance-subsidy' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'national-work-family-balance-subsidy' AND ls.code = 'post_birth_60d'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;
INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'national-work-family-balance-subsidy' AND ls.code = 'pregnancy'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'none', NULL, FALSE,
  1, NULL,
  '- 「근로기준법」 제74조에 따른 출산전후휴가 또는 유산ㆍ사산휴가를 받은 근로자
- 휴가가 끝난 날 이전에 고용보험 피보험 단위기간이 합산하여 180일 이상
- 휴가를 시작한 날(소속 사업장이 우선지원대상기업이 아닌 경우에는 휴가 시작 후 60일(다태아 75일)이 지난 날) 이후 1개월부터 휴가가 끝난 날 이후 12개월 이내에 신청', NULL
FROM policy p WHERE p.canonical_slug = 'national-work-family-balance-subsidy'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'api_gov24', 'https://www.gov.kr/portal/rcvfvrSvc/dtlEx/WII000001460'
FROM policy p WHERE p.canonical_slug = 'national-work-family-balance-subsidy'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #104 표준모자보건수첩 제공
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'national-women-scientist-return', '표준모자보건수첩 제공', '표준모자보건수첩 보급으로 임신부터 영유아기까지 각종 검사 및 건강관리 안내, 예방접종, 검진(검사) 등 건강기록 유지, 양육에 대한 필수·객관적 정보 제공으로 모성과 영유아의 건강증진을 도모합니다.', '임산부수첩 및 아기수첩 제공', '해당지역 보건소 / -',
  (SELECT id FROM category WHERE code = 'service'), 'one_time',
  NULL, NULL, '임산부수첩 및 아기수첩 제공', NULL,
  '보건소 또는 의료기관(산부인과, 소아청소년과), 읍면동 주민센터(점자수첩), 다문화지원센터(다국어수첩) 방문하거나 온라인(정부24) 신청', ARRAY['online', 'visit'],
  '접수기관 별 상이', NULL, 'none',
  NULL, 'https://www.bokjiro.go.kr/ssis-tbu/twataa/wlfareInfo/moveTWAT52011M.do?wlfareInfoId=WLF00001161&wlfareInfoReldBztpCd=01',
  'unrated', 'needs_review', 'active',
  NULL
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'national-women-scientist-return' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'national-women-scientist-return' AND ls.code = 'infant_0_36m'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;
INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'national-women-scientist-return' AND ls.code = 'pregnancy'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'none', NULL, FALSE,
  NULL, NULL,
  '임신부 또는 출생 사실 확인된 영유아', NULL
FROM policy p WHERE p.canonical_slug = 'national-women-scientist-return'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'api_central_welfare', 'https://www.bokjiro.go.kr/ssis-tbu/twataa/wlfareInfo/moveTWAT52011M.do?wlfareInfoId=WLF00001161&wlfareInfoReldBztpCd=01'
FROM policy p WHERE p.canonical_slug = 'national-women-scientist-return'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #105 2025 영구 불임예상 난자·정자 냉동 지원
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'national-maternal-child-health-book', '2025 영구 불임예상 난자·정자 냉동 지원', '영구 불임이 되기 전에 생식세포(난자·정자)의 동결·보존을 지원하여 가임력을 보전하고 임신·출산 가능성을 확보', '- 지원 범위 : 검사, 과배란유도, 생식세포(난자, 정자)채취, 동결, 보관 비용 일부 지원
- 생식세포 동결, 보존과 관련된 비용이면 지원 금액 한도 내 지원 가능
※ 지원제외 : 입원료, 생식세포 동결, 보존과 관련 없는 검사료, 연장 보관료 등 ○ 지원 횟수 : 생애 1회 ○ 지원 금액 : 본인부담금의 50% , 여) 최대 200만 원, 남) 최대 30만 원
※ 생명 윤리 및 안전에 관한 법률 상 허용되는 범위에서 지원
※ 중앙정부, 지자체, 민간의 유사 사업과 중복 지원 불가하며 유리한 사업으로 안내', '보건복지상담센터 / 129',
  (SELECT id FROM category WHERE code = 'service'), 'one_time',
  300000, 2000000, '- 지원 범위 : 검사, 과배란유도, 생식세포(난자, 정자)채취, 동결, 보관 비용 일부 지원
- 생식세포 동결, 보존과 관련된 비용이면 지원 금액 한도 내 지원 가능
※ 지원제외 : 입원료, 생식세포 동결, 보존과 관련 없는 검사료, 연장 보관료 등 ○ 지원 횟수 : 생애 1회 ○ 지원 금액 : 본인부담금의 50% , 여) 최대 200만 원, 남) 최대 30만 원
※ 생명 윤리 및 안전에 관한 법률 상 허용되는 범위에서 지원
※ 중앙정부, 지자체, 민간의 유사 사업과 중복 지원 불가하며 유리한 사업으로 안내', NULL,
  '- 방문 신청 : 주민등록상 주소지 관할 보건소 ○ 온라인 신청 : e보건소 (e-heath.go.kr) ○ 신청절차 : 희망자는
- ① 난임시술 의료기관에서 생식세포(난자, 정자)동결,보존을 진행한 후
- ② 시술비를 의료기관에 납부하고,
- ③ 의료기관으로부터 관련 증빙자료를 발급받아,
- ④ 주민등록상 주소지 관할 보건소에 지원 신청하면
- ⑤ 비용 지급 ○ 신청 기간 : 생식세포 채취일로부터 6개월 -단, 예외적으로 보건소장이 기한 내 신청이 불가한 타당한 사유가 있는…', ARRAY['online', 'visit'],
  '생식세포 채취일로부터 6개월 (2025.1.1. 을 포함하여 그 이후에 생식세포를 채취한 자일 것)', NULL, 'none',
  NULL, 'https://www.gov.kr/portal/rcvfvrSvc/dtlEx/135200005058',
  'unrated', 'needs_review', 'active',
  NULL
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'national-maternal-child-health-book' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'national-maternal-child-health-book' AND ls.code = 'post_birth_60d'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;
INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'national-maternal-child-health-book' AND ls.code = 'pregnancy'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;
INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'national-maternal-child-health-book' AND ls.code = 'pregnancy_prep'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'none', NULL, FALSE,
  NULL, NULL,
  '- 「모자보건법 시행령」 제14조에 해당하는 의학적 사유에 의한 생식건강의 손상으로 영구불임이 예상되는 자
※ 생식세포 채취일이 2025.1.1. 을 포함하여 그 이후일 것
※ 의학적 사유 : 모자보건법 시행령 제14조 1. 유착성자궁부속기절제술 2. 부속기종양적출술 3. 난소부분절제술 4. 고환적출술 5. 고환악성종양적출술 6. 부고환적출술 7. 항암치료(항암제 투여, 복부 및 골반 부위 포함 방사선 치료, 면역 억제 치료) 8. 염색체 이상(터너 증후군,…', NULL
FROM policy p WHERE p.canonical_slug = 'national-maternal-child-health-book'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'api_gov24', 'https://www.gov.kr/portal/rcvfvrSvc/dtlEx/135200005058'
FROM policy p WHERE p.canonical_slug = 'national-maternal-child-health-book'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #106 난임치료휴가 급여
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'national-pregnant-commute-reduction', '난임치료휴가 급여', '저출생 문제 극복 및 난임치료로 인한 근로자의 부담을 경감하기 위해 근로자에게 휴가 부여', '- 난임치료휴가
- 근로자가 난임 치료를 위해 휴가를 청구하는 경우 연간 6일(최초 2일 유급, 나머지 4일 무급) 이내의 휴가 부여 ○ 난임치료휴가 급여 지원
- 난임치료휴가를 사용한 우선지원대상기업 근로자에게 최초 2일분(''25년 기준 상한 160,740원, 상한액 매년 고시) 급여 지원', '고용노동부 고객상담센터 / 1350',
  (SELECT id FROM category WHERE code = 'service'), 'one_time',
  160740, 160740, '- 난임치료휴가
- 근로자가 난임 치료를 위해 휴가를 청구하는 경우 연간 6일(최초 2일 유급, 나머지 4일 무급) 이내의 휴가 부여 ○ 난임치료휴가 급여 지원
- 난임치료휴가를 사용한 우선지원대상기업 근로자에게 최초 2일분(''25년 기준 상한 160,740원, 상한액 매년 고시) 급여 지원', NULL,
  '가까운 관할 고용센터를 방문하거나 온라인(고용24 홈페이지 : www.work.go.kr), 우편으로 신청', ARRAY['online', 'visit'],
  '휴가를 시작한 날 이후 1개월부터 휴가가 끝난 날 이후 12개월 이내에 신청(분할사용 시 휴가가 끝난 날 이후 일괄하여 신청)', 360, 'none',
  NULL, 'https://www.gov.kr/portal/rcvfvrSvc/dtlEx/149200005026',
  'unrated', 'needs_review', 'active',
  '[현민] 부부가 동시 사용 가능하며 초기 난임 검사 기간 보장'
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'national-pregnant-commute-reduction' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'national-pregnant-commute-reduction' AND ls.code = 'post_birth_60d'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;
INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'national-pregnant-commute-reduction' AND ls.code = 'pregnancy_prep'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'none', NULL, FALSE,
  NULL, NULL,
  '- 남녀고용평등법상 난임치료휴가를 부여받은 우선지원대상기업 소속 근로자
- 휴가가 끝난 날 이전에 피보험단위기간이 180일 이상
- 피보험자가 소속된 사업장이 우선지원대상기업인 경우', NULL
FROM policy p WHERE p.canonical_slug = 'national-pregnant-commute-reduction'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'api_gov24', 'https://www.gov.kr/portal/rcvfvrSvc/dtlEx/149200005026'
FROM policy p WHERE p.canonical_slug = 'national-pregnant-commute-reduction'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #107 모성보호육아지원(출산전후휴가(유산ㆍ사산휴가 포함) 급여, 육아휴직등 급여)
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'national-fertility-treatment-leave', '모성보호육아지원(출산전후휴가(유산ㆍ사산휴가 포함) 급여, 육아휴직등 급여)', '출산전후 휴가급여, 육아휴직급여, 난임치료휴가급여 등의 지급을 통해 일과 가정의 양립을 지원하고 모성보호를 도모합니다.', '출산전후휴가급여, 유산·사산휴가급여, 육아휴직급여, 육아기 근로시간 단축급여, 난임치료휴가급여 등 지급', '고용노동부 고객상담센터 / 1350',
  (SELECT id FROM category WHERE code = 'service'), 'one_time',
  NULL, NULL, '출산전후휴가급여, 유산·사산휴가급여, 육아휴직급여, 육아기 근로시간 단축급여, 난임치료휴가급여 등 지급', NULL,
  '고용24 또는 관할 고용센터를 통해 온라인·방문·우편 신청', ARRAY['online', 'visit'],
  '급여별 신청기한 상이. 통상 휴가·휴직 종료 후 12개월 이내 신청 필요', 360, 'none',
  NULL, 'https://www.bokjiro.go.kr/ssis-tbu/twataa/wlfareInfo/moveTWAT52011M.do?wlfareInfoId=WLF00003226&wlfareInfoReldBztpCd=01',
  'unrated', 'needs_review', 'active',
  NULL
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'national-fertility-treatment-leave' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'national-fertility-treatment-leave' AND ls.code = 'post_birth_60d'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;
INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'national-fertility-treatment-leave' AND ls.code = 'pregnancy_prep'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'none', NULL, FALSE,
  NULL, NULL,
  '고용보험 가입 근로자 중 출산전후휴가, 유산·사산휴가, 육아휴직, 육아기 근로시간 단축 등 요건을 충족한 사람', NULL
FROM policy p WHERE p.canonical_slug = 'national-fertility-treatment-leave'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'api_central_welfare', 'https://www.bokjiro.go.kr/ssis-tbu/twataa/wlfareInfo/moveTWAT52011M.do?wlfareInfoId=WLF00003226&wlfareInfoReldBztpCd=01'
FROM policy p WHERE p.canonical_slug = 'national-fertility-treatment-leave'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #108 고용보험 미적용자 출산급여 지원
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'national-pregnancy-work-protection', '고용보험 미적용자 출산급여 지원', '소득활동을 하고 있으나 고용보험의 ''출산전후휴가급여''를 지원받지 못하는 출산여성에게 출산급여를 지원합니다.', '- 출산급여
- 총 150만원(월 50만원 X 3월분)
- 유산, 사산의 경우는 임신 기간에 따라 급여 수준 상이
- 임신 기간 15주까지 : 30만원 / 16~21주 : 50만원 / 22~27주 : 100만원 / 28주 이상 : 150만원', '고용노동부 고객상담센터 / 1350',
  (SELECT id FROM category WHERE code = 'service'), 'monthly',
  300000, 1500000, '- 출산급여
- 총 150만원(월 50만원 X 3월분)
- 유산, 사산의 경우는 임신 기간에 따라 급여 수준 상이
- 임신 기간 15주까지 : 30만원 / 16~21주 : 50만원 / 22~27주 : 100만원 / 28주 이상 : 150만원', NULL,
  '방문 신청 또는 우편 : 고용센터 ○ 온라인 신청 : 고용24 홈페이지(www.work24.go.kr) ○ 지급 결정 / 지급 : 신청 접수 후 14일 이내 지급(부지급) 결정 및 통지 / 본인 계좌로 지급 => 별도로 신청절차를 넣어서 표기', ARRAY['online', 'visit'],
  '출산일로부터 1년 이내(기간내 미신청시 소멸)', 365, 'birth',
  NULL, 'https://www.bokjiro.go.kr/ssis-tbu/twataa/wlfareInfo/moveTWAT52011M.do?wlfareInfoId=WLF00000838&wlfareInfoReldBztpCd=01',
  'unrated', 'needs_review', 'active',
  NULL
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'national-pregnancy-work-protection' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'national-pregnancy-work-protection' AND ls.code = 'post_birth_60d'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'requires_review', NULL, FALSE,
  3, NULL,
  '소득활동을 하고 있지만 고용보험 미적용으로 ''출산전후휴가급여''를 받지 못하는 출산여성(유산, 사산의 경우 포함)에게 출산급여를 총 150만원(월50만원 x 3월분) 지원', '소득 조건 확인 필요'
FROM policy p WHERE p.canonical_slug = 'national-pregnancy-work-protection'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'api_central_welfare', 'https://www.bokjiro.go.kr/ssis-tbu/twataa/wlfareInfo/moveTWAT52011M.do?wlfareInfoId=WLF00000838&wlfareInfoReldBztpCd=01'
FROM policy p WHERE p.canonical_slug = 'national-pregnancy-work-protection'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #109 국민연금 출산크레딧
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'national-family-care-leave', '국민연금 출산크레딧', '출산에 대해 연금 가입기간을 추가로 인정하여 출산 친화 환경을 조성하고 여성의 연금 수급 기회를 확대합니다.', '2008.1.1 이후 자녀를 출산(입양포함)한 국민연금 가입자에게 자녀수에 따라 가입기간을 추가로 인정합니다. 자녀가 2명인 경우 : 자녀 1명마다 12개월을 더한 개월 수 자녀가 3명 이상인 경우 : 첫째 및 둘째 자녀에 인정되는 24개월에 셋째 자녀 이상 1명마다 18개월씩 추가하여 더한 개월 수를 가입기간으로 추가 산입 단, ''26년1.1 시행 기준으로 ''08년~''25년까지는 둘째부터 12개월, 셋째부터 자녀당 18개월 상한 50개월 적용', '국민연금공단 콜센터 / 1355',
  (SELECT id FROM category WHERE code = 'service'), 'one_time',
  NULL, NULL, '2008.1.1 이후 자녀를 출산(입양포함)한 국민연금 가입자에게 자녀수에 따라 가입기간을 추가로 인정합니다. 자녀가 2명인 경우 : 자녀 1명마다 12개월을 더한 개월 수 자녀가 3명 이상인 경우 : 첫째 및 둘째 자녀에 인정되는 24개월에 셋째 자녀 이상 1명마다 18개월씩 추가하여 더한 개월 수를 가입기간으로 추가 산입 단, ''26년1.1 시행 기준으로 ''08년~''25년까지는 둘째부터 12개월, 셋째부터 자녀당 18개월 상한 50개월 적용', NULL,
  '사후관리기관목록: 담당 시/군/구청 또는 국민연금공단에서 서비스 제공 이후 대상자의 상황 관리', NULL,
  '자세한 날짜는 국민연금공단 지사에 따라 다를 수 있음', NULL, 'none',
  NULL, 'https://www.bokjiro.go.kr/ssis-tbu/twataa/wlfareInfo/moveTWAT52011M.do?wlfareInfoId=WLF00004647&wlfareInfoReldBztpCd=01',
  'unrated', 'needs_review', 'active',
  NULL
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'national-family-care-leave' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'national-family-care-leave' AND ls.code = 'child_3y_plus'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;
INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'national-family-care-leave' AND ls.code = 'post_birth_60d'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'none', NULL, FALSE,
  NULL, NULL,
  '자녀(출산 또는 입양)가 있는 국민연금 가입자 또는 가입자였던자가 노령연금 수급권을 취득한 자를 대상으로 합니다.', NULL
FROM policy p WHERE p.canonical_slug = 'national-family-care-leave'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'api_central_welfare', 'https://www.bokjiro.go.kr/ssis-tbu/twataa/wlfareInfo/moveTWAT52011M.do?wlfareInfoId=WLF00004647&wlfareInfoReldBztpCd=01'
FROM policy p WHERE p.canonical_slug = 'national-family-care-leave'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #110 다자녀가구 자동차취득세 감면
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'national-child-sick-leave', '다자녀가구 자동차취득세 감면', '다자녀가구가 취득한 자동차의 취득세를 감면하여 출산 및 양육을 지원', '2027년 12월 31일까지 취득세 감면 ○ 승용자동차 (7~10인승), 승합자동차 (15인승 이하), 화물자동차 (1톤 이하), 배기량 250시시 이하 이륜자동차 면제(다만, 지방세특례제한법 제177조의2에 따라 지방세 감면 특례의 제한 적용) ○ 3자녀 취득세 100%(단, 6인 이하 승용자동차는 140만원 한도) / 2자녀 취득세 50%(단, 6인 이하 승용자동차는 70만원 한도)', '지방세 one call 서비스 / 1577-5700',
  (SELECT id FROM category WHERE code = 'service'), 'monthly',
  700000, 1400000, '2027년 12월 31일까지 취득세 감면 ○ 승용자동차 (7~10인승), 승합자동차 (15인승 이하), 화물자동차 (1톤 이하), 배기량 250시시 이하 이륜자동차 면제(다만, 지방세특례제한법 제177조의2에 따라 지방세 감면 특례의 제한 적용) ○ 3자녀 취득세 100%(단, 6인 이하 승용자동차는 140만원 한도) / 2자녀 취득세 50%(단, 6인 이하 승용자동차는 70만원 한도)', NULL,
  '시군구청에 방문하여 신청', ARRAY['visit'],
  '자세한 날짜는 시군구청에 따라 다를 수 있음', NULL, 'none',
  NULL, 'https://www.gov.kr/portal/rcvfvrSvc/dtlEx/131200000008',
  'unrated', 'needs_review', 'active',
  NULL
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'national-child-sick-leave' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'national-child-sick-leave' AND ls.code = 'child_3y_plus'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;
INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'national-child-sick-leave' AND ls.code = 'infant_0_36m'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;
INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'national-child-sick-leave' AND ls.code = 'post_birth_60d'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'none', NULL, FALSE,
  NULL, 215,
  '만18세 미만의 자녀 2명 이상을 양육하는 자(가족관계등록부 기준, 양자 및 배우자 자녀 포함)', NULL
FROM policy p WHERE p.canonical_slug = 'national-child-sick-leave'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'api_gov24', 'https://www.gov.kr/portal/rcvfvrSvc/dtlEx/131200000008'
FROM policy p WHERE p.canonical_slug = 'national-child-sick-leave'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #111 분만취약지 지원
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'national-automatic-childcare-subsidy', '분만취약지 지원', '분만취약지역에 산부인과를 설치 운영하여 산모의 분만, 산전 후 진찰 및 이송체계 구축하여 산모의 안전과 건강증진 도모', '- 분만취약지 지원 사업 지정병원에 시설, 장비구매비 및 인건비 지원
- 1차년도 : 시설장비비 12억원, 운영비 2.5억원(6개월)
- 2차년도 이후 : 운영비 5억원', '- 보건복지부 공공의료과: 044-202-2546
- 국립중앙의료원 중앙모자의료센터: 02-6362-3765',
  (SELECT id FROM category WHERE code = 'service'), 'monthly',
  250000000, 1200000000, '- 분만취약지 지원 사업 지정병원에 시설, 장비구매비 및 인건비 지원
- 1차년도 : 시설장비비 12억원, 운영비 2.5억원(6개월)
- 2차년도 이후 : 운영비 5억원', NULL,
  '사업을 수행하고자 하는 기초자치단체는 지역 내 선정된 의료기관과 함께 사업계획서 작성 지침과 사업 추진 일정을 고려하여 사업계획서를 작성하고, 광역자치단체(시,도)를 경유하여 보건복지부에 제출', NULL,
  '사업 공모 시 관련 지방자치단체에 배포', NULL, 'none',
  NULL, 'https://www.gov.kr/portal/rcvfvrSvc/dtlEx/SD0000016200',
  'unrated', 'needs_review', 'active',
  NULL
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'national-automatic-childcare-subsidy' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'national-automatic-childcare-subsidy' AND ls.code = 'post_birth_60d'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'none', NULL, FALSE,
  NULL, NULL,
  '분만취약지 의료기관 ○ 선정위원회 평가 선정', NULL
FROM policy p WHERE p.canonical_slug = 'national-automatic-childcare-subsidy'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'api_gov24', 'https://www.gov.kr/portal/rcvfvrSvc/dtlEx/SD0000016200'
FROM policy p WHERE p.canonical_slug = 'national-automatic-childcare-subsidy'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #112 요양기관 외 출산 시 출산비 지급
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'national-multi-child-special-supply', '요양기관 외 출산 시 출산비 지급', '가입자 또는 피부양자가 긴급 기타 부득이한 사유로 요양기관 외의 장소에서 질병․부상․출산 등에 대하여 요양을 받는 경우에 그에 상당하는 금액을 사후에 보상하는 현금급여서비스', '출산일로부터 3년 이내에 건강보험공단 지사에 구비 서류를 제출, 신청하면 25만원을 출산비로 지급', '국민건강보험공단 고객센터 / 1577-1000',
  (SELECT id FROM category WHERE code = 'service'), 'one_time',
  250000, 250000, '출산일로부터 3년 이내에 건강보험공단 지사에 구비 서류를 제출, 신청하면 25만원을 출산비로 지급', NULL,
  '방문:국민건강보험공단 지사|전화:국민건강보험공단 지사 FAX:국민건강보험공단 지사 ○ 이용절차 1) 자격요건 확인 : 건강보험가입자 또는 피부양자, 출산한 지 3년 이내인 가정, 해외출산, 입양 자녀 제외 2) 국민건강보험공단에 신청 : 필요한 서류를 작성하여 국민건강보험공단 지사에 방문 또는 우편이나 팩스로 관련 서류 제출 3) 출산비 지급 : 지급대상이며 신청이 완료되었을 경우 25만원의 출산비를 지급 받음', ARRAY['phone', 'visit'],
  '접수기관 별 상이', NULL, 'none',
  NULL, 'https://www.gov.kr/portal/rcvfvrSvc/dtlEx/PTR000050397',
  'unrated', 'needs_review', 'active',
  NULL
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'national-multi-child-special-supply' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'national-multi-child-special-supply' AND ls.code = 'child_3y_plus'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;
INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'national-multi-child-special-supply' AND ls.code = 'post_birth_60d'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'none', NULL, FALSE,
  NULL, NULL,
  '병, 의원이나 조산원이 아닌 곳(가정, 특정 장소)에서 출산한 자', NULL
FROM policy p WHERE p.canonical_slug = 'national-multi-child-special-supply'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'api_gov24', 'https://www.gov.kr/portal/rcvfvrSvc/dtlEx/PTR000050397'
FROM policy p WHERE p.canonical_slug = 'national-multi-child-special-supply'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #113 육아기 근로시간 단축 급여
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'national-newlywed-housing-special-supply', '육아기 근로시간 단축 급여', '육아기에 근로시간을 단축하여 근무하는 경우 급여를 지원하여 출산육아기 근로자의 경력단절을 방지하고 일과 가정의 양립을 지원', '- 육아기 근로시간 단축
- 만 12세 이하 또는 초등학교 6학년 이하의 자녀를 양육하기 위하여 신청하는 경우 1년간(육아휴직 미사용 기간 2배 가산 시 최대 3년간) 주당 15~35시간으로 근로시간 단축 가능 * ''25.2.23.부터 대상자녀 연령 및 사용기간 확대
- 대상자녀 연령: 만 8세 이하 또는 초등학교 2학년 이하 → 만 12세 이하 또는 초등학교 6학년 이하
- 사용기간: 최대 2년(육아휴직 미사용 기간 가산 시) → 최대 3년(육아휴직 미사용 기간 2배 가산 시) ○ 육아기 근로시간 단축 급여
- 근로시간 단축에 따른 임금감소분 일부(단축 개시일 기…', '고용노동부 고객상담센터 / 1350',
  (SELECT id FROM category WHERE code = 'service'), 'one_time',
  NULL, NULL, '- 육아기 근로시간 단축
- 만 12세 이하 또는 초등학교 6학년 이하의 자녀를 양육하기 위하여 신청하는 경우 1년간(육아휴직 미사용 기간 2배 가산 시 최대 3년간) 주당 15~35시간으로 근로시간 단축 가능 * ''25.2.23.부터 대상자녀 연령 및 사용기간 확대
- 대상자녀 연령: 만 8세 이하 또는 초등학교 2학년 이하 → 만 12세 이하 또는 초등학교 6학년 이하
- 사용기간: 최대 2년(육아휴직 미사용 기간 가산 시) → 최대 3년(육아휴직 미사용 기간 2배 가산 시) ○ 육아기 근로시간 단축 급여
- 근로시간 단축에 따른 임금감소분 일부(단축 개시일 기…', NULL,
  '가까운 관할 고용센터를 방문하거나 온라인(고용24 홈페이지: www.work24.go.kr) 또는 우편으로 신청', ARRAY['online', 'visit'],
  '육아기 근로시간 단축을 시작한 날 이후 1개월부터 끝난 날 이후 12개월 이내에 신청', 360, 'none',
  NULL, 'https://www.gov.kr/portal/rcvfvrSvc/dtlEx/999000000007',
  'unrated', 'needs_review', 'active',
  '[현민] 단축 시간에 대한 임금 보전이 강화됨'
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'national-newlywed-housing-special-supply' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'national-newlywed-housing-special-supply' AND ls.code = 'child_3y_plus'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;
INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'national-newlywed-housing-special-supply' AND ls.code = 'post_birth_60d'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'none', NULL, FALSE,
  1, 144,
  '- 「남녀고용평등과 일ㆍ가정 양립 지원에 관한 법률」 제19조의2에 따른 육아기 근로시간 단축을 30일 이상 실시
- 육아기 근로시간 단축을 시작한 날 이전에 고용보험 피보험 단위기간이 합산하여 180일 이상
- 육아기 근로시간 단축을 시작한 날 이후 1개월부터 끝난 날 이후 12개월 이내에 신청', NULL
FROM policy p WHERE p.canonical_slug = 'national-newlywed-housing-special-supply'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'api_gov24', 'https://www.gov.kr/portal/rcvfvrSvc/dtlEx/999000000007'
FROM policy p WHERE p.canonical_slug = 'national-newlywed-housing-special-supply'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #114 출산 관련 서비스 통합처리 신청(행복출산)
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'national-infant-0-1-daycare-subsidy', '출산 관련 서비스 통합처리 신청(행복출산)', '출산 후 받을 수 있는 각종 출산지원 서비스를 한 번에 통합신청하는 서비스를 제공하여 출산가정에 서비스 이용 편의 제고', '공통서비스 : 첫만남이용권, 부모급여(현금), 양육수당, 아동수당, 해산급여, 여성장애인 출산비용, 출산가구·다자녀 전기료 경감, 다자녀 도시가스료 경감, 다자녀 지역난방비 경감, 저소득층 기저귀·조제분유 지원, KTX·SRT다자녀할인 ○ 지자체 서비스 : 지자체별 상이', '- 온라인신청(정부24)문의 / 1588-2188
- 온라인신청(정부24)문의: 02-3703-2500
- 민원 문의 / 110',
  (SELECT id FROM category WHERE code = 'service'), 'one_time',
  NULL, NULL, '공통서비스 : 첫만남이용권, 부모급여(현금), 양육수당, 아동수당, 해산급여, 여성장애인 출산비용, 출산가구·다자녀 전기료 경감, 다자녀 도시가스료 경감, 다자녀 지역난방비 경감, 저소득층 기저귀·조제분유 지원, KTX·SRT다자녀할인 ○ 지자체 서비스 : 지자체별 상이', NULL,
  '- 방문 신청 : 출생신고 시 또는 출생신고 이후, 출생자의 주민등록 주소지 읍면동 주민센터 (단, 해산급여의 경우 출산자의 주민등록 주소지에서 신청) ○ 온라인 신청 : 정부24(www.gov.kr) 접속 ○ 신청자격
- 출산자(산모) 본인, 출산자의 배우자
- (대리인) 출산자(산모)의 직계가족(친부모 및 시부모)만 신청 가능 * 대리신청은 방문신청만 가능', ARRAY['online', 'visit'],
  '출생신고 시 또는 출생신고 이후(※ 개별 서비스별 신청 기간은 "지원대상" 참조)', NULL, 'none',
  NULL, 'https://www.gov.kr/portal/rcvfvrSvc/dtlEx/174000000029',
  'unrated', 'needs_review', 'active',
  '[현민] ⭐ 출생신고 한 번에 첫만남이용권·부모급여·아동수당·전기료 감면 등 동시 신청 가능 (몰라서 따로 다시 가는 경우 많음)'
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'national-infant-0-1-daycare-subsidy' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'national-infant-0-1-daycare-subsidy' AND ls.code = 'child_3y_plus'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;
INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'national-infant-0-1-daycare-subsidy' AND ls.code = 'infant_0_36m'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;
INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'national-infant-0-1-daycare-subsidy' AND ls.code = 'post_birth_60d'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'recipient_required', NULL, TRUE,
  NULL, 299,
  '- 신청일 기준 출산자(출산가정) * 출생신고 시 또는 출생신고 이후 신청가능(출생자 주민등록번호 부여 후, 등록 처리 가능)
※ 개별 서비스별 예외사항 및 신청가능기간(개별신청은 담당기관 문의) ○ 부모급여, 아동수당, 양육수당, 기저귀·조제분유지원 : 출생 후 60일까지 신청시 소급지원 가능 ○ 다자녀 KTX·SRT 열차 운임 할인 : 만25세 미만 자녀 2명 이상일 경우 신청 가능', '수급자/차상위/저소득'
FROM policy p WHERE p.canonical_slug = 'national-infant-0-1-daycare-subsidy'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);

INSERT INTO policy_household_type (policy_id, household_type_id, requirement_type)
SELECT p.id, ht.id, 'required'
FROM policy p, household_type ht
WHERE p.canonical_slug = 'national-infant-0-1-daycare-subsidy' AND ht.code = 'multi_child'
ON CONFLICT (policy_id, household_type_id) DO NOTHING;

INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'api_gov24', 'https://www.gov.kr/portal/rcvfvrSvc/dtlEx/174000000029'
FROM policy p WHERE p.canonical_slug = 'national-infant-0-1-daycare-subsidy'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #115 출산육아기 고용안정장려금
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'national-free-daycare-subsidy', '출산육아기 고용안정장려금', '출산전후휴가, 유산·사산 휴가, 육아휴직, 육아기 근로시간 단축 등을 부여(허용)한 사업주에게 장려금, 대체인력 인건비 등을 지원합니다.', '- 육아휴직 지원금
- 근로자에게 육아휴직을 30일 이상 허용한 우선지원대상기업 사업주에게 휴직 근로자 1인당 월 30만원 지원
※ 특례 적용: 만 12개월 이내 자녀 대상 육아휴직을 3개월 이상 연속 허용한 경우 첫 3개월에 대해 월 200만원 지원(육아휴직지원금 특례를 지원받은 경우, 육아휴직 대체인력지원금 전체 기간에 대한 지원 제한)
※ 남성 육아휴직 인센티브: 남성 근로자의 육아휴직 사용 이력이 없던 우선지원대상기업이 남성 육아휴직을 처음 허용한 세 번째 사례까지 월 10만원 추가 지원 ○ 육아기 근로시간 단축 지원금
- 근로자에게 육아기 근로시간 단축을…', '고용노동부 고객상담센터 / 1350',
  (SELECT id FROM category WHERE code = 'service'), 'monthly',
  100000, 2000000, '- 육아휴직 지원금
- 근로자에게 육아휴직을 30일 이상 허용한 우선지원대상기업 사업주에게 휴직 근로자 1인당 월 30만원 지원
※ 특례 적용: 만 12개월 이내 자녀 대상 육아휴직을 3개월 이상 연속 허용한 경우 첫 3개월에 대해 월 200만원 지원(육아휴직지원금 특례를 지원받은 경우, 육아휴직 대체인력지원금 전체 기간에 대한 지원 제한)
※ 남성 육아휴직 인센티브: 남성 근로자의 육아휴직 사용 이력이 없던 우선지원대상기업이 남성 육아휴직을 처음 허용한 세 번째 사례까지 월 10만원 추가 지원 ○ 육아기 근로시간 단축 지원금
- 근로자에게 육아기 근로시간 단축을…', NULL,
  '고용센터 방문, 우편, 인터넷(고용24 홈페이지: www.work24.go.kr)', ARRAY['online', 'visit'],
  '육아휴직 등 고용안정 조치의 종료일로부터 12개월 이내 신청', 360, 'none',
  NULL, 'https://www.bokjiro.go.kr/ssis-tbu/twataa/wlfareInfo/moveTWAT52011M.do?wlfareInfoId=WLF00003224&wlfareInfoReldBztpCd=01',
  'unrated', 'needs_review', 'active',
  NULL
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'national-free-daycare-subsidy' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'national-free-daycare-subsidy' AND ls.code = 'post_birth_60d'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'none', NULL, FALSE,
  1, NULL,
  '육아휴직 지원금: 근로자에게 「남녀고용평등과 일ㆍ가정 양립 지원에 관한 법률」 제19조에 따른 육아휴직을 30일 이상 허용한 우선지원대상기업의 사업주 ○ 육아기 근로시간 단축 지원금: 근로자에게 「남녀고용평등과 일ㆍ가정 양립 지원에 관한 법률」 제19조의2에 따른 육아기 근로시간 단축을 30일 이상 허용한 우선지원대상기업의 사업주 ○ 대체인력 지원금: 근로자에게 「근로기준법」 제74조제1항에 따른 출산전후휴가, 「근로기준법」 제74조제3항에 따른 유산ㆍ사산…', NULL
FROM policy p WHERE p.canonical_slug = 'national-free-daycare-subsidy'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'api_central_welfare', 'https://www.bokjiro.go.kr/ssis-tbu/twataa/wlfareInfo/moveTWAT52011M.do?wlfareInfoId=WLF00003224&wlfareInfoReldBztpCd=01'
FROM policy p WHERE p.canonical_slug = 'national-free-daycare-subsidy'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #116 가정양육수당 지원사업
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'national-multi-child-utility-discount', '가정양육수당 지원사업', '가정에서 아이를 돌보는 가정 양육 시, 부모의 자녀 양육에 대한 부담을 줄이고 보육 서비스에 대한 선택권을 보장합니다.', '어린이집·유치원·종일제 아이돌봄서비스 미이용 시 24개월~86개월 미만 아동 월 10만원. 농어촌·장애아동은 별도 단가', '보건복지부 보육정책과',
  (SELECT id FROM category WHERE code = 'cash'), 'monthly',
  100000, 100000, '어린이집·유치원·종일제 아이돌봄서비스 미이용 시 24개월~86개월 미만 아동 월 10만원. 농어촌·장애아동은 별도 단가', NULL,
  '읍면동 행정복지센터 방문|복지로 온라인|정부24 온라인', ARRAY['online', 'visit'],
  '어린이집·유치원 미이용 가정에 한해 월 10만원', NULL, 'none',
  '신분증, 통장사본', 'https://www.bokjiro.go.kr/ssis-tbu/twataa/wlfareInfo/moveTWAT52011M.do?wlfareInfoId=WLF00003253',
  'high', 'needs_review', 'active',
  '[이호] 0~23개월 구간은 부모급여(0세 100만/1세 50만)로 통합. 가정양육수당은 24개월~86개월 미만 구간 월 10만원'
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'national-multi-child-utility-discount' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'national-multi-child-utility-discount' AND ls.code = 'infant_0_36m'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'requires_review', NULL, FALSE,
  24, 86,
  '- 어린이집, 유치원(특수학교 포함), 종일제 아이돌봄서비스 등을 이용하지 않는 취학 전 24개월~86개월 미만 가정양육 영유아
※ 부모급여 도입에 따라 0~23개월은 부모급여 지원, 24개월부터 가정양육수당 지원 ○ 소득 인정액 기준 없음 ○ 중복불가서비스 : 유아학비(누리과정) 지원, 영유아보육료 지원', '소득 조건 확인 필요'
FROM policy p WHERE p.canonical_slug = 'national-multi-child-utility-discount'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'api_central_welfare', 'https://www.bokjiro.go.kr/ssis-tbu/twataa/wlfareInfo/moveTWAT52011M.do?wlfareInfoId=WLF00003253'
FROM policy p WHERE p.canonical_slug = 'national-multi-child-utility-discount'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #117 난임부부 시술비 지원
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'national-multi-child-auto-insurance', '난임부부 시술비 지원', '자궁내 정자주입[인공수정] 및 체외수정(신선배아, 동결배아) 시술과 같은 국민건강보험 급여가 적용된 보조생식술을 받는 난임부부에게 본인부담 및 비급여 3종(배아동결비, 유산방지제, 착상보조제) 비용 일부를 보충적으로 지원하여 경제적 부담을 경감', '체외수정·인공수정 시술비 일부·전액본인부담금, 비급여 3종(배아동결비·유산방지제·착상보조제), 냉동난자 해동비 지원. 2026년부터 소득기준 폐지·출산당 25회 지원', '보건복지부 / 시군구 보건소',
  (SELECT id FROM category WHERE code = 'cash'), 'one_time',
  NULL, NULL, '체외수정·인공수정 시술비 일부·전액본인부담금, 비급여 3종(배아동결비·유산방지제·착상보조제), 냉동난자 해동비 지원. 2026년부터 소득기준 폐지·출산당 25회 지원', NULL,
  '관할 보건소 방문|정부24 온라인|e보건소 공공보건포털', ARRAY['online', 'visit'],
  '시술 시작 전 미리 보건소 신청 필요', NULL, 'none',
  '난임진단서, 부부 모두의 신분증·혼인관계증명서(사실혼 포함), 건강보험증', 'https://www.gov.kr/mw/AA020InfoCappView.do?CappBizCD=14600000394',
  'high', 'verified', 'active',
  '[이호] 2024-11-01 이후 시술분부터 출산당 25회 리셋 적용. 2026년 소득기준 전면 폐지'
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'national-multi-child-auto-insurance' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'national-multi-child-auto-insurance' AND ls.code = 'pregnancy_prep'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'health_insurance_based', NULL, FALSE,
  NULL, NULL,
  '- 지원신청 자격
- 난임시술을 요하는 의사의 ''난임진단서'' 제출자
- 법적 혼인상태에 있거나, 신청일 기준 최근 1년 이상 사실상 혼인관계를 유지하였다고 관할 보건소로부터 확인된 난임부부
- 부부 중 최소한 한 명은 주민등록이 되어 있는 대한민국 국적 소유자(주민등록 말소자, 재외국민 주민등록자는 대상에서 제외)이면서, 부부 모두 건강보험 가입 및 보험료 고지 여부가 확인되는 자', 'none (2026년 소득기준 전면 폐지)'
FROM policy p WHERE p.canonical_slug = 'national-multi-child-auto-insurance'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'api_gov24', 'https://www.gov.kr/mw/AA020InfoCappView.do?CappBizCD=14600000394'
FROM policy p WHERE p.canonical_slug = 'national-multi-child-auto-insurance'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #118 배우자 출산휴가 급여
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'national-newborn-supply-package', '배우자 출산휴가 급여', '배우자 출산휴가를 사용한 남성 근로자에게 급여를 지원함으로써 남성의 육아 참여 활성화와 모성보호 도모', '배우자 출산휴가 20일 유급. 2026년 상한액 1,684,210원 (통상임금 수준). 우선지원대상기업(중소기업) 근로자 우선 지원', '고용노동부 고용보험과',
  (SELECT id FROM category WHERE code = 'cash'), 'one_time',
  1684210, 1684210, '배우자 출산휴가 20일 유급. 2026년 상한액 1,684,210원 (통상임금 수준). 우선지원대상기업(중소기업) 근로자 우선 지원', NULL,
  '고용24 ei.go.kr 온라인|관할 고용센터', ARRAY['online'],
  '배우자 출산일로부터 120일 안에 휴가 사용 — 3회 나눠 쓸 수 있음', NULL, 'none',
  '배우자출산휴가 확인서, 출생증명서, 통장사본', 'https://m.work24.go.kr/cm/c/f/1100/selecSystInfo.do?currentPageNo=1&recordCountPerPage=10&systClId=SC00000247&systId=SI00000395',
  'high', 'verified', 'active',
  '[이호] 2025-02-23 시행으로 10일→20일 확대. 청구시점 90일→120일 확대, 1회→3회 분할 가능'
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'national-newborn-supply-package' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'national-newborn-supply-package' AND ls.code = 'post_birth_60d'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'none', NULL, FALSE,
  0, 4,
  '- 「남녀고용평등과 일ㆍ가정 양립 지원에 관한 법률」 제18조의2에 따른 배우자 출산휴가를 받은 우선지원대상기업 소속 근로자
- 휴가가 끝난 날 이전에 고용보험 피보험 단위기간이 합산하여 180일 이상
- 휴가가 끝난 날 이후 12개월 이내에 신청', '고용보험 피보험단위기간 180일 이상'
FROM policy p WHERE p.canonical_slug = 'national-newborn-supply-package'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'manual', 'https://m.work24.go.kr/cm/c/f/1100/selecSystInfo.do?currentPageNo=1&recordCountPerPage=10&systClId=SC00000247&systId=SI00000395'
FROM policy p WHERE p.canonical_slug = 'national-newborn-supply-package'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #119 부모급여 지원
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'national-child-dental-sealant', '부모급여 지원', '영아기 집중돌봄을 두텁게 지원하여 출산 및 양육으로 인한 경제적 부담을 줄여드립니다.', '0세(0~11개월) 월 100만원, 1세(12~23개월) 월 50만원. 어린이집 이용 시 보육료 바우처를 우선 지급하고 차액을 현금 지급', '보건복지부 인구아동정책관실 (실제 지급: 시군구·읍면동)',
  (SELECT id FROM category WHERE code = 'cash'), 'monthly',
  500000, 1000000, '0세(0~11개월) 월 100만원, 1세(12~23개월) 월 50만원. 어린이집 이용 시 보육료 바우처를 우선 지급하고 차액을 현금 지급', NULL,
  '읍면동 행정복지센터 방문|복지로 온라인|정부24 온라인|출생신고 시 행복출산 원스톱', ARRAY['online', 'visit'],
  '출생 후 60일 안에 신청하지 않으면 출생월 소급분을 못 받음', NULL, 'none',
  '신분증, 통장사본 (행복출산 원스톱 이용 시 추가 서류 최소화)', 'https://www.bokjiro.go.kr/ssis-tbu/twataa/wlfareInfo/moveTWAT52011M.do?wlfareInfoId=WLF00004657',
  'high', 'needs_review', 'active',
  '[현민] 어린이집 이용 시 보육료와의 차액 지급 (소득 무관)
[이호] 2024~2025 기준 0세 100만/1세 50만 유지. 2026년 동일 금액으로 시행. 어린이집 이용 시 영유아보육료(0세 약 51만원, 1세 약 45만원)를 차감한 차액을 현금 지급'
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'national-child-dental-sealant' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'national-child-dental-sealant' AND ls.code = 'infant_0_36m'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;
INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'national-child-dental-sealant' AND ls.code = 'post_birth_60d'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'none', NULL, FALSE,
  0, 23,
  '0~23개월 영아를 양육하는 가정', NULL
FROM policy p WHERE p.canonical_slug = 'national-child-dental-sealant'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'api_central_welfare', 'https://www.bokjiro.go.kr/ssis-tbu/twataa/wlfareInfo/moveTWAT52011M.do?wlfareInfoId=WLF00004657'
FROM policy p WHERE p.canonical_slug = 'national-child-dental-sealant'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #120 아동수당
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'national-fluoride-varnish', '아동수당', '아동에게 아동수당을 지급하여 아동 양육에 따른 경제적 부담을 경감하고 건강한 성장환경을 조성함으로써 아동의 기본적 권리와 복지 증진에 기여', '만 9세 미만 아동 월 10만원 (2026년 3월 만 8세→9세 미만으로 확대). 비수도권·인구감소지역 거주 시 5천원~2만원 추가 가산', '보건복지부 인구아동정책관실 아동복지정책과',
  (SELECT id FROM category WHERE code = 'cash'), 'monthly',
  20000, 100000, '만 9세 미만 아동 월 10만원 (2026년 3월 만 8세→9세 미만으로 확대). 비수도권·인구감소지역 거주 시 5천원~2만원 추가 가산', NULL,
  '읍면동 행정복지센터 방문|복지로 온라인|정부24 온라인|행복출산 원스톱', ARRAY['online', 'visit'],
  '출생 후 60일 안에 신청하지 않으면 출생월 소급분을 못 받음', NULL, 'none',
  '신분증, 통장사본', 'https://www.bokjiro.go.kr/ssis-tbu/twataa/wlfareInfo/moveTWAT52011M.do?wlfareInfoId=WLF00001171',
  'high', 'verified', 'active',
  '[현민] 2026년부터 비수도권·인구감소지역은 추가 지급
[이호] 2026-03-20 아동수당법 개정 — 만 8세 미만→9세 미만 확대(2017~2018.3월생 추가 43만명). 기존 수급자는 자동지급, 중단되었던 아동은 1~3월분 소급'
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'national-fluoride-varnish' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'national-fluoride-varnish' AND ls.code = 'infant_0_36m'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;
INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'national-fluoride-varnish' AND ls.code = 'post_birth_60d'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'none', NULL, FALSE,
  0, 107,
  '- 만 8세 미만 모든 아동에게 아동수당을 지급
- 대한민국 국적을 보유한 아동 ㆍ 부모가 외국인이어도 아동이 한국 국적이면 요건 충족 ㆍ 국적법에 따른 복수국적자 포함 ㆍ 난민법에 따른 난민 인정 아동 포함 ㆍ ｢재한외국인처우기본법｣에 따른 특별기여자
- 주민등록법에 의한 주민등록번호가 정상적으로 부여된 아동 ㆍ 사회복지 전산관리번호(의료급여 전산관리번호) 부여 대상자 포함 ㆍ 주민등록법에 따른 거주 불명자 중 실제 거주지가 확인되는 자 포함', NULL
FROM policy p WHERE p.canonical_slug = 'national-fluoride-varnish'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'api_central_welfare', 'https://www.bokjiro.go.kr/ssis-tbu/twataa/wlfareInfo/moveTWAT52011M.do?wlfareInfoId=WLF00001171'
FROM policy p WHERE p.canonical_slug = 'national-fluoride-varnish'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #121 육아휴직급여
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'national-infant-dental-checkup', '육아휴직급여', '육아휴직급여 지급을 통한 가정과 직장의 양립지원으로 근로자의 고용안정과 경제활동 참가율 제고 도모', '1~3개월 월 최대 250만원(통상임금 100%), 4~6개월 200만원(통상임금 100%), 7~12개월 160만원(통상임금 80%). 6+6 부모육아휴직제: 자녀 출산 18개월 내 부모 모두 사용 시 첫 6개월 각각 통상임금 100%(부부합산 첫 달 최대 450만원). 사후지급금 25% 제도 폐지', '고용노동부 고용보험과',
  (SELECT id FROM category WHERE code = 'cash'), 'monthly',
  1600000, 4500000, '1~3개월 월 최대 250만원(통상임금 100%), 4~6개월 200만원(통상임금 100%), 7~12개월 160만원(통상임금 80%). 6+6 부모육아휴직제: 자녀 출산 18개월 내 부모 모두 사용 시 첫 6개월 각각 통상임금 100%(부부합산 첫 달 최대 450만원). 사후지급금 25% 제도 폐지', NULL,
  '고용24 ei.go.kr 온라인|관할 고용센터 방문', ARRAY['online', 'visit'],
  '휴직 시작일부터 매달 신청. 휴직 종료 후 12개월 안에 마무리', NULL, 'none',
  '육아휴직 확인서, 통상임금 확인 자료, 자녀 가족관계증명서', 'https://m.work24.go.kr/cm/c/f/1100/selecSystInfo.do?systClId=SC00000251&systId=SI00000402',
  'high', 'needs_review', 'active',
  '[이호] 2026 주요 변경: ①1~3개월 250만원으로 인상 ②6+6 부모육아휴직제로 첫 6개월 부부합산 최대 450만원 ③사후지급금 25% 제도 폐지'
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'national-infant-dental-checkup' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'national-infant-dental-checkup' AND ls.code = 'infant_0_36m'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;
INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'national-infant-dental-checkup' AND ls.code = 'post_birth_60d'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'none', NULL, FALSE,
  0, 96,
  '- 육아휴직 급여
- 남녀고용평등법상에 따른 육아휴직을 30일 이상 부여 받은 근로자
- 피보험 단위기간이 180일(과거에 실업급여를 받았을 경우 인정받았던 피보험 기간은 제외) 이상
- 육아휴직을 시작한 날 이후 1개월부터 끝난 날 이후 12개월 이내에 신청', '고용보험 가입 근로자 (피보험단위기간 180일 이상)'
FROM policy p WHERE p.canonical_slug = 'national-infant-dental-checkup'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'manual', 'https://m.work24.go.kr/cm/c/f/1100/selecSystInfo.do?systClId=SC00000251&systId=SI00000402'
FROM policy p WHERE p.canonical_slug = 'national-infant-dental-checkup'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

-- #122 한부모가족 아동양육비 (지원 확대 + 청년한부모 인상)
INSERT INTO policy (
  canonical_slug, title, summary, description, organization,
  category_id, support_cycle,
  amount_min, amount_max, amount_text, amount_breakdown,
  application_method_text, application_channel,
  application_deadline_text, application_deadline_days, application_deadline_anchor,
  required_documents_text, detail_url,
  confidence, review_status, service_status,
  parent_friendly_copy
) VALUES (
  'national-newborn-hearing-retest', '한부모가족 아동양육비 (지원 확대 + 청년한부모 인상)', NULL, '일반 한부모 월 23만원 (기준중위소득 65% 이하), 청년한부모(25~34세)·미혼모·부·조손 월 33만원, 학용품비 연 10만원', '여성가족부 가족정책관 가족지원과',
  (SELECT id FROM category WHERE code = 'cash'), 'monthly',
  100000, 330000, '일반 한부모 월 23만원 (기준중위소득 65% 이하), 청년한부모(25~34세)·미혼모·부·조손 월 33만원, 학용품비 연 10만원', NULL,
  '복지로 온라인|동주민센터 방문', ARRAY['online', 'visit'],
  '상시', NULL, 'none',
  '한부모가족증명서, 소득증빙, 가족관계증명서', 'https://www.mogef.go.kr/cs/opf/cs_opf_f921.do',
  'high', 'verified', 'active',
  '[현민] 한부모가족증명서 발급이 필요한 다른 혜택의 출발점
[이호] 2025-09-11 여성가족부 2026 예산안 발표 (총 6,260억원, 전년 +354억원). 기준중위소득 63%→65% 확대로 수혜자 약 1만명 증가. 청년한부모(25~34세) 양육비 28만원→33만원. 학용품비 9.3만→10만원. 시설 입소 가구 생활보조금 5→10만원.'
) ON CONFLICT (canonical_slug) DO UPDATE SET
  title = EXCLUDED.title,
  summary = EXCLUDED.summary,
  description = EXCLUDED.description,
  organization = EXCLUDED.organization,
  amount_min = EXCLUDED.amount_min,
  amount_max = EXCLUDED.amount_max,
  amount_text = EXCLUDED.amount_text,
  amount_breakdown = EXCLUDED.amount_breakdown,
  updated_at = NOW();

INSERT INTO policy_region (policy_id, region_id, scope)
SELECT p.id, r.id, 'national'
FROM policy p, region r
WHERE p.canonical_slug = 'national-newborn-hearing-retest' AND r.code = 'KR'
ON CONFLICT (policy_id, region_id) DO NOTHING;

INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'national-newborn-hearing-retest' AND ls.code = 'infant_0_36m'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;
INSERT INTO policy_life_stage (policy_id, life_stage_id)
SELECT p.id, ls.id
FROM policy p, life_stage ls
WHERE p.canonical_slug = 'national-newborn-hearing-retest' AND ls.code = 'post_birth_60d'
ON CONFLICT (policy_id, life_stage_id) DO NOTHING;

INSERT INTO policy_eligibility (
  policy_id, condition_label,
  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,
  child_age_min_months, child_age_max_months,
  raw_target_text, raw_eligibility_text
) SELECT
  p.id, '기본 조건',
  'median_income_percent', 65, FALSE,
  0, 216,
  'single_parent / 소득: 기준중위소득 65% 이하 (2026년 확대)', '기준중위소득 65% 이하 (2026년 확대)'
FROM policy p WHERE p.canonical_slug = 'national-newborn-hearing-retest'
AND NOT EXISTS (
  SELECT 1 FROM policy_eligibility pe
  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'
);


INSERT INTO policy_source (policy_id, source_type, original_url)
SELECT p.id, 'manual', 'https://www.mogef.go.kr/cs/opf/cs_opf_f921.do'
FROM policy p WHERE p.canonical_slug = 'national-newborn-hearing-retest'
AND NOT EXISTS (
  SELECT 1 FROM policy_source ps
  WHERE ps.policy_id = p.id
);

COMMIT;
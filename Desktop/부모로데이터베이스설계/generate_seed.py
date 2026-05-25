"""
122건 정책 데이터를 읽어 seed_policies.sql을 생성하는 스크립트.
Claude Code에서 직접 실행 — 외부 API 호출 없음.
"""
import json
import re

with open("/tmp/bumoro_122.json") as f:
    records = json.load(f)

# ── 카테고리 매핑 (한글 → ENUM) ──
CATEGORY_MAP = {
    "discount": "discount",
    "info": "information",
    "바우처": "voucher",
    "서비스": "service",
    "현금성": "cash",
    "육아·보육": "childcare",
    "돌봄": "childcare",
    "세제·감면": "tax_benefit",
    # 생애단계로 재분류해야 하는 카테고리
    "임신": "service",
    "임신준비": "service",
    "출산·산후": "service",
    "한부모 한정": "service",
}

# ── 적용범위 → region code + scope ──
SCOPE_MAP = {
    "중앙정부": [("KR", "national")],
    "서울시": [("KR", "national"), ("11", "sido_wide")],
    "동작구": [("KR", "national"), ("11", "sido_wide"), ("11590", "sigungu_specific")],
}

# ── 생애단계 정규화 ──
LIFE_STAGE_NORMALIZE = {
    "pregnancy_prep": ["pregnancy_prep"],
    "pregnancy": ["pregnancy"],
    "post_birth_60d": ["post_birth_60d"],
    "infant_0_36m": ["infant_0_36m"],
    "child_3y_plus": ["child_3y_plus"],
    "영유아": ["infant_0_36m"],
    "아동": ["child_3y_plus"],
    "임신 중": ["pregnancy"],
    "임신 전": ["pregnancy_prep"],
    "출산·산후": ["post_birth_60d"],
    "가족": ["infant_0_36m", "child_3y_plus"],
}


def parse_life_stages(raw):
    if not raw:
        return ["infant_0_36m"]
    stages = set()
    # Split by | , / and Korean separators
    parts = re.split(r"[|,/]", raw.strip())
    for part in parts:
        part = part.strip()
        if part in LIFE_STAGE_NORMALIZE:
            stages.update(LIFE_STAGE_NORMALIZE[part])
        else:
            # Try partial match
            for key, vals in LIFE_STAGE_NORMALIZE.items():
                if key in part:
                    stages.update(vals)
                    break
    if not stages:
        stages.add("infant_0_36m")
    return sorted(stages)


# ── 금액 파싱 ──
def parse_amount(text):
    """Extract amount_min and amount_max from Korean amount text."""
    if not text:
        return None, None, None

    amounts = []
    # Find patterns like "100만원", "1,000원", "200만원"
    # 만원 patterns
    for m in re.finditer(r"(\d[\d,]*(?:\.\d+)?)\s*만\s*원", text):
        val = float(m.group(1).replace(",", "")) * 10000
        amounts.append(int(val))
    # 억원 patterns
    for m in re.finditer(r"(\d[\d,]*(?:\.\d+)?)\s*억\s*원", text):
        val = float(m.group(1).replace(",", "")) * 100000000
        amounts.append(int(val))
    # Plain 원 patterns (but not after 만/억)
    for m in re.finditer(r"(?<!만\s)(?<!억\s)(\d[\d,]+)\s*원(?!/)", text):
        val_str = m.group(1).replace(",", "")
        if len(val_str) >= 3:  # at least 100원
            amounts.append(int(val_str))

    if not amounts:
        return None, None, None

    breakdown = parse_breakdown(text)
    return min(amounts), max(amounts), breakdown


def parse_breakdown(text):
    """Parse birth-order-based differential amounts."""
    if not text:
        return None

    breakdown = []
    # Pattern: "첫째 X만원, 둘째 Y만원, ..."
    orders = {"첫째": 1, "둘째": 2, "셋째": 3, "넷째": 4, "다섯째": 5}
    for label, order in orders.items():
        pattern = rf"{label}[아]?\s*(\d[\d,]*(?:\.\d+)?)\s*만\s*원"
        m = re.search(pattern, text)
        if m:
            amt = int(float(m.group(1).replace(",", "")) * 10000)
            breakdown.append({"birth_order": order, "amount": amt})

    # "넷째 이상" pattern
    m = re.search(r"넷째\s*이상\s*(\d[\d,]*(?:\.\d+)?)\s*만\s*원", text)
    if m:
        amt = int(float(m.group(1).replace(",", "")) * 10000)
        # Replace or add 4+
        breakdown = [b for b in breakdown if b["birth_order"] != 4]
        breakdown.append({"birth_order": "4+", "amount": amt})

    # "셋째 이상" pattern
    m = re.search(r"셋째\s*이상\s*(\d[\d,]*(?:\.\d+)?)\s*만\s*원", text)
    if m:
        amt = int(float(m.group(1).replace(",", "")) * 10000)
        breakdown = [b for b in breakdown if b["birth_order"] != 3]
        breakdown.append({"birth_order": "3+", "amount": amt})

    if len(breakdown) >= 2:
        return breakdown
    return None


def parse_deadline(text):
    """Parse deadline text to days + anchor."""
    if not text:
        return None, None, "none"

    text_lower = text.strip()

    # Days patterns
    m = re.search(r"(\d+)\s*일\s*이내", text_lower)
    if m:
        days = int(m.group(1))
        anchor = "birth" if "출" in text_lower else "none"
        return days, anchor, text_lower

    # Months patterns
    m = re.search(r"(\d+)\s*개월\s*이내", text_lower)
    if m:
        days = int(m.group(1)) * 30
        anchor = "birth" if "출" in text_lower or "분만" in text_lower else "none"
        return days, anchor, text_lower

    # Year patterns
    m = re.search(r"(\d+)\s*년\s*(?:이내|안에)", text_lower)
    if m:
        days = int(m.group(1)) * 365
        anchor = "birth" if "출" in text_lower else "none"
        return days, anchor, text_lower

    # "출산 후 X개월"
    m = re.search(r"출산\s*후\s*(\d+)\s*개월", text_lower)
    if m:
        return int(m.group(1)) * 30, "birth", text_lower

    # "출생신고일로부터 1년"
    if "출생신고" in text_lower and "년" in text_lower:
        m = re.search(r"(\d+)\s*년", text_lower)
        if m:
            return int(m.group(1)) * 365, "birth", text_lower

    # "마감 없음" or "상시"
    if "마감 없음" in text_lower or "상시" in text_lower or "연중" in text_lower:
        return None, "none", text_lower

    return None, "none", text_lower


def parse_income(text, target_text=None):
    """Parse income criteria."""
    if not text and not target_text:
        return "none", None, False

    combined = (text or "") + " " + (target_text or "")

    if "소득 조건 확인 필요" in combined or "미확인" in combined:
        return "requires_review", None, False

    if "수급자" in combined or "차상위" in combined or "기초생활" in combined:
        if "중위소득" in combined:
            m = re.search(r"중위소득\s*(\d+)\s*%", combined)
            if m:
                return "median_income_percent", int(m.group(1)), True
        return "recipient_required", None, True

    if "건강보험료" in combined or "건강보험" in combined:
        return "health_insurance_based", None, False

    m = re.search(r"(?:기준\s*)?중위소득\s*(\d+)\s*%", combined)
    if m:
        return "median_income_percent", int(m.group(1)), False

    if "none" in combined.lower() or "소득 무관" in combined or "소득기준 폐지" in combined:
        return "none", None, False

    return "none", None, False


def parse_household_types(target_text):
    """Extract household types from target text."""
    if not target_text:
        return []
    types = []
    mapping = {
        "multi_child": ["다자녀", "다둥이", "다자녀 가구"],
        "single_parent": ["한부모", "미혼모"],
        "multicultural": ["다문화"],
        "disabled": ["장애인", "장애"],
        "basic_livelihood": ["기초생활", "수급자"],
        "near_poverty": ["차상위"],
        "teen_mom": ["청소년 산모", "청소년산모", "19세 이하"],
        "newlywed": ["신혼부부", "신혼"],
        "youth": ["청년 부부", "청년"],
    }
    for code, keywords in mapping.items():
        for kw in keywords:
            if kw in target_text:
                types.append(code)
                break
    return types


def parse_support_cycle(text):
    """Infer support cycle from amount text."""
    if not text:
        return "one_time"
    if "월" in text and ("만원" in text or "원" in text):
        if "1회" in text or "일시" in text:
            return "one_time"
        return "monthly"
    if "연" in text and "만원" in text:
        return "yearly"
    if "시간당" in text or "회당" in text:
        return "per_visit"
    if "1회" in text or "일시" in text or "총" in text:
        return "one_time"
    return "one_time"


def parse_channels(text):
    """Parse application channels."""
    if not text:
        return None
    channels = set()
    if "온라인" in text or "홈페이지" in text or "누리집" in text or "앱" in text:
        channels.add("online")
    if "주민센터" in text or "방문" in text or "보건소" in text or "동주민센터" in text:
        channels.add("visit")
    if "전화" in text or "문의" in text:
        channels.add("phone")
    if not channels:
        return None
    return sorted(channels)


def sql_str(val):
    """Escape a string for SQL."""
    if val is None:
        return "NULL"
    s = str(val).replace("'", "''")
    return f"'{s}'"


def sql_int(val):
    if val is None:
        return "NULL"
    try:
        return str(int(val))
    except (ValueError, TypeError):
        return "NULL"


def sql_arr(vals):
    """PostgreSQL text array."""
    if not vals:
        return "NULL"
    items = ", ".join(f"'{v}'" for v in vals)
    return f"ARRAY[{items}]"


def sql_jsonb(obj):
    if obj is None:
        return "NULL"
    return f"'{json.dumps(obj, ensure_ascii=False)}'::jsonb"


# ══════════════════════════════════════════════════
# canonical_slug 매핑 (122건 수동 매핑)
# ══════════════════════════════════════════════════

SLUG_MAP = {
    1: "dongjak-multi-child-happy-card",
    2: "dongjak-multi-child-parking-discount",
    3: "dongjak-youth-newlywed-housing",
    4: "dongjak-kids-cafe-free",
    5: "dongjak-newborn-health-insurance",
    6: "dongjak-care-mom",
    7: "dongjak-prenatal-care-package",
    8: "dongjak-baby-bookstart",
    9: "dongjak-teen-mom-medical",
    10: "dongjak-birth-celebration-gift",
    11: "dongjak-eco-food-package",
    12: "dongjak-prenatal-helper",
    13: "dongjak-high-risk-pregnancy-medical",
    14: "dongjak-100day-celebration-rental",
    15: "dongjak-kids-english-playground",
    16: "dongjak-hepb-perinatal-prevention",
    17: "dongjak-family-center-childcare",
    18: "dongjak-multicultural-childcare-center",
    19: "dongjak-infertility-treatment",
    20: "dongjak-breast-pump-rental",
    21: "dongjak-postpartum-care-voucher",
    22: "dongjak-postpartum-copay-support",
    23: "dongjak-atopic-moisturizer",
    24: "dongjak-hpv-test-support",
    25: "dongjak-preconception-health-check",
    26: "dongjak-pertussis-vaccination",
    27: "dongjak-toy-library",
    28: "dongjak-child-dinner-lunchbox",
    29: "dongjak-premature-baby-medical",
    30: "seoul-herbal-infertility-treatment",
    31: "seoul-baby-first-step-health",
    32: "dongjak-hearing-screening-aid",
    33: "dongjak-metabolic-screening",
    34: "dongjak-child-development-test",
    35: "dongjak-folic-acid-iron-supplement",
    36: "dongjak-vasectomy-reversal-support",
    37: "dongjak-multi-child-property-tax-exemption",
    38: "dongjak-pertussis-vaccination-pregnant",
    39: "dongjak-preconception-health-screening",
    40: "dongjak-disabled-childcare-allowance",
    41: "dongjak-youth-newlywed-rent-support",
    42: "dongjak-birth-celebration-cash",
    43: "dongjak-birth-celebration-cash-gift",
    44: "dongjak-newborn-insurance-premium",
    45: "seoul-multi-child-happy-card",
    46: "seoul-24hr-emergency-childcare",
    47: "seoul-postpartum-copay-voucher",
    48: "seoul-pregnant-transport-subsidy",
    49: "seoul-mom-dad-taxi",
    50: "seoul-housework-service-voucher",
    51: "seoul-postpartum-care-expense",
    52: "seoul-mom-book-support",
    53: "seoul-triplet-celebration-gift",
    54: "seoul-childcare-subsidy",
    55: "seoul-private-daycare-fee-gap",
    56: "seoul-self-employed-maternity-benefit",
    57: "seoul-multiple-birth-insurance",
    58: "seoul-crisis-pregnancy-support",
    59: "seoul-multi-child-sewage-discount",
    60: "seoul-self-employed-paternity-benefit",
    61: "seoul-sme-maternity-leave-benefit",
    62: "seoul-single-parent-dream-box",
    63: "seoul-over35-pregnancy-medical",
    64: "seoul-egg-freezing-support",
    65: "seoul-self-employed-maternity-cash",
    66: "seoul-infertility-treatment",
    67: "seoul-grandparent-childcare-allowance",
    68: "seoul-teen-parent-childcare",
    69: "seoul-newborn-housing-subsidy",
    70: "seoul-single-parent-allowance",
    71: "national-birth-family-electricity-discount",
    72: "national-infertility-validity-extension",
    73: "national-pregnancy-medical-voucher",
    74: "national-diaper-formula-extended",
    75: "national-foreign-child-daycare",
    76: "national-low-income-diaper-formula",
    77: "national-first-meeting-voucher",
    78: "national-child-vaccination",
    79: "national-postpartum-care-service",
    80: "national-childcare-service",
    81: "national-infant-health-checkup",
    82: "national-preconception-health-check",
    83: "national-pension-birth-credit",
    84: "national-child-tax-deduction",
    85: "national-infant-hospital-free",
    86: "national-extended-daycare-fee",
    87: "national-daycare-wood-improvement",
    88: "national-daycare-staff-salary",
    89: "national-hourly-daycare",
    90: "national-child-group-home",
    91: "national-child-meal-management",
    92: "national-daycare-tax-reduction",
    93: "national-early-education-fee",
    94: "national-childcare-allowance",
    95: "national-home-childcare-allowance",
    96: "national-parent-allowance",
    97: "national-infant-daycare-fee",
    98: "national-child-allowance",
    99: "national-maternity-leave-benefit",
    100: "national-parental-leave-benefit",
    101: "national-reduced-hours-benefit",
    102: "national-spouse-maternity-leave-benefit",
    103: "national-work-family-balance-subsidy",
    104: "national-women-scientist-return",
    105: "national-maternal-child-health-book",
    106: "national-pregnant-commute-reduction",
    107: "national-fertility-treatment-leave",
    108: "national-pregnancy-work-protection",
    109: "national-family-care-leave",
    110: "national-child-sick-leave",
    111: "national-automatic-childcare-subsidy",
    112: "national-multi-child-special-supply",
    113: "national-newlywed-housing-special-supply",
    114: "national-infant-0-1-daycare-subsidy",
    115: "national-free-daycare-subsidy",
    116: "national-multi-child-utility-discount",
    117: "national-multi-child-auto-insurance",
    118: "national-newborn-supply-package",
    119: "national-child-dental-sealant",
    120: "national-fluoride-varnish",
    121: "national-infant-dental-checkup",
    122: "national-newborn-hearing-retest",
}

# ══════════════════════════════════════════════════
# SQL 생성
# ══════════════════════════════════════════════════

lines = []
lines.append("-- ============================================================================")
lines.append("-- 부모로 (Bumoro) MVP — 정책 시드 데이터 (122건)")
lines.append("-- 자동 생성: generate_seed.py")
lines.append("-- ============================================================================")
lines.append("")
lines.append("BEGIN;")
lines.append("")

# Policy inserts
for rec in records:
    num = int(rec["번호"])
    slug = SLUG_MAP.get(num)
    if not slug:
        continue

    title = rec["혜택명"]
    summary = rec.get("한줄 요약")
    description = rec.get("지원내용·금액")
    organization = rec.get("주관기관")

    # Category
    raw_cat = rec.get("카테고리", "서비스")
    cat_code = CATEGORY_MAP.get(raw_cat, "service")

    # Support cycle
    cycle = parse_support_cycle(description)

    # Amount
    amt_min, amt_max, breakdown = parse_amount(description)

    # Deadline
    deadline_days, deadline_anchor, _ = parse_deadline(rec.get("신청기한"))

    # Channels
    channels = parse_channels(rec.get("신청방법·채널"))

    # Confidence
    raw_conf = rec.get("신뢰도")
    confidence = raw_conf if raw_conf in ("high", "medium", "low") else "unrated"

    # Review status
    review = "needs_review" if rec.get("검수 상태") else "verified" if confidence == "high" else "needs_review"

    # Detail URL
    detail_url = rec.get("출처 URL")

    lines.append(f"-- #{num} {title}")
    lines.append(f"INSERT INTO policy (")
    lines.append(f"  canonical_slug, title, summary, description, organization,")
    lines.append(f"  category_id, support_cycle,")
    lines.append(f"  amount_min, amount_max, amount_text, amount_breakdown,")
    lines.append(f"  application_method_text, application_channel,")
    lines.append(f"  application_deadline_text, application_deadline_days, application_deadline_anchor,")
    lines.append(f"  required_documents_text, detail_url,")
    lines.append(f"  confidence, review_status, service_status,")
    lines.append(f"  parent_friendly_copy")
    lines.append(f") VALUES (")
    lines.append(f"  {sql_str(slug)}, {sql_str(title)}, {sql_str(summary)}, {sql_str(description)}, {sql_str(organization)},")
    lines.append(f"  (SELECT id FROM category WHERE code = {sql_str(cat_code)}), {sql_str(cycle)},")
    lines.append(f"  {sql_int(amt_min)}, {sql_int(amt_max)}, {sql_str(description)}, {sql_jsonb(breakdown)},")
    lines.append(f"  {sql_str(rec.get('신청방법·채널'))}, {sql_arr(channels)},")
    lines.append(f"  {sql_str(rec.get('신청기한'))}, {sql_int(deadline_days)}, {sql_str(deadline_anchor or 'none')},")
    lines.append(f"  {sql_str(rec.get('필요서류'))}, {sql_str(detail_url)},")
    lines.append(f"  {sql_str(confidence)}, {sql_str(review)}, 'active',")
    lines.append(f"  {sql_str(rec.get('알짜 포인트·메모'))}")
    lines.append(f") ON CONFLICT (canonical_slug) DO UPDATE SET")
    lines.append(f"  title = EXCLUDED.title,")
    lines.append(f"  summary = EXCLUDED.summary,")
    lines.append(f"  description = EXCLUDED.description,")
    lines.append(f"  organization = EXCLUDED.organization,")
    lines.append(f"  amount_min = EXCLUDED.amount_min,")
    lines.append(f"  amount_max = EXCLUDED.amount_max,")
    lines.append(f"  amount_text = EXCLUDED.amount_text,")
    lines.append(f"  amount_breakdown = EXCLUDED.amount_breakdown,")
    lines.append(f"  updated_at = NOW();")
    lines.append("")

    # ── policy_region ──
    scope_key = rec.get("적용범위", "중앙정부")
    regions = SCOPE_MAP.get(scope_key, [("KR", "national")])
    for region_code, scope in regions:
        lines.append(f"INSERT INTO policy_region (policy_id, region_id, scope)")
        lines.append(f"SELECT p.id, r.id, {sql_str(scope)}")
        lines.append(f"FROM policy p, region r")
        lines.append(f"WHERE p.canonical_slug = {sql_str(slug)} AND r.code = {sql_str(region_code)}")
        lines.append(f"ON CONFLICT (policy_id, region_id) DO NOTHING;")
    lines.append("")

    # ── policy_life_stage ──
    stages = parse_life_stages(rec.get("생애단계"))
    for stage in stages:
        lines.append(f"INSERT INTO policy_life_stage (policy_id, life_stage_id)")
        lines.append(f"SELECT p.id, ls.id")
        lines.append(f"FROM policy p, life_stage ls")
        lines.append(f"WHERE p.canonical_slug = {sql_str(slug)} AND ls.code = {sql_str(stage)}")
        lines.append(f"ON CONFLICT (policy_id, life_stage_id) DO NOTHING;")
    lines.append("")

    # ── policy_eligibility ──
    income_type, income_pct, requires_recipient = parse_income(
        rec.get("소득기준"), rec.get("대상·자격 요약")
    )
    child_min = rec.get("대상 월령(최소·개월)")
    child_max = rec.get("대상 월령(최대·개월)")

    lines.append(f"INSERT INTO policy_eligibility (")
    lines.append(f"  policy_id, condition_label,")
    lines.append(f"  income_criteria_type, median_income_threshold_percent, requires_basic_recipient,")
    lines.append(f"  child_age_min_months, child_age_max_months,")
    lines.append(f"  raw_target_text, raw_eligibility_text")
    lines.append(f") SELECT")
    lines.append(f"  p.id, '기본 조건',")
    lines.append(f"  {sql_str(income_type)}, {sql_int(income_pct)}, {str(requires_recipient).upper()},")
    lines.append(f"  {sql_int(child_min)}, {sql_int(child_max)},")
    lines.append(f"  {sql_str(rec.get('대상·자격 요약'))}, {sql_str(rec.get('소득기준'))}")
    lines.append(f"FROM policy p WHERE p.canonical_slug = {sql_str(slug)}")
    lines.append(f"AND NOT EXISTS (")
    lines.append(f"  SELECT 1 FROM policy_eligibility pe")
    lines.append(f"  WHERE pe.policy_id = p.id AND pe.condition_label = '기본 조건'")
    lines.append(f");")
    lines.append("")

    # ── policy_household_type ──
    ht_codes = parse_household_types(rec.get("대상·자격 요약", ""))
    for ht in ht_codes:
        lines.append(f"INSERT INTO policy_household_type (policy_id, household_type_id, requirement_type)")
        lines.append(f"SELECT p.id, ht.id, 'required'")
        lines.append(f"FROM policy p, household_type ht")
        lines.append(f"WHERE p.canonical_slug = {sql_str(slug)} AND ht.code = {sql_str(ht)}")
        lines.append(f"ON CONFLICT (policy_id, household_type_id) DO NOTHING;")
    lines.append("")

    # ── policy_source ──
    source_type = "manual"
    if rec.get("출처 라벨"):
        label = rec["출처 라벨"]
        if "gov24" in label.lower() or "정부24" in label:
            source_type = "api_gov24"
        elif "복지로" in label or "bokjiro" in (rec.get("출처 URL") or ""):
            source_type = "api_central_welfare"
    lines.append(f"INSERT INTO policy_source (policy_id, source_type, original_url)")
    lines.append(f"SELECT p.id, {sql_str(source_type)}, {sql_str(detail_url)}")
    lines.append(f"FROM policy p WHERE p.canonical_slug = {sql_str(slug)}")
    lines.append(f"AND NOT EXISTS (")
    lines.append(f"  SELECT 1 FROM policy_source ps")
    lines.append(f"  WHERE ps.policy_id = p.id")
    lines.append(f");")
    lines.append("")

lines.append("COMMIT;")

output_path = "/Users/hangryongcho/Desktop/부모로데이터베이스설계/seed_policies.sql"
with open(output_path, "w") as f:
    f.write("\n".join(lines))

print(f"생성 완료: {output_path}")
print(f"총 {len([r for r in records if int(r['번호']) in SLUG_MAP])}건 정책 INSERT")
print(f"SQL 라인 수: {len(lines)}")

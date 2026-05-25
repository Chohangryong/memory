"""Bumoro DB migration runner — applies schema/seed to Supabase via Management API."""

from __future__ import annotations

import sys
from pathlib import Path

import httpx
from dotenv import dotenv_values

# ---------------------------------------------------------------------------
# Config
# ---------------------------------------------------------------------------

DIR = Path(__file__).parent
ENV_PATH = DIR / ".env"
SCHEMA_FILE = DIR / "03_schema.sql"
SEED_FILE = DIR / "seed_policies.sql"
TIMEOUT = 120  # seconds

REQUIRED_VARS = ["SUPABASE_ACCESS_TOKEN", "SUPABASE_PROJECT_REF"]


def load_env() -> dict[str, str]:
    if not ENV_PATH.exists():
        print(f"❌ .env not found at {ENV_PATH}")
        sys.exit(1)
    env = dotenv_values(ENV_PATH)
    missing = [k for k in REQUIRED_VARS if not env.get(k)]
    if missing:
        print(f"❌ Missing required env vars: {', '.join(missing)}")
        sys.exit(1)
    return {k: v for k, v in env.items() if v is not None}


def make_headers(token: str) -> dict[str, str]:
    return {
        "Authorization": f"Bearer {token}",
        "Content-Type": "application/json",
    }


def query(sql: str, env: dict[str, str]) -> dict:
    url = f"https://api.supabase.com/v1/projects/{env['SUPABASE_PROJECT_REF']}/database/query"
    resp = httpx.post(
        url,
        headers=make_headers(env["SUPABASE_ACCESS_TOKEN"]),
        json={"query": sql},
        timeout=TIMEOUT,
    )
    if resp.status_code not in (200, 201):
        body = resp.text[:500]
        print(f"❌ API error {resp.status_code}: {body}")
        sys.exit(1)
    return resp.json()


# ---------------------------------------------------------------------------
# Commands
# ---------------------------------------------------------------------------


def cmd_schema(env: dict[str, str]) -> None:
    print("📄 Applying schema (03_schema.sql)…")
    if not SCHEMA_FILE.exists():
        print(f"❌ Schema file not found: {SCHEMA_FILE}")
        sys.exit(1)

    sql = SCHEMA_FILE.read_text(encoding="utf-8")
    result = query(sql, env)

    # Count tables created — ask information_schema
    count_result = query(
        "SELECT COUNT(*) AS cnt FROM information_schema.tables "
        "WHERE table_schema = 'public' AND table_type = 'BASE TABLE';",
        env,
    )
    cnt = count_result[0]["cnt"] if count_result else "?"
    print(f"✅ Schema applied. Public tables in DB: {cnt}")


def cmd_seed(env: dict[str, str]) -> None:
    print("🌱 Applying seed (seed_policies.sql)…")
    if not SEED_FILE.exists():
        print(f"❌ Seed file not found: {SEED_FILE}")
        sys.exit(1)

    sql = SEED_FILE.read_text(encoding="utf-8")
    print(f"   File size: {len(sql):,} chars — sending in one request…")

    try:
        query(sql, env)
        success = True
    except SystemExit:
        print("   One-shot failed. Retrying in statement-level chunks…")
        success = False

    if not success:
        # Split on semicolons and send chunks of ~100 statements
        statements = [s.strip() for s in sql.split(";") if s.strip()]
        chunk_size = 100
        chunks = [statements[i : i + chunk_size] for i in range(0, len(statements), chunk_size)]
        print(f"   Sending {len(chunks)} chunks ({len(statements)} statements total)…")
        for idx, chunk in enumerate(chunks, 1):
            chunk_sql = ";\n".join(chunk) + ";"
            query(chunk_sql, env)
            print(f"   Chunk {idx}/{len(chunks)} ✅")

    count_result = query("SELECT COUNT(*) AS cnt FROM policy;", env)
    cnt = count_result[0]["cnt"] if count_result else "?"
    print(f"✅ Seed applied. Policies in DB: {cnt}")


def cmd_verify(env: dict[str, str]) -> None:
    print("🔍 Running verification queries…\n")

    # 1. Table counts
    print("── 1. Table counts ──────────────────────────────────────")
    tables = [
        "policy",
        "policy_region",
        "policy_life_stage",
        "policy_eligibility",
        "policy_household_type",
        "policy_source",
        "category",
        "life_stage",
        "household_type",
        "region",
    ]
    union_sql = " UNION ALL ".join(
        f"SELECT '{t}' AS tbl, COUNT(*) AS cnt FROM {t}" for t in tables
    )
    rows = query(union_sql, env)
    for row in rows:
        status = "✅" if int(row["cnt"]) > 0 else "⚠️ "
        print(f"  {status}  {row['tbl']:<30} {row['cnt']:>6} rows")

    # 2. Category distribution
    print("\n── 2. Category distribution ────────────────────────────")
    dist_sql = """
        SELECT c.label_ko, COUNT(p.id) AS policy_count
        FROM category c
        LEFT JOIN policy p ON p.category_id = c.id
        GROUP BY c.label_ko
        ORDER BY policy_count DESC;
    """
    rows = query(dist_sql, env)
    if rows:
        for row in rows:
            bar = "█" * min(int(row["policy_count"]), 40)
            print(f"  {row['label_ko']:<20} {row['policy_count']:>4}  {bar}")
    else:
        print("  (no rows)")

    # 3. Sample matching query — 동작구 resident, 소득 400만원, 자녀 24개월
    print("\n── 3. Sample match (동작구, 소득 400만원, 자녀 24개월) ──")
    match_sql = """
        SELECT DISTINCT p.title, p.amount_text
        FROM policy p
        JOIN policy_region pr ON p.id = pr.policy_id
        JOIN region r ON pr.region_id = r.id
        LEFT JOIN policy_eligibility pe ON p.id = pe.policy_id
        WHERE r.code IN ('KR', '11', '11590')
          AND p.service_status = 'active'
          AND (pe.income_criteria_type = 'none'
               OR pe.median_income_threshold_percent >= 120
               OR pe.income_criteria_type IS NULL)
          AND (pe.child_age_min_months IS NULL OR pe.child_age_min_months <= 24)
          AND (pe.child_age_max_months IS NULL OR pe.child_age_max_months >= 24)
        ORDER BY p.title
        LIMIT 15;
    """
    rows = query(match_sql, env)
    if rows:
        for row in rows:
            amt = (row["amount_text"] or "-")[:50]
            print(f"  ✅  {row['title'][:45]:<47} {amt}")
        print(f"  총 {len(rows)}건 매칭")
    else:
        print("  ⚠️  조건에 맞는 정책 없음")

    # 4. Breakdown check
    print("\n── 4. Policies with multi-entry amount_breakdown ───────")
    breakdown_sql = """
        SELECT COUNT(*) AS cnt
        FROM policy
        WHERE jsonb_array_length(amount_breakdown) > 1;
    """
    rows = query(breakdown_sql, env)
    cnt = rows[0]["cnt"] if rows else 0
    status = "✅" if int(cnt) > 0 else "⚠️ "
    print(f"  {status}  {cnt} policies have >1 breakdown entry")

    # 5. RLS reminder
    print("\n── 5. RLS verification ──────────────────────────────────")
    print("  ℹ️  RLS cannot be tested via Management API.")
    print("      Manually verify in Supabase Dashboard:")
    print("      Authentication → Policies → confirm policies exist on each table.")

    print("\n✅ Verification complete.")


# ---------------------------------------------------------------------------
# CLI dispatch
# ---------------------------------------------------------------------------

COMMANDS = {
    "schema": cmd_schema,
    "seed": cmd_seed,
    "verify": cmd_verify,
}


def main() -> None:
    if len(sys.argv) < 2 or sys.argv[1] not in (*COMMANDS, "all"):
        print("Usage: python3 migration_runner.py [schema|seed|verify|all]")
        sys.exit(1)

    env = load_env()
    project_url = env.get("SUPABASE_URL", f"https://{env['SUPABASE_PROJECT_REF']}.supabase.co")
    print(f"🚀 Bumoro migration runner — project: {project_url}\n")

    cmd = sys.argv[1]
    if cmd == "all":
        cmd_schema(env)
        print()
        cmd_seed(env)
        print()
        cmd_verify(env)
    else:
        COMMANDS[cmd](env)


if __name__ == "__main__":
    main()

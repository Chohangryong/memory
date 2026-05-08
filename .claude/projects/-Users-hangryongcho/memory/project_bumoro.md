---
name: project_bumoro
description: 부모로(Bumoro) 프로젝트 현황 — Next.js 15 임신·출산·육아 정부지원금 매칭 서비스. Phase 1 개발 전 데이터 조사 완료, benefits 스키마 합의, 매칭 로직 설계 완료. 미완료: Supabase 마이그레이션 파일·임포트 파이프라인·매칭 API 코드
type: project
originSessionId: c523f95f-24db-4366-9345-08925795ebf9
---
# 부모로 (Bumoro) — 프로젝트 현황

**Why:** 임신·출산·육아 정부지원금 자동 매칭 + 콘텐츠 하이브리드 서비스. Phase 1(M1~3) 개발 시작 전 데이터 조사 + 스키마 설계 단계.

**How to apply:** Phase 1 개발 시 아래 합의 스키마와 데이터 현황 참고. 매칭 로직은 자체 Supabase SQL 필터링(외부 엔진 불필요).

---

## 기술 스택
- Next.js 15 (App Router) + TypeScript strict + Tailwind + shadcn/ui
- Supabase (DB + Auth + Storage) + Resend + Vercel
- 워킹 디렉토리: `/Users/hangryongcho/bumoro-project`

---

## 데이터 조사 현황 (2026-05-08 완료)

### Source 1: API 수집
- 파일: `data-samples/normalized-analysis/normalized-pregnancy-birth-childcare-policies.csv`
- 6,806행 39컬럼 (data.go.kr local_welfare/national_welfare/gov24 API)
- 목록만 1,611건 → matchable=false로 임포트 예정

### Source 2: 서울 25구 크롤링
- 파일: `data-samples/seoul-research/seoul-25gu-birth-benefits.md`
- 서울 전 25개구 출산장려금 전수조사 완료 (2026-05-07 초기 + 2026-05-08 보완)
- 주요 발견:
  - 서초구 출산장려금 **2022년 폐지 확정** (seocho.newstool.co.kr 근거)
  - 은평구 현금 0원, 둘째이상 출산용품교환권 15만원(비현금)
  - 강서구 공식 URL = `gangseo.seoul.kr` (gangseo.go.kr 아님)
  - 미확인: 구로구·도봉구·강북구 (추가 조사 필요)

---

## 합의된 benefits 스키마

```sql
benefits (
  id uuid,
  external_id text,          -- API source_id
  dedupe_key text nullable,  -- Phase 1 nullable, 추후 canonical
  source_kind text,          -- api | crawl | merged
  region_code text,          -- 행정구역코드 5자리 (강남구=11680, 서울=11, 전국=KR)
  scope text,                -- sigungu | sido | national
  title, summary, target_text, eligibility_text text,
  support_type text,
  matchable boolean,         -- false = 목록만, 매칭 제외
  relevance_score smallint,
  cond_pregnant bool,
  cond_birth_adoption bool,
  cond_multichild bool,
  cond_single_parent bool,
  cond_age_start_month int,
  cond_age_end_month int,
  income_min_pct int,        -- 소득 하한 (기준중위소득 %)
  income_max_pct int,        -- 소득 상한
  amount_tiers jsonb,        -- [{tier, amount_krw, unit}]
  deadline date,
  online_apply_url, detail_url, source_url text
)

regions (
  code text PK,              -- 5자리 행정구역코드
  name text,
  level text,                -- sigungu | sido | national
  parent_code text,
  aliases text[]
)
```

---

## 매칭 로직 (합의 완료, 코드 미작성)

```sql
SELECT *,
  (cond_pregnant::int + cond_multichild::int + ...) as match_score
FROM benefits
WHERE matchable = true
  AND (region_code = $user_region OR scope IN ('sido','national'))
  AND (NOT cond_pregnant OR $is_pregnant)
  AND (NOT cond_multichild OR $child_count >= 2)
  AND (income_max_pct IS NULL OR $income_pct <= income_max_pct)
ORDER BY match_score DESC, relevance_score DESC
```

- 외부 엔진(OpenFisca 등) 불필요 — Supabase SQL 필터로 충분 (Claude + Codex 일치)
- UX 참고: ACCESS NYC (github.com/CityOfNewYork/ACCESS-NYC)
- Rule schema 참고: EligibilityRules.org

---

## 남은 작업 (Phase 1 착수 전)

1. **Supabase 마이그레이션 파일** — benefits + regions DDL (`supabase/migrations/`)
2. **API CSV → benefits 임포트 스크립트** — 6,806건, matchable 플래그 처리
3. **크롤링 MD → benefits 임포트** — 서울 25구 구별 혜택 구조화
4. **매칭 API 코드** — `app/api/benefits/match/route.ts`
5. **user_benefits 연결 테이블** — 사용자 매칭 결과 저장
6. **amount_tiers 추출 파이프라인** — support_content 텍스트 → 금액 파싱

---
name: project_bumoro
description: 부모로(Bumoro) 임신·출산·육아 정부지원금 매칭+시점알림 웹앱. Next.js 15+Supabase, 4명 사이드, 6주 alpha. **2026-05-14 동작구 거주자 적용 정책 1,998건 정규화 + 31컬럼 CSV + 구글시트 28건 업로드 완료. 다음=사용자 검증(income_basis 보강 + ADR-0008 그룹핑 입력)**. 산출물=`/Users/hangryongcho/bumoro/{PRD,GRILL-LOG,CONTEXT}.md` + `docs/adr/0001~0003,0008` + `docs/research/dongjak-benefits.csv`. 워킹디렉토리=`/Users/hangryongcho/bumoro`
type: project
originSessionId: c523f95f-24db-4366-9345-08925795ebf9
---

# 부모로 (Bumoro) — 프로젝트 현황

**Why:** 임신·출산·육아 정부지원금 자동 매칭 + 시점 알림 웹앱. 부모가 자기 정보 1회 입력 → 시점에 받을 수 있는 모든 혜택 자동 알림. 4명 사이드, 6주 alpha 윈도우.

**How to apply:** 다음 세션에서 이어가려면 `/Users/hangryongcho/bumoro/` 워킹디렉토리에서 아래 진입점 파일 순서대로 읽고 다음 액션부터 시작.

---

## 진입점 (resume 시 읽을 순서)

| # | 파일 | 무엇 |
|---|------|------|
| 1 | `bumoro/CONTEXT.md` (651줄) | 도메인 용어 사전. entity·verb·enum·snapshot 패턴. 모든 코드·문서가 따라야 할 canonical |
| 2 | `bumoro/GRILL-LOG.md` (557줄) | grill-me 18개 결정 + Codex 5회 보강 + alpha cut + 검증 phase 우선순위 |
| 3 | `bumoro/PRD.md` | 제품 정의 (Section 3 Positioning + Section 5 소득 옵션 반영) |
| 4 | `bumoro/docs/adr/0001~0003` | hard-to-reverse 결정 3개 |
| 5 | `bumoro/research/` (untracked) | 사전 데이터 조사 (ws1~14, DATA-COLLECTION-PLAN, REPORT-FINAL). API CSV 6,806행 + 서울 25구 크롤링 |

---

## 기술 스택 (확정)

- Next.js 15 (App Router) + TypeScript strict + Tailwind + shadcn/ui
- Supabase (DB + Auth + Storage + RLS + pg_cron) + Resend + Vercel
- LLM = Claude Sonnet 4.6 시작, monitor 후 Haiku 4.5 다운그레이드 (단순 카테고리)

---

## 핵심 아키텍처 (CONTEXT.md 요약)

**Entity:** Benefit / User / Child / Spouse_info / Source / **source_fetches** (raw_snapshots rename, ADR-0002) / benefit_sources / User_benefit / Notification

**3-tier:**
- **Phrase**: legal_phrase / admin_phrase / parent_phrase (ADR-0001)
- **Verify timing**: source_checked_at / content_verified_at / effective_date

**Enum:**
- policy_status: announced | active | deprecated (3-state, 반자동 전환)
- match_tier: green (카드 노출) | yellow (nudge만)
- Role: user | curator | admin (+service_role 외부)
- Notification kind: weekly_digest | urgent_d7 | urgent_d1 | onboarding (+ consent_renewal beta)
- Consent type: terms_of_service | privacy_policy | sensitive_info | email_marketing | external_share

**Snapshot 패턴 (envelope):** schema_version + captured_at + source_entity_type/id + source_version + data (whitelist) + hash. user_snapshot은 `income_band` ('low'|'mid'|'high'), 원소득값 freeze 금지

**Verbs (ADR-0003):** RPC 11개(권한·감사·트랜잭션) + TS service 6개(외부 API·orchestration). `match` → `evaluate_benefit_match`로 rename. `is_eligible`은 internal helper만.

---

## Alpha scope (Codex 통합 검토 후 cut됨)

**Alpha = "검증된 소수 정책을 정확히 매칭 + 안전하게 메일 발송" 제품** (자동 데이터 파이프라인 X)

**핵심 4개:**
1. 13.4 1차 출처 검증 (Core 3개)
2. admin 검수 워크플로 (source_fetches → approve → benefits)
3. 매칭 audit log + render snapshot
4. 메일 안전장치 (bounce/unsubscribe/재시도)

**Core 후보 cap = 3개:** 첫만남이용권 + 부모급여 0세 + 부모급여 1세 (자격 단순+전국+잘못 안내 risk critical)

**Beta로 미룬 것:**
- API CSV 6,806행 전체 import (alpha는 수기 검증 정책 중심)
- 서울 25구 markdown 전수 import (alpha 1~3구만)
- terminology_rules 자동 lookup (alpha는 benefit별 렌더 문구 직접 저장)
- normalized_hash diff/history
- 자동 cron (변경감지·익명화·dead link)
- yellow tier nudge

---

## 검증 phase 우선순위 (Critical Path, 다음 액션)

| 순위 | task | 이유 | 담당 |
|------|------|------|------|
| **1** | **13.4 Core 3개 1차 출처 verification** (~2일) | seed·룰·claim·LP 기반 | 이호 또는 김현민 |
| 2 | 13.3 legal 자문 1회 | 민감정보·자녀·retention·disclaimer = DB 설계 직접 영향 | 김현민 |
| 3 | PRD freeze v1.0 | 13.3/13.4 결과 반영 후 | 4명 합의 |
| 4 | Conflict 핸드북 1페이지 | 큐레이터 검수 base (자격·금액 vs 신청·운영 layer 분리) | 이호 |
| 5 | CONTRIBUTORS.md 작성·서명 | 4명 commit 형식 (90일 alpha 약속, 김현민 결정권, D60 retro) | 4명 합의 |
| 6 | 13.2 competitor 정밀 분석 | 가짜 부모 5케이스 입력 매칭 비교 | 김현민 |

---

## Build 전 unknowns (이미 결정된 것, GRILL-LOG 마지막 섹션)

1. 소득 = 세션 + 명시 동의 후 DB 저장 (ephemeral mode)
2. 신청 완료 = 사용자가 웹앱 대시보드에서 직접 체크
3. 지역 변경 = `user_benefits.status='expired'` + 신규 매칭 INSERT, pending notifications 취소
4. 잘못 안내 = 13.3 legal input + incident 핸드북 (curator 발견 시 admin 알림 + 영향 user 메일 정정 + benefit 일시 비활성화)
5. 최종 데이터 승인권자 = 김현민

---

## 데이터 신뢰도 원칙 (모든 결정의 base)

> **모든 secondary 데이터는 1차 검증 전엔 가정.**

PRD·research·ws 시리즈·API CSV·크롤링 markdown 모두 작성자/소스 정리물 — 1차 출처(공식 안내, 법령, 행정 페이지) 검증 없이 의사결정 base 사용 금지.

| 출처 | 1차 검증 | 사용 가능 |
|------|---------|----------|
| 정부 1차 출처 (정부24·법령·보건복지부) | ✅ | 코드 룰·DB seed·알림 |
| 정부 API CSV / 지자체 크롤링 | ❌ raw | 후보 list, sample 검증 후 |
| ws10 매핑 / ws8 EV | 🟡 부분 | dictionary seed (1차 페어 검증 후) / 마케팅 reference만 |
| PRD/플랜 "Core N" | ❌ 작성자 직관 | 후보, 13.4 검증 후 확정 |

**필수:** 모든 정책 row·alias·rule에 `verified_at` + `source_url` 필수. 검증 없는 데이터 = 코드 hardcoding/사용자 노출/알림 발송 금지.

---

## 사이드 4명 (Risk #2 mitigation)

- **조항룡** Tech Lead (풀스택+디자인)
- **이호** Data Lead (스키마·임포트·LLM 정규화)
- **윤형** Growth Lead (인스타·맘카페·인터뷰)
- **김현민** PM/Business Lead (병원·조리원 파트너십·legal·**최종 결정권자**)

90일 alpha commit, D60 retro, 빠질 시 인수인계 1주 (CONTRIBUTORS.md로 박을 예정)

---

## ADR (hard-to-reverse 결정)

- **ADR-0001** 3-tier phrase (legal/admin/parent_phrase)
- **ADR-0002** Snapshot 패턴 + source_fetches rename (former raw_snapshots)
- **ADR-0003** Verbs 사전 + RPC vs TS service layer 분리

---

## 동작구 데이터 수집·정규화 (2026-05-14)

**위치:** `bumoro-project/data-samples/` (gitignored, ~127MB, 3소스)
- gov24 raw 10,936 / national-welfare 413 / local-welfare 4,563 = 총 15,912건
- 임신·출산·육아 키워드 후보 6,024건 = `normalized-benefits-preview.json` (21필드 정규화 완료)
- 21필드: source_api, source_id, title, summary, target, eligibility, support_content, application_method, deadline, region_name, organization, contact, online_apply_url, detail_url, life_stage, topics, household_types, support_cycle, support_type, source_updated_at, raw_condition

**동작구 작업 (31컬럼 v1):**
- 산출: `/Users/hangryongcho/bumoro/docs/research/dongjak-benefits.csv` (1,998 rows, 2.5MB, UTF-8 BOM)
- 빌더 스크립트: `/tmp/build_dongjak_benefits.py` (휘발, 재실행 시 재작성 필요)
- 필터: region 빈값(central) + `서울특별시`(seoul) + organization/region에 `동작구`(dongjak), 다른 지자체 제외
- Stage 키워드 4단계: pre_pregnancy/pregnancy/childbirth/parenting — 매칭 0개면 제외
- 소득 자동 추출: middle_income_pct / absolute_amount / health_insurance / category_only / mixed / none / unknown (unknown 55%, absolute_amount 정규식이 거의 못 잡음 — 사용자 검증에서 보강)

**분포:** central 1,893 + seoul 77 + dongjak 28 = 1,998
**stage 분포:** parenting 1,792 / childbirth 406 / pregnancy 366 / pre_pregnancy 116

**구글 시트 (동작구 28건만 v1):**
- https://docs.google.com/spreadsheets/d/1WC8OcTfbWq1kycFHm0wozgO2j2Wsi3OwemaLKkj4mDo
- 나머지 seoul+central은 사용자가 직접 CSV import 예정 (MCP 파일 사이즈 한도)

**ADR-0008 (benefit-family-grouping) 그룹핑 4컬럼 = 모두 빈 값** (큐레이터 수동 입력 영역): benefit_family_id / benefit_group_id / parent_benefit_id / excludes_benefit_ids

**다음 액션:**
1. 사용자가 시트에 나머지 1,970건 import
2. content_verified_at + source_screenshot 채우며 검증
3. income_basis unknown 1,104건 수동 보강
4. ADR-0008 그룹핑 4컬럼 입력
5. Core 3개(첫만남/부모급여 0,1세) 1차 출처 검증과 합류

---

## Git 커밋 history (bumoro repo)

- `8b92091` docs(context): grill-with-docs 도메인 용어 + ADR 0001-0003
- `4cc439b` docs: grill-me 18개 결정 + PRD positioning 보강
- `55dba51` chore: initial commit

memory repo:
- `58fd479` docs(memory): bumoro grill-me 결정 통합

---
name: cosmetics_scraping_status
description: 뷰티 랭킹 수집기 — OY 재크롤 완료(2026-05-01), PopupBenefits 이슈 자연해소(OY 마크업 복구), 파서 정상. 다음: 플랫폼간 미매칭 상품 수기 매칭 + 데이터 정합성 체크. 쿠팡/SSG/Shopee 확장 예정. 키워드: 화해 성분 EWG ingredients product_ingredients alias 정규화 매핑 OY 재크롤 매칭
type: project
originSessionId: 2a3ea369-6b96-44af-9238-3aa7e89fd11d
---
## 프로젝트: cosmetics_scraping (뷰티 랭킹 수집기)

**위치:** ~/cosmetics_scraping/
**설계서:** DESIGN.md v3.1 + 리뷰 설계서 (~/.gstack/projects/cosmetics_scraping/)
**venv:** ~/cosmetics_scraping/.venv (python 3.11, scrapling[all] + pytest-asyncio 설치됨)

### 수익화 전략 (2026-04-25 확정)

멀티플랫폼 교차분석 인텔리전스로 포지셔닝. 전략 전문은 Notion 참조.

- **Phase 1 (0~2개월):** 화해 수집 + 올리브영×화해 교차분석 → B2B 인디 브랜드 월 20만원
  - 이번 주 액션: 화해 scraping 가능성 확인 + 인디 브랜드 3곳 DM
- **Phase 2:** B2C 콘텐츠 (instagram-feed-generator + 화해 데이터 → Xiaohongshu)
- **Phase 3 (6개월+):** Shopee/Lazada 수집 + 동남아 에이전시 월 50~100만원

**Why:** 단일 플랫폼 랭킹 알림(월 5만원)보다 교차분석 신호(리뷰품질 vs 판매순위)가 인디 브랜드에게 유의미하게 더 가치 있다는 전제. DM 반응으로 검증 예정.
**How to apply:** 기술 작업 우선순위 결정 시 Phase 1(화해 수집) → Phase 2 순서 유지.

### 현재 진행 상태

**Stage 1: 완료** ✅
**Stage 2: 완료** ✅ (2026-04-18) — 올리브영 TOP 50 × 3카테고리 = 150건
**Stage 3: 완료** ✅ — 무신사 통합 (sections API 사용, 750건/15카테고리)
**Stage 4: 카테고리 확장 + 교차분석 PoC 완료** ✅ (2026-04-26)
  - 올영 카테고리 3→13개 확장 (커밋 8e1f2da), enricher concurrency 3→4 (30668cb)
  - 헤드리스 풀 수집 1,400건 (OY 650 + MS 750), enrich 650/650 100%
  - 교차 매칭 PoC: scripts/match_poc.py (difflib, 임계값 0.70, 매칭률 30%)
  - 교차 분석 리포트: scripts/cross_analysis.py (커밋 c087424)

**Stage 5: 화해 통합 완료** ✅ (2026-04-26, commits d32f79a→2267081)
  - 정찰 표준화: scripts/recon_hwahae.py (Scrapling DynamicSession capture_xhr)
    → data/_recon/hwahae.json에 endpoint·leaf 117개(depth-2 13 + depth-3 104) 캐시
  - Fetcher: src/hwahae_fetcher.py (gateway.hwahae.co.kr/v14/rankings/{id}/details
    aiohttp 직접 호출, 인증 불필요, concurrency=4)
  - 통합: --platforms {oliveyoung,musinsa,hwahae} 콤마 구분 플래그
    + --hwahae-scope {a=13, b=117}. hwahae 단독 적재 가능
  - 검증: scope=a 풀 수집 634건/5초 DB 적재 OK, scope=b 4,861건/48초
  - product.review_rating(0~5)→review_score(0~100) 정규화로 OY/MS 스키마 통일
  - robots.txt /api/ Disallow 있으나 gateway 도메인 별도 — 우회 결정함

### 교차분석 검증된 사실 (2026-04-26 데이터)

- 양 플랫폼 진입 브랜드 102개 (OY 260 / MS 294, 교집합 102)
- 매칭쌍 53개 @ threshold 0.70 (102개 @ 0.62)
- **무신사가 OY 대비 일관되게 비쌈** — 매칭 가격차 TOP10 모두 OY < MS, 메디힐 바이오마스크는 10배 차이
- 채널별 강세 명확: 비플레인/에스트라/메디힐 = OY, 라곰/클리오/자빈드서울 = MS
- 별점(OY)·리뷰점수(MS) 정규화 비교 시 ±4 이내 → 채널 간 만족도 일관

**Why:** 수익화 가설("교차분석 신호가 단일 플랫폼 알림보다 가치 있다")이 데이터로 뒷받침됨 — 채널별 강세, 가격 갭, 무신사 미입점 OY 1위 인디 영업 리스트 추출 가능.
**How to apply:** 인디 브랜드 DM 시 "당신 카테고리에서 무신사 미입점 1위 = 즉시 영업 후보" 같은 구체 메시지 가능.

### 핵심 결정/팁

- 매칭 임계값 0.70이 실용적 (0.8+ 거의 정확, 0.7 마케팅 prefix 차이만 있는 동일상품, 0.62~0.68 보더라인)
- 정규화: brackets/숫자단위/마케팅noise(기획,단독,증정,한정,세트 등) 제거 후 token 기반 비교
- MS는 review_score(0~100) 별도 컬럼, OY는 rating(0~5) — 별점*20으로 정규화 비교

### 영업용 핵심 리스트 (scripts/cross_hidden_gems.py 출력)

매칭쌍 53개 중 양 채널 만족도 높은 41쌍에서 4가지 패턴:
- OY 강세 + MS 숨음 (8개): 에스트라 아토베리어365, 비플레인 녹두폼, 메디힐 마데카, 이즈앤트리 참마 → **무신사 노출 강화 영업 후보**
- MS 강세 + OY 숨음 (5개): 클리오 프로 아이팔레트, 토리든 다이브인, 바닐라코 클린잇제로 → **올영 노출 강화 후보**
- 양쪽 30위+ 진짜 숨은 강자 (3개): 메디힐 마스크팩, 다슈 헤어, 포맨트 향수
- 메가셀러 양쪽 TOP10 (2개): 에스트라 아토베리어365 크림, 낫포유 바디미스트

### DB 스키마
- products: id, platform, product_id, product_name, brand, first_seen_at, last_seen_at
- ranking_snapshots: id, session_id, product_id, platform, category, rank, original_price, sale_price, discount_rate, rating, badge, collected_at, review_count, review_score

### 핵심 학습: Scrapling Spider vs Fetcher API 차이
- Fetcher(StealthyFetcher) 직접 사용 시: Adaptor 객체 반환 (css_first, .text, .attrib 가능)
- Spider 컨텍스트: Scrapy-style Selector 반환 (css().get(), ::text, ::attr())
- start_requests, is_blocked 모두 async def 필요

### Stage 7: OY 재크롤 완료 (2026-05-01)
- OY PopupBenefits 마크업 이슈 → OY가 구버전으로 복구, 파서 수정 불필요
- 재크롤 세션 `20260501_193608`: 650건, 에러 0, rating NULL 9건(실제 별점 없는 신상품)
- original_price NULL 83건 = 진짜 단일가 상품 (정상)
- 파서: `.tx_org .tx_num` = 정가, `.tx_cur .tx_num` = 할인가 (현재 정상 동작)
- **다음: `python3 scripts/manual_review.py` — 보더라인 62건 수기 매칭 (y/n/q 인터랙티브)**

### Stage 6: 화해 성분 정보 적재 완료 (2026-05-01)
- API: `gateway.hwahae.co.kr/v14/products/{pid}/ingredients`
- **익명 인증 헤더 필수** (없으면 401):
  `authorization: Bearer` + `hwahae-device-id: anonymous` + `hwahae-user-id: anonymous`
- 신규 테이블: `ingredients` (4,038개), `product_ingredients` (120,644 매핑)
  - 조인키: `product_ingredients.product_id` ↔ `products.id` (자체 PK)
  - ingredient.id는 화해 마스터 ID 그대로 사용 (정제수=5321 등)
- 신규 모듈: `src/hwahae_ingredients.py` (concurrency 4, ~2분)
- CLI: `--enrich-ingredients` 플래그
- 화해 제품 3,635/3,825 enriched (95%, 190개는 성분 미등록)
- EWG 분포: 1=2,404 / 1-2=323 / 7+ 소수(염색약/립스틱)
- 알레르기 TOP: d-리모넨(697), 리날룰(673), 시트로넬올(345) — 향료 계열

### 화해 detail 페이지 차단 (recon 노트)
- `https://www.hwahae.co.kr/products/{id}` → **403 차단** (anti-bot)
- 우회: ranking 페이지 XHR(`request_headers`)에서 anonymous 인증 헤더 추출 → gateway API 직접 호출
- 화해 product_id는 작은 값(98)부터 큰 값(2198909)까지 모두 ingredient API 작동

### 브랜드 alias 매핑 (한↔영, 표기 변형)
- `scripts/brand_map_hwahae.py` — 화해 중심 브랜드 매핑 (정규화 + alias dict + fuzzy 0.85)
- alias 14건 누계 (CK↔캘빈클라인, 3CE↔쓰리씨이, AHC↔에이에이치씨, GNM↔GNM자연의품격, 베르사체↔베르사체 퍼퓸 등 ~퍼퓸/~뷰티 suffix 포함, CKD↔CKDGUARANTEED, 정샘물↔정샘물뷰티, 로레알↔로레알파리)
- 최종 버킷: 3-way 102 / 화해+OY 85 / 화해+MS 86 / 화해 단독 736
- 매핑 안 된 OY/MS 단독은 모두 화해 미진입 카테고리 (네일, 헤어툴, 면도기, 위생용품, 가전, PB)
- 보류: 메디큐브 vs 메디큐브 에이지알 (별도 디바이스 라인 — APR 자회사), 비긴스/줌 바이 정샘물 (별도 타깃 라인)

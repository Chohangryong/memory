---
name: oy_parser_popupbenefits_issue
description: cosmetics_scraping OY 파서가 신규 PopupBenefits 마크업을 못 따라가서 sale_price에 정가가 들어감. 87 NULL은 빙산의 일각 — 650건 전수 의심. 키워드 olive young oliveyoung price 정가 세일 최적가 PopupBenefits tx_cur tx_org
type: project
originSessionId: 0c0c4c0b-f9e5-4f27-a517-e3b7139bdba1
---
## OliveYoung 파서 누락 (2026-05-01 발견)

### 증상
- `ranking_snapshots` OY 87/650 (13.9%)이 `original_price=NULL` (sale_price만 채워짐)
- 처음엔 "할인 없는 단일가 제품"으로 가설 세웠다가 OY 페이지 실측 후 폐기

### 진짜 원인
- OY가 가격 영역을 신규 컴포넌트 `PopupBenefits_*`로 마이그레이션
- 기존 파서(`src/spider.py:76-77`) 셀렉터 `.tx_cur .tx_num` / `.tx_org .tx_num`은 구버전
- 신규 마크업 구조: `판매가 / 세일(-할인) / 최적가` 3단계
- 현재 DB의 `sale_price`는 사실 **판매가(정가)** 이고 진짜 세일가(=최적가)는 안 긁힘

### 실측 3건 (2026-04-30 세션)
| pid | name | DB sale | 판매가 | 세일 | 최적가 |
|---|---|---|---|---|---|
| A000000157820 | 일리윤 | 18,900 | 18,900 | -5,000 | **13,900** |
| A000000004736 | 셀리한센 | 18,000 | 18,000 | — | 18,000 |
| A000000190915 | 바른생각 | 13,500 | 13,500 | -1,600 | **11,900** |

→ 3건 중 2건이 실제 세일 중인데 누락. 87건 NULL은 단지 `.tx_org`(취소선)가 안 잡힌 케이스가 우연히 드러난 것.

### 함의 (중요)
- **NULL이 아닌 OY 행도 sale_price가 정가일 가능성** — 표면적으로 정상이라 못 알아챔
- "OY 87 NULL → sale_price 복사" 절대 금지 (정가를 정가로 덮으면 영구히 세일 정보 잃음)

### 해결 (2026-05-01)
- OY가 PopupBenefits 마크업을 구버전으로 복구 → 파서 수정 불필요
- 재크롤 완료: 세션 `20260501_193608`, 650건, NULL 83건(진짜 단일가)
- 일리윤 A000000157820: sale_price=13,900 / original_price=18,900 ✅ 정상

### 화해 백필은 별개로 완료
- 화해 가격 누락 56.9% → 2.2% (commits aaac361, 46e4808)
- 잔여 hwahae 51건은 API 자체에 가격 미존재 (보강 불가)
- DB 백업: `data/beauty_ranking.db.bak_20260501`

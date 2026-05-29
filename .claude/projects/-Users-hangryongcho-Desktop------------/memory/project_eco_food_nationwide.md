---
name: eco-food-nationwide
description: "임산부 친환경농산물 꾸러미(dongjak-eco-food-package) 전국 확대(2026-05-29). 농식품부 국가사업 3년 중단 후 2026 부활·6월 시행·월4만원 포인트. region 동작구→전국(KR), detail_url 에코e몰, 신청안내 \"2026년 6월 시행 예정\". dev+운영 DB+코드 반영."
metadata: 
  node_type: memory
  type: project
  originSessionId: 6700d4e8-a3b4-442c-8791-dd8055c080d0
---

# 임산부 친환경농산물 꾸러미 전국 확대 (2026-05-29)

`dongjak-eco-food-package` 정책을 동작구 한정 → **전국 노출**로 변경.

## 배경 (코드에 안 남는 정책 맥락)
- 원래 이 사업은 농식품부 전국 "임산부 친환경농산물 지원사업"인데 **2023~2025년 3년간 중단**됐다가, 2026년 본사업으로 **부활**(예산 157.8억, 전국 임산부 16만명 대상).
- 2026 개편 내용: **올 하반기(사용자 확인: 6월)부터 시행**, 월 4만원(연 48만원) 온라인몰 포인트(보조 80%·자부담 20%). 기존 동작구 자체사업(45만원 꾸러미·자부담 9만원)과 금액·방식 다름.
- 공식 통합 신청처 = **에코e몰(www.ecoemall.com)** (aT 운영). servedream·웰로는 민간 중계라 비공식.
- 지자체 참여는 미확정이었으나 사용자 판단으로 전국 확대 결정.

## 적용 변경 (마이그레이션 `20260529000000_eco_food_nationwide.sql`)
- **region**: 동작구(11590)·서울(11) 제거 → 전국(KR, national) 단일. (사용자 결정: "가장 구체적 하나만"이 아니라 전국으로)
- **detail_url**: 동작구 servedream → `https://www.ecoemall.com/main/pregnant01.do`
- **application_deadline_text**: "2026년 6월 시행 예정 (에코e몰 온라인 신청)"
- **금액·제목·주관기관은 유지** (사용자가 "region만 최소 변경" 선택, 단 detail_url·신청안내는 추가 반영)
- dev+운영 DB 양쪽 반영 완료. seed_policies.sql도 동기화(policy_region 1개로).

## How to apply
- 하반기 정식 공고가 나오면 금액(월 4만원 포인트)·신청기간을 2026 국가사업 기준으로 재시드 가능. 지금은 옛 동작구 자체사업 금액(45만원)이 남아있음.
- generate_seed.py SCOPE_MAP엔 "전국 eco-food" 케이스 없음. 입력 `/tmp/bumoro_122.json` #11 적용범위가 '동작구'라 재생성 시 회귀 주의 — seed_policies.sql이 진실 소스.
- 관련: [[feedback_seed_onconflict]] (detail_url/deadline ON CONFLICT SET 포함됨), [[feedback_supabase_db_update]] (DB먼저→코드)

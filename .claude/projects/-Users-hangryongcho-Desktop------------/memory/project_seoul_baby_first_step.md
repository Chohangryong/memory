---
name: seoul-baby-first-step-policy-coverage
description: "서울아기 건강 첫걸음(seoul-baby-first-step-health) 정책: 사업지역 자치구만 운영, 동작구 row 임시 제거됨, 베타 확장 시 정확한 시군구 매핑 필요"
metadata: 
  node_type: memory
  type: project
  originSessionId: 70dce57b-451e-4ab4-9251-6a3512904774
---

## 정책 정보

`seoul-baby-first-step-health` (서울아기 건강 첫걸음 사업, 생애초기 건강관리)는 서울 25개 자치구 전체가 아니라 **사업지역으로 선정된 자치구만 운영**.

## 현재 처리 (2026-05-28 마이그레이션 20260528000004)

- 기존: policy_region에 `11`(서울 시도) + `11590`(동작구) row 등록
- 변경: `11590` 동작구 row 삭제. `11`만 유지
- 사유: 영등포·중랑·구로·종로·서초 등 다른 사업지역 자치구도 운영하는데 그들의 row는 없어 일관성 부족. 베타엔 동작구 외 자치구가 region 테이블에 없어 정확한 매핑 추가 불가
- 영향 없음: 동작구 사용자도 서울 시도 매칭으로 정상 노출

## 확인된 사업지역 자치구 (부분)

- 동작구 ✓
- 영등포구 ✓
- 중랑구 ✓
- 구로구 ✓
- 종로구 ✓
- 서초구 ✓
- 강남구·마포구: 별도 사업 "생애초기 건강관리"로 신청 (서울아기 첫걸음과 구분)

**미확인**: 2018년 기준 23개 자치구로 확대됐다고 함. 25개 중 2개 비사업지역 가능성. 정확한 비 사업지역 명단은 공식 페이지에도 명시 없음.

## 베타 확장 시 작업 (다른 자치구 region 추가 시점)

1. 서울아기 첫걸음 공식 사업지역 자치구 전수 확인 (서울시 임신·출산 정보센터 02-2133-9489 문의 또는 ourbaby.seoul.kr 확인)
2. 사업지역 자치구별로 `policy_region` row 추가:
   ```sql
   INSERT INTO policy_region (policy_id, region_id, scope)
   SELECT p.id, r.id, 'sigungu_specific'
   FROM policy p, region r
   WHERE p.canonical_slug = 'seoul-baby-first-step-health'
     AND r.code IN ('11590', '11560', '11260', '11530', '11110', '11650', ...);
   ```
3. **비사업지역 자치구 사용자**가 이 정책 매칭받지 않도록 별도 처리 검토 필요
   - 현재 `11`(서울 시도) row만 있으면 모든 서울 자치구 사용자에게 매칭됨
   - 정확한 매칭 위해선 `11` row를 제거하고 사업지역 자치구 row만 남기는 방법 고려
   - 다만 베타가 아직 충분히 확장 안 됐을 땐 `11` 그대로 두고 안내 문구로 보완하는 게 현실적

## 관련 출처

- [서울아기 건강 첫걸음 사업 - 서울시 임신·출산 정보센터](https://seoul-agi.seoul.go.kr/health-first-step)
- [중랑구 보건소 - 서울아기 건강 첫걸음](https://www.jungnang.go.kr/health/main/contents.do?menuNo=400365)
- [영등포구 보건소 - 서울아기 건강 첫걸음](https://www.ydp.go.kr/health/contents.do?key=3543)

## 관련 메모리

- [[next-task]] — 베타 region 확장 작업

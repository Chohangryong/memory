---
name: seed-onconflict-fields
description: "seed_policies.sql ON CONFLICT 절에 수정 대상 필드를 반드시 포함해야 함. detail_url, service_status 등 누락 시 기존 row가 업데이트 안 되는 문제."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: e9b40002-b12c-4796-b150-5fcca00c19f1
---

seed_policies.sql의 ON CONFLICT (canonical_slug) DO UPDATE SET 절에 변경 대상 필드를 모두 포함해야 한다.

**Why:** 최초 생성 시 amount 관련 필드만 SET에 포함되어 있었음. 이후 detail_url, service_status 등을 VALUES에서 수정해도 기존 row는 ON CONFLICT UPDATE를 타면서 해당 필드가 갱신되지 않아 dev DB에 117 active / 5 discontinued로 잘못 반영됨.

**How to apply:** seed_policies.sql 수정 후 DB 재적용 시, SET 절에 수정한 필드가 포함되어 있는지 반드시 확인. 현재 SET 필드: title, summary, description, organization, amount_min/max/text/breakdown, detail_url, service_status, confidence, parent_friendly_copy, application_method_text, application_deadline_text.

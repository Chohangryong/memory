# Memory Index

## User
- [user_profile.md](user_profile.md) — 소프트웨어 엔지니어, Python/LLM, 인스타 피드생성기(수익화) + heisenberg

## Feedback
- [feedback_work_style.md](feedback_work_style.md) — 승인 기반 워크플로우, 최소 변경 원칙, 단계별 확인 선호

## Reference
- [reference_cosmetics_notion.md](reference_cosmetics_notion.md) — cosmetics_scraping 전략 문서 Notion URL (K뷰티 로드맵 v2, 2026-04-25)

## Project
- [project_heisenberg_status.md](project_heisenberg_status.md) — heisenberg-agent 프로젝트 현황 (main 머지 완료)
- [project_key_decisions.md](project_key_decisions.md) — heisenberg 기술 결정 (selector, sync, Notion 등)
- [project_instagram_feed_generator.md](project_instagram_feed_generator.md) — instagram-feed-generator 현황 + Phase 3 게시 예약 + 카피 규칙(hook 명사형, "~예요" 금지) + Slack listen 운영 + **IG /media 9004/2207052 → Cloudinary로 마이그레이션 완료(2026-04-27)** (R2/S3/CloudFront 모두 차단됨, Cloudinary/Wikipedia/dummyimage 통과 / `IMAGE_HOST` env 토글 / `image_uploader.py` 팩토리 / R2 Custom Domain UI 버그→wrangler CLI 우회)
- [project_instagram_v2_brainstorm.md](project_instagram_v2_brainstorm.md) — **v2 도메인 무관 캐러셀 엔진 브레인스토밍 진행 중**. mockup 승인 완료(2026-05-01). 다음=디자인 섹션 8개 순차 제시(아키텍처→LLM CLI→블록→데이터모델→렌더→에러→테스트→Git). 컬러 에메랄드(#10B981) 화이트 베이스, 8종 블록 팔레트(image_with_body+stat_highlight 신규, image_caption 폐기), 타이포 스케일·슬라이드 밀도 규칙·헤더푸터 확정. claude CLI subprocess + worktree v2 분리 + per-agent IG 계정. HANDOFF: `docs/v2-mockup/HANDOFF.md`
- [project_cosmetics_scraping.md](project_cosmetics_scraping.md) — 뷰티 랭킹 수집기 Stage 3 재검토 중, 수익화 전략 확정(B2B 교차분석 월20만/B2C Xiaohongshu), 화해→쿠팡→SSG→Shopee 확장 예정
- [project_oy_parser_issue.md](project_oy_parser_issue.md) — **OY 파서 신규 PopupBenefits 마크업 미대응** — 판매가/세일/최적가 3단 중 정가만 긁힘. 87 NULL뿐 아니라 650건 전체 sale_price 의심. 파서 전면 수정 + 재크롤 TODO. 화해 백필은 commit aaac361/46e4808로 완료
- [project_personal_ai_team.md](project_personal_ai_team.md) — ceo-orchestrator + 10명 팀 하네스, 스펙·플랜 완료 실행 대기. M1→M2→M5→M3→M4→M6, Max $100(5x), Subagent-Driven vs Inline 선택 대기.
- [project_hermes_agent.md](project_hermes_agent.md) — **Hermes Agent 사용자 전역 설치 완료(2026-05-03)**. `~/.hermes/`, `~/.local/bin/hermes`, 스킬 89개 번들. `hermes setup` 미진행(API키·모델·working dir 미설정). working dir = 홈 예정(민감폴더 노출 주의)

---
name: instagram-feed-generator v2 디자인 — Night Magazine + 7-Role 시스템
description: 2026-05-03 디자인 전면 피벗. 흰 배경 9-블록 카드뉴스 → 다크 매거진 7-역할 시스템. Codex 8.2/10, content-marketer 카피 fix 완료. mockup PNG 6장 + 아티팩트 4장 obsidian-skills 케이스 검증 완료. v2/main 브랜치, instagram-feed-generator-v2 워크트리. **2026-05-10 spec(2026-05-01-v2-claude-native-block-palette-design.md §3-4/§5-5/§5-7/§6-3-A/§10-1) + CLAUDE.md(night-mag 테마/7-role/5-tier/통일성/AI톤 placeholder) 갱신 커밋 완료 (c1a503d, d9d515a).** 다음=AI말투 12패턴 인라인(이 메모리 70~81줄 → ai_tone_antipatterns.txt) / paper2code 사진강한 repo 검증 / HC·BB 아바타 교체 / templates 구현(role 기반 재구조화) / HANDOFF §11 갱신.
type: project
originSessionId: 54aad765-24bf-4d52-95ee-f9ab9a55728d
---
## 2026-05-03 — 디자인 전면 피벗 (이전 결정사항 폐기)

사용자 코멘트: "흰배경 + 카드 레이아웃 자체가 마음에 안들고, 디자인 블록들이 조잡, v1보다 못함." → codex 컨설팅 4라운드로 전면 재설계.

### 폐기된 v2 디자인 (2026-05-01 mockup)
- ❌ 흰 배경 (#FFFFFF) + 에메랄드 (#10B981) + 페이지 #EEF3EC
- ❌ 9종 블록 팔레트 (hero/feature_card_3/bullet_list/usage_example/comparison_2col/tip_box/image_with_body/stat_highlight/cta)
- ❌ 헤더·푸터 1px 보더 분리, 카드 스택 레이아웃
- 사유: codex 진단 — "v2는 모든 콘텐츠를 동등 무게의 UI 가구로 변환 → 에디토리얼 위계 사망. 카드뉴스 클리셰." 사진 빠진 v1도 같은 함정.
- 이전 mockup 보존: `docs/v2-mockup/preview.html` (참고용)

### 새 v2 디자인: Night Magazine + 7-Role
**위치**: `instagram-feed-generator-v2/docs/v2-mockup/night-mag/`
- `artifacts/` HTML+CSS+PNG 4장 (master / base-pseudo / canvas-diagram / workflow-split)
- `slides/` HTML+CSS+PNG 6장 (obsidian-skills 케이스)
- `render.py` Playwright 렌더러
- `_base.css`, `_slide.css` 토큰

#### 컬러 (확정)
```
--page:        #050505
--surface:     #111111
--accent:      #FF6B35   /* 코랄 — v1 계승 */
--accent-deep: #B83A18
--text:        #F5F5F0
--text-dim:    #9A9A94
```
도메인 액센트 시프트 — GitHub 코랄, K-beauty 로즈 #FF4F7B, news 시그널 옐로 #F5B301 / 레드 #EF4444.

#### 7-Role 카탈로그 (9-블록 폐기)
| Role | 의도 | 렌더러 아트 디렉션 |
|---|---|---|
| `hook` | 스크롤 멈춤 + 명사형 프로미스 | 풀블리드 사진/아티팩트, 제목 하단 중앙, accent 1단어 |
| `proof` | 신뢰 근거 | 큰 숫자 또는 source artifact crop, 카드 X |
| `feature_lens` | 능력 1개 → 3 핸들 | label → title → lead → 통합 evidence 패널 → tip strip |
| `workflow` | 입력→출력 / before→after | 좌우 2 stage + 코랄 화살표, 박스 X |
| `contrast` | A/B 비교 | 분할 캔버스 + 공통 디바이더, 두 박스 X |
| `source_artifact` | 출처 자체가 비주얼 | 아티팩트 블리드, 어두운 영역 텍스트 오버레이 |
| `save_reason` | 저장 동기 | 가운데 다크 CTA, 코랄 버튼 페어 |

#### Hero 미디어 5-tier 파이프라인 (사용자 검증 후 수정)
1. **GitHub og:image** — ≥1200×630 + 4:5 crop 안전 + 의미 있는 컨텐츠. White 톤 GitHub 자동 카드는 reject.
2. **README inline image** — 첫 비-배지 이미지, 폭≥600px
3. **Pexels stock** — 도메인 명사 + 다크 환경 키워드. 스마일 오피스/네온 해커/추상 그라디언트 reject. **2026-05-03 사용자 검증**: hero에서 Pexels가 source artifact보다 강함. 사진의 분위기는 artifact가 못 만듦.
4. **Source artifact** — README crop / file tree / star widget을 다크 에디토리얼로 렌더. **hero용 X, 슬라이드 2-3 contextual texture로만**.
5. **Typographic hero** — repo명 거대 텍스트 + 거대 stat 숫자, 의도된 표지로

**중요한 수정**: codex Round 1b에서 obsidian-skills를 source artifact hero로 권고했지만 실제 렌더 후 사용자가 "v1보다 hero 약함" 직감으로 reject. 사진 hero(Tier 3)로 복원하니 v1 grammar 회복. **교훈: artifact는 information을 주지만 atmosphere는 못 줌. Hero는 무조건 photo 우선.**

#### 슬라이드 통일성 원칙
- 카드 스택 X — 하나의 master artifact를 점진 줌인하는 editorial loop
- 카드 X — translucent panel 1개 단위로 evidence 묶기
- 컴포넌트 X → 콘텐츠 역할(role) X → 렌더러가 zone/scale/photo crop/density 결정

### 타이포 스케일 (1080×1350)
- Hero: 76–92px / weight 900 / lh 1.08–1.12
- H1: 56–66px / 900
- Body: 30–34px / 500 / lh 1.5
- Caption: 22–26px / 700–800
- Stat: 96–128px / 900
- 폰트: Wanted Sans Variable (v1과 동일)

### AI 말투 회피 12 패턴 (codex Round 1)
1. "~할 수 있어요" 종결 반복 → "맞춰요/손봐요/바꿔요"로 다양화
2. "정말/매우/너무" 부사 남발
3. "이런 분들에게 추천해요" 자동 섹션
4. "~를 만들어주는 ~AI" 정형 hook
5. "~도와줘요" 반복
6. 추상 장점어 ("효율적인 작업 가능") → 구체 행동
7. 과한 친절체 ("~하시면 좋을 것 같아요")
8. 영어 개념 남발 ("워크플로우 최적화")
9. 동일 길이 문장 반복 (리듬 깸)
10. CTA 클리셰 ("좋았다면 저장")
11. 비개발자에 코드 냄새 ("JSON 스키마 파싱")
12. 근거 없는 과장 ("생산성 폭발")

**Smell test 2줄**:
1. 도구 이름 빼도 아무 도구에 붙으면 fail
2. "그래서 뭘 시키면 되는데?"에 즉답 가능하면 pass

### 검증 결과 (obsidian-skills 케이스)
- **Codex 디자인 (Round 3 verify)**: 8.2/10 vs v1 → "ship. Now better than v1: more distinctive, more source-specific, still readable."
- **Content-marketer 카피 (Round 4)**: 초안 3.5/10 → 5/6 슬라이드 dev jargon fix 적용 (JSON/node/edge/CLI 제거, 비개발자 한글로). 재평가 미실시.
- **Codex 세션 ID** (resume용): `019decd8-ee31-7062-ade1-dc53408a2fb7`

### 잔여 작업 (다음 세션)
0. **사진 hero 복원 완료** — Pexels code shot으로 slide 1 + slide 6 갱신. atmospheric immediacy 회복 (2026-05-03).
0a. **K-beauty 도메인 일반화 검증 완료** (2026-05-04) — 동아일보 K-뷰티 M&A 3.6조 기사로 6슬라이드 합성. role 카탈로그 + 액센트 시프트(코랄→로즈 #FF4F7B) + 브랜드 시프트(@beauty_brief_kr/BEAUTY BRIEF/BB) 모두 작동. 데이터 시각화(M&A 표·막대그래프·주가 ticker) night-mag 톤으로 합성 가능 확인. 위치: `docs/v2-mockup/night-mag/{artifacts-kbeauty,slides-kbeauty}/`. 통일성 표준 확정: inner slide label/title top 200/280, title 64px, lead 30px width 880, 하단 strip padding 22+28 font 26/700.
0b. **spec + CLAUDE.md 갱신 완료 (2026-05-10)** — 기존 spec 폐기 대신 §3-4(7-role)/§5-5(night-mag tokens + 통일성 표준)/§5-7(Hero 5-tier + HeroMedia 모델)/§6-3-A(AI말투 12패턴 placeholder)/§10-1(후속 작업 표) 추가. CLAUDE.md는 night-mag 테마 row + 7-role/5-tier/통일성/AI톤 placeholder 섹션 추가. 커밋: c1a503d (CLAUDE.md), d9d515a (spec). **단, 새 파일 `2026-05-03-night-mag-role-system-design.md`는 만들지 않고 기존 `2026-05-01-...` 확장 방식 채택.**
1. **AI말투 12패턴 인라인** — 이 메모리 70~81줄에 이미 12개 패턴 명시되어 있음. spec §6-3-A는 placeholder + 카테고리 제목만. 다음 작업 1순위로 `src/engine/prompts/ai_tone_antipatterns.txt` 생성 + spec §6-3-A 갱신 + smell test 2줄도 함께.
2. **HC/BB 아바타 placeholder 교체** — codex 유일한 잔여 지적. 실제 계정 마크 PNG로
3. **다른 케이스 일반화 검증** — paper2code(사진 강함) / FinceptTerminal(스크린샷) / news 도메인. 7-role 카탈로그가 도메인 넘어 작동하는지
4. **HANDOFF.md §11 갱신** — 에메랄드 화이트 → Night Magazine 다크 결정사항으로 교체 (spec/CLAUDE.md 끝나도 HANDOFF는 옛 결정 그대로)
5. **구현 영향**:
   - `templates/v2/styles/tokens.css` 재작성
   - `templates/v2/blocks/*.html` → role 기반 로 재구조화
   - `src/engine/prompts/system_block_engine.txt` → role 출력 + media_intent JSON 스키마
   - `src/engine/block_renderer.py` → role + art-direction 레이어 (photo treatment, gradient stops, source artifact 생성)
   - `src/models/blocks.py` → role 모델 + media_intent

### v1 vs v2 핵심 차이 (재정리)
- v1: 다크 + 사진 hero + 코랄 액센트 + FEATURE 라벨 + 3-카드 + tip box (검증된 매거진 패턴)
- v2: v1 DNA 계승 + role 기반 art direction + source artifact 미디어 우선 + dev jargon 제거 + Korean 비개발자 톤 강화

### 위치 정리
- v1 (production): `/Users/hangryongcho/instagram-feed-generator/` (master 브랜치)
- v2 (active dev): `/Users/hangryongcho/instagram-feed-generator-v2/` (v2/main 브랜치, worktree 분리)
- v1 출력 (디자인 참고): `instagram-feed-generator/data/outputs/2026042?_*/` (4월 25일 이후 23개 폴더)
- v2 mockup 새 (2026-05-03): `instagram-feed-generator-v2/docs/v2-mockup/night-mag/`
  - `slides/`, `artifacts/` — obsidian-skills 케이스 (GitHub @hot_code_pieces 코랄)
  - `slides-kbeauty/`, `artifacts-kbeauty/` — K-beauty M&A 케이스 (BEAUTY BRIEF 로즈)
- v2 mockup 옛 (2026-05-01, 보존): `instagram-feed-generator-v2/docs/v2-mockup/preview.html`

### 재개 시 첫 메시지 패턴
```
"v2 이어서. spec/CLAUDE.md 갱신 완료(c1a503d, d9d515a). 다음은 AI말투 12패턴 인라인(이 메모리 70~81줄 → ai_tone_antipatterns.txt) 또는 paper2code 사진강한 repo 검증."
```
→ 검증된 케이스: obsidian-skills (텍스트 repo, 코랄), K-beauty M&A (뉴스/데이터, 로즈). 문서 갱신 완료. 다음 후보 우선순위: (1) AI 12패턴 인라인 (가장 작은 단위, prompts/ai_tone_antipatterns.txt) → (2) paper2code 사진강한 repo 검증 → (3) HC/BB 아바타 → (4) HANDOFF §11.

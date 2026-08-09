---
name: project-honyongnyul-program
description: "혼용률관리프로그램(무신사↔eX-Craft HBL 매칭·혼용율 표기) — ~/Desktop/japancustoms/honyongnyul-program, Chohangryong/honyongnyul-program. v0.3.14 큰따옴표·<br>·꺾쇠라벨 정제, AA 신형식, 7월 실데이터 검증, CI는 태그 푸시만 빌드"
metadata: 
  node_type: memory
  type: project
  originSessionId: 92106622-6ad1-4dc6-886d-bdf172ef011d
  modified: 2026-07-30T14:36:11.893Z
---

**혼용률관리프로그램** — 무신사 주문 엑셀 상품명을 eX-Craft HBL List와 매칭해 HBL 순서 그대로 혼용율(+성별·소재·HS)을 채워 업로드 양식으로 출력하는 Windows 데스크톱 앱(pywebview). 해커톤(musinsa-plugin)과 **완전 별개**.

- 위치: `~/Desktop/japancustoms/honyongnyul-program/`, remote `Chohangryong/honyongnyul-program`. 인수인계=HANDOVER.md, 이력=CHANGELOG.md(형식: `## 날짜 (vX.Y.Z) — 제목` + 배경 + ### 변경).
- **⚠️ 로컬이 뒤처질 수 있음**: 2026-07-30 세션에서 로컬이 origin/main보다 14커밋 뒤였음(구버전 분석 후 재검증 필요했음). **작업 시작 전 반드시 `git fetch` + pull**.
- 버전은 `pyproject.toml`과 `src/honyongnyul/__init__.py` 두 곳(동시 범프). **CI는 태그 `v*` 푸시 또는 workflow_dispatch에서만 빌드**(main 푸시론 안 돎). **v0.3.14 릴리스 발행 완료(2026-07-30, 최초의 CI 성공)** — 성공까지 3연쇄 수정 필요했음: ①워크플로우 job env `PYTHONUTF8: "1"`(Windows 러너 cp1252에서 한글 print 크래시) ②build_app.ps1 UTF-8 **BOM 필수**(PS 5.1이 no-BOM을 ANSI로 읽어 파스 에러) ③venv 하드코딩→시스템 python 폴백. GitHub는 릴리스 자산의 한글 파일명을 정규화(`혼용률관리_Setup`→`_Setup_0.3.14.exe`)하나 updater.py는 `.exe` suffix 매칭이라 무관.
- **AA열(수정상품명) 신형식**: 2026-07부터 `상품명 / 소재 / 혼용율`(상품명 맨 앞). v0.3.2~0.3.9에서 `_aa_extract`(위치 무관 상품명 제거)+행 단위 출처 자동판별(①AA→②P열→③AA표기→④빈값)로 이미 대응됨. 7월 실측 분포: AA추출 63.9%/P열 30.2%/빈값 4.1%/AA표기 1.9%.
- **v0.3.14(2026-07-30)**: `clean_faithful`에 큰따옴표류 제거(&quot; 유래 `"`가 eX-Craft 웹그리드 TSV 붙여넣기를 깨뜨림 — 홑따옴표 LAMB'S류는 보존), `<br>`→' / ', `<SHELL>` 꺾쇠라벨→'SHELL: ', 비교연산자 `<숫자` 보존, `/ /` 압축, 전각 ＂ 포함. 캐시(SkuMaster)는 raw에서 매 실행 재정제라 정제기 수정은 즉시 반영(SCHEMA_VERSION 범프 불필요).
- **검증 방법론(재사용 가치)**: 7월 실데이터 `~/Downloads/JP_delivery_2026-07-28/`(14파일 181,396행)로 census(출처선택 로직 복제)+수정 전후 행 단위 diff(git worktree로 구버전 격리)+실앱 E2E(`Api.run_files`→`write_upload` 재독). msoffcrypto-tool 미설치면 테스트 1개 실패(pip install).
- 미해결: ① Item 컬럼=HBL 원문 무정제(셀 내 줄바꿈 시 붙여넣기 행 붕괴 위험, HBL 실파일 미확보로 실측 못함) ② 전체리스트 '원본명(AA)' 컬럼에 실제 따옴표 2행(복붙 범위에 포함하면 위험) ③ eX-Craft 업로드 실헤더 확정(HANDOVER §6).

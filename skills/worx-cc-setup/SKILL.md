---
name: worx-cc-setup
description: 신규 입사자 개발 환경 자동 설치 (Python, Git, uv, oh-my-claudecode, Chrome 확장). OS 자동 감지, 에러 자가 복구 포함.
---

# Worxphere 신규 입사자 개발 환경 자동 설치

You are an automated development environment setup assistant for new Worxphere employees.

## 핵심 원칙

- 각 단계는 **Check → Install → Verify** 순서로 진행한다.
- 명령이 실패하면 즉시 멈추지 말고 원인을 분석하고 대안을 시도한다.
- 이미 설치된 항목은 건너뛴다.

## Step 0: 환경 감지

`uname -s` 와 `/proc/version` 으로 OS를 판별한다.
- `Darwin` → macOS 경로
- `Linux` + `microsoft` in `/proc/version` → WSL 경로

---

## macOS 경로 요약

### Step 1: Homebrew
- Check: `brew --version`
- 없으면 공식 설치 스크립트 실행
- Apple Silicon / Intel 분기 처리 후 PATH 적용
- 실패 시: `Permission denied` → 소유권 수정 후 재시도

### Step 2: Python 3.12+
- Check: `python3 --version` 이 3.12+ 인지 확인
- `brew install python@3.12`
- Verify: `$(brew --prefix python@3.12)/bin/python3.12 --version` 로 전체 경로 사용
- 실패 시: `brew update && brew install python@3.12` 재시도. pyenv 충돌 시 `brew link --overwrite python@3.12`

### Step 3: Git
- Check: `git --version`
- `brew install git`
- 실패 시: Xcode CLT 설치 안내 (`xcode-select --install`)

### Step 4: uv
- Check: `uv --version` 또는 `$HOME/.local/bin/uv --version`
- `curl -LsSf https://astral.sh/uv/install.sh | sh`
- **PATH는 `source` 대신 `export PATH="$HOME/.local/bin:$PATH"` 로 현재 세션에 즉시 적용**
- Verify: 반드시 `$HOME/.local/bin/uv --version` (전체 경로) 로 확인
- 실패 시: `wget` 대체 시도, 파일 존재 여부 `ls -la $HOME/.local/bin/uv` 확인

### Step 5: oh-my-claudecode (사용자 직접 입력 필요)
Slash command는 bash 실행 불가. 사용자에게 아래 순서 안내:
1. `/plugin marketplace add https://github.com/Yeachan-Heo/oh-my-claudecode`
2. `/plugin install oh-my-claudecode`
3. `/reload-plugins`
4. `/setup`
5. `/omc-setup`

### Step 6: Chrome "Claude" 확장
- `open <url>` 으로 Chrome Web Store 열기
- 실패 시 URL을 사용자에게 직접 안내

---

## WSL 경로 요약

### Step 1: apt 업데이트
- `sudo apt-get update -q`
- 실패 시: `--fix-missing` 재시도, DNS 문제면 `/etc/resolv.conf` 수정

### Step 2: Python 3.12+
- Check: `python3 --version` 이 3.12+ 인지 확인
- 기본: `sudo apt-get install -y python3.12 python3.12-venv`
- **실패 시 자가 복구**: Ubuntu 22.04는 기본 apt에 없을 수 있음 → deadsnakes PPA 추가
  ```
  sudo add-apt-repository -y ppa:deadsnakes/python3
  sudo apt-get update -q && sudo apt-get install -y python3.12 python3.12-venv
  ```

### Step 3: Git
- `sudo apt-get install -y git`

### Step 4: uv
- curl 먼저 확인/설치
- macOS와 동일한 설치 방식, PATH는 `~/.bashrc` 에 영구 등록
- Verify: `$HOME/.local/bin/uv --version` (전체 경로)

### Step 5: Google Chrome
- Check: `google-chrome --version`
- wget 없으면 먼저 설치
- `/tmp/chrome.deb` 에 다운로드 후 설치 (작업 디렉토리 오염 방지)
- 실패 시: `curl -Lo` 대체, 의존성 오류 시 `sudo apt-get install -f -y`

### Step 6: 한국어 로캘
- `sudo apt-get install -y language-pack-ko`
- 실패 시: `locale-gen ko_KR.UTF-8`

### Step 7: oh-my-claudecode (사용자 직접 입력 필요)
macOS Step 5와 동일.

### Step 8: Chrome 확장
- `xdg-open <url>` 시도
- 실패(WSL GUI 없음) 시: Windows Chrome에서 URL 직접 접속 안내

---

## 공통 자가 복구 원칙

오류 발생 시 순서:
1. 오류 키워드 분류: `permission` / `not found` / `network` / `dependency`
2. 원인별 대응 시도 (sudo 추가, 전체 경로, 네트워크 재시도, apt -f 등)
3. 3회 실패 후에는 사용자에게 오류 내용 + 해결 방법 보고

---

## Final Summary

검증 명령 실행 후 결과 테이블 출력:

| 구성 요소 | 버전 | 담당 | 상태 |
|-----------|------|------|------|
| Python | (version) | Claude 자동 | ✓/✗ |
| Git | (version) | Claude 자동 | ✓/✗ |
| uv | (version) | Claude 자동 | ✓/✗ |
| Chrome | (version) | Claude 자동 (WSL만) | ✓/✗ |
| oh-my-claudecode | - | 사용자 직접 입력 | 확인 필요 |
| Chrome 확장 (Claude) | - | 사용자 직접 클릭 | 확인 필요 |

✗ 항목은 원인과 해결 방법을 함께 안내한다.
완료 후 MCP 연동(Slack/Notion) 다음 단계 안내.

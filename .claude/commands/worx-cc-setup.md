---
description: "개발 환경 자동 설치 (Python, Git, uv, oh-my-claudecode, Chrome 확장)"
allowed-tools: Bash, Read, Write, Edit
---

# Worxphere 신규 입사자 개발 환경 자동 설치

You are an automated development environment setup assistant for new Worxphere employees.

## 핵심 원칙

- 각 단계는 **Check → Install → Verify** 순서로 진행한다.
- 명령이 실패하면 즉시 멈추지 말고, 아래 **자가 복구 절차**를 먼저 시도한다.
- 자가 복구에도 실패하면 사용자에게 오류 내용과 해결 방법을 명확히 안내한다.
- 이미 설치된 항목은 건너뛴다.

---

## Step 0: 환경 감지

```bash
uname -s && cat /proc/version 2>/dev/null || true
```

판단 기준:
- `Darwin` → **macOS** 경로
- `Linux` + `/proc/version`에 `microsoft` 포함 → **WSL** 경로
- `Linux` + 그 외 → macOS 경로와 동일하게 진행 (brew 대신 apt 사용)

---

## macOS 경로

### Step 1: Homebrew

**Check:**
```bash
brew --version 2>/dev/null
```

이미 있으면 건너뜀.

**Install (없을 때):**

Homebrew 설치 스크립트는 sudo 비밀번호 입력을 요구하므로 사용자가 직접 실행해야 한다.
사용자에게 안내:

> Homebrew가 설치되어 있지 않습니다. 아래 명령을 Claude Code 입력창에 붙여넣어 주세요:
>
> `! /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
>
> 설치 중 비밀번호 입력이 필요합니다. 완료 후 알려주세요.

사용자가 완료 확인 후 다음 검증으로 진행.

**설치 후 PATH 적용:**
```bash
# Apple Silicon
if [ -f /opt/homebrew/bin/brew ]; then
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi
# Intel Mac
if [ -f /usr/local/bin/brew ]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi
```

**Verify:**
```bash
brew --version
```

**실패 시 자가 복구:**
- `curl` 실패 → 네트워크 확인 후 재시도
- `Permission denied` → `sudo chown -R $(whoami) /usr/local/bin /usr/local/lib 2>/dev/null; sudo chown -R $(whoami) /opt/homebrew 2>/dev/null` 후 재시도
- 그래도 실패하면 사용자에게: "Homebrew 설치 중 오류가 발생했습니다. 오류 메시지를 알려주시면 원인을 분석해드립니다."

---

### Step 2: Python 3.12+

**Check:**
```bash
python3 --version 2>/dev/null | grep -E "3\.(1[2-9]|[2-9][0-9])" && echo "OK" || echo "NEED_INSTALL"
```

이미 3.12 이상이면 건너뜀.

**Install:**
```bash
brew install python@3.12
```

**Verify:**
```bash
python3.12 --version 2>/dev/null || $(brew --prefix python@3.12)/bin/python3.12 --version
```

**실패 시 자가 복구:**
- `brew install python@3.12` 실패 → `brew update && brew install python@3.12`
- `python3.12` 명령을 못 찾음 → `$(brew --prefix python@3.12)/bin/python3` 로 직접 실행
- pyenv가 설치된 경우 pyenv가 Python을 가로채는 경우 있음 → `brew link --overwrite python@3.12` 시도

---

### Step 3: Git

**Check:**
```bash
git --version 2>/dev/null
```

있으면 건너뜀.

**Install:**
```bash
brew install git
```

**Verify:**
```bash
git --version
```

**실패 시 자가 복구:**
- Xcode Command Line Tools 관련 오류 → `xcode-select --install` 안내 (사용자 수동 클릭 필요)
- 그 외 → `brew doctor` 실행 후 나온 경고 메시지 분석하여 조치

---

### Step 4: uv

**Check:**
```bash
uv --version 2>/dev/null || $HOME/.local/bin/uv --version 2>/dev/null
```

있으면 건너뜀.

**Install:**
```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

**PATH 적용 (설치 직후 현재 세션에 즉시 반영):**
```bash
export PATH="$HOME/.local/bin:$PATH"
# zshrc에도 영구 등록 (중복 방지)
grep -q '$HOME/.local/bin' ~/.zshrc 2>/dev/null || echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
```

**Verify:**
```bash
$HOME/.local/bin/uv --version
```

> `uv --version`이 아닌 `$HOME/.local/bin/uv --version`을 사용한다. `source ~/.zshrc`는 현재 세션 적용이 불안정하므로 설치 직후 전체 경로로 검증.

**실패 시 자가 복구:**
- `curl` 실패 → `wget -qO- https://astral.sh/uv/install.sh | sh` 로 재시도
- 설치 후에도 못 찾음 → `ls -la $HOME/.local/bin/uv` 로 파일 존재 확인, 없으면 재설치

---

### Step 5: oh-my-claudecode (사용자 직접 입력 필요)

**Check (설치 여부 확인):**
```bash
ls ~/.claude/plugins/oh-my-claudecode 2>/dev/null && echo "INSTALLED" || echo "NOT_INSTALLED"
```

이미 설치되어 있으면 ("INSTALLED") 건너뜀. 사용자에게:
> oh-my-claudecode가 이미 설치되어 있습니다. 다음 단계로 넘어갑니다.

**Install (NOT_INSTALLED일 때):**

Slash command는 bash에서 실행할 수 없어 사용자가 직접 입력해야 한다.

사용자에게 안내:

> Claude Code 입력창에 아래 명령을 **순서대로** 입력해 주세요. 각 명령 실행 후 완료 메시지를 확인하고 다음으로 넘어가세요.
>
> 1. `/plugin marketplace add https://github.com/Yeachan-Heo/oh-my-claudecode`
> 2. `/plugin install oh-my-claudecode`
> 3. `/reload-plugins`
> 4. `/setup`
> 5. `/omc-setup`

사용자가 완료 확인 후 다음으로 진행.

---

### Step 6: Chrome "Claude" 확장

**브라우저 열기:**
```bash
open "https://chromewebstore.google.com/detail/claude/fcoeoabgfenejglbffodgkkbkcdhcgfn"
```

사용자에게 안내:

> Chrome Web Store 페이지가 열렸습니다. **"Chrome에 추가"** 버튼을 클릭하여 설치해 주세요.
>
> 설치 확인:
> 1. `chrome://extensions` 에서 "Claude" by Anthropic이 활성화 상태인지 확인
> 2. `https://claude.ai` 접속 후 우측 하단에 확장 아이콘이 보이는지 확인

**실패 시 자가 복구:**
- `open` 명령 실패 → 사용자에게 URL 직접 안내: "Chrome에서 다음 주소를 열어주세요: `https://chromewebstore.google.com/detail/claude/fcoeoabgfenejglbffodgkkbkcdhcgfn`"

---

## WSL (Windows) 경로

### Step 1: 패키지 목록 업데이트

```bash
sudo apt-get update -q
```

**실패 시 자가 복구:**
- `Failed to fetch` → DNS 또는 네트워크 문제. `sudo apt-get update --fix-missing` 재시도
- 계속 실패 → `/etc/resolv.conf`에 `nameserver 8.8.8.8` 추가 후 재시도

---

### Step 2: Python 3.12+

**Check:**
```bash
python3 --version 2>/dev/null | grep -E "3\.(1[2-9]|[2-9][0-9])" && echo "OK" || echo "NEED_INSTALL"
```

있으면 건너뜀.

**Install (기본 시도):**
```bash
sudo apt-get install -y python3.12 python3.12-venv 2>&1
```

**실패 시 자가 복구 — deadsnakes PPA 사용:**

Ubuntu 22.04 기본 apt에는 python3.12가 없는 경우가 있다. 실패하면:
```bash
sudo apt-get install -y software-properties-common
sudo add-apt-repository -y ppa:deadsnakes/python3
sudo apt-get update -q
sudo apt-get install -y python3.12 python3.12-venv
```

**Verify:**
```bash
python3.12 --version
```

**그래도 실패 시:**
- Ubuntu 버전 확인: `lsb_release -a`
- Ubuntu 20.04 이하라면 deadsnakes PPA가 필요함을 안내
- 사용자에게: "Python 3.12 설치 중 문제가 발생했습니다. 오류 메시지를 알려주시면 해결 방법을 찾아드립니다."

---

### Step 3: Git

**Check:**
```bash
git --version 2>/dev/null
```

있으면 건너뜀.

**Install:**
```bash
sudo apt-get install -y git
```

**Verify:**
```bash
git --version
```

---

### Step 4: uv

**Check:**
```bash
uv --version 2>/dev/null || $HOME/.local/bin/uv --version 2>/dev/null
```

있으면 건너뜀.

**필요 도구 확인:**
```bash
curl --version 2>/dev/null || sudo apt-get install -y curl
```

**Install:**
```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

**PATH 적용:**
```bash
export PATH="$HOME/.local/bin:$PATH"
grep -q '$HOME/.local/bin' ~/.bashrc 2>/dev/null || echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
```

**Verify:**
```bash
$HOME/.local/bin/uv --version
```

**실패 시 자가 복구:**
- curl 없음 → `sudo apt-get install -y curl` 후 재시도
- 설치 후에도 못 찾음 → `ls -la $HOME/.local/bin/uv` 로 파일 존재 확인

---

### Step 5: Google Chrome

**Check:**
```bash
google-chrome --version 2>/dev/null || google-chrome-stable --version 2>/dev/null
```

있으면 건너뜀.

**wget 확인 (Chrome .deb 다운로드에 필요):**
```bash
wget --version 2>/dev/null || sudo apt-get install -y wget
```

**Install:**
```bash
wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /tmp/chrome.deb
sudo apt install -y /tmp/chrome.deb
rm -f /tmp/chrome.deb
```

**Verify:**
```bash
google-chrome --version 2>/dev/null || google-chrome-stable --version
```

**실패 시 자가 복구:**
- `wget` 실패 → `curl -Lo /tmp/chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb` 로 재시도
- `dpkg` 의존성 오류 → `sudo apt-get install -f -y` 후 재시도
- WSL에서 Chrome 실행 자체는 불가 (GUI 없음) — 확장 설치는 Windows 쪽 Chrome에서 진행

---

### Step 6: 한국어 로캘

```bash
sudo apt-get install -y language-pack-ko
locale -a | grep ko
```

**실패 시:** `locale-gen ko_KR.UTF-8` 재시도

---

### Step 7: oh-my-claudecode (사용자 직접 입력 필요)

macOS Step 5와 동일. 먼저 설치 여부를 확인한다:
```bash
ls ~/.claude/plugins/oh-my-claudecode 2>/dev/null && echo "INSTALLED" || echo "NOT_INSTALLED"
```

이미 설치되어 있으면 건너뜀. 없으면 macOS Step 5와 동일하게 사용자에게 slash command 직접 입력 안내.

---

### Step 8: Chrome "Claude" 확장

WSL에서는 `xdg-open`이 동작하지 않을 수 있으므로 아래 방식 순서로 시도:

```bash
xdg-open "https://chromewebstore.google.com/detail/claude/fcoeoabgfenejglbffodgkkbkcdhcgfn" 2>/dev/null && echo "OPENED" || echo "FALLBACK"
```

`FALLBACK`이 출력되면 사용자에게:

> WSL 환경에서는 Windows Chrome에서 직접 설치해야 합니다.
> **Windows Chrome 주소창에 아래 URL을 붙여넣어 주세요:**
> `https://chromewebstore.google.com/detail/claude/fcoeoabgfenejglbffodgkkbkcdhcgfn`

---

## 공통 자가 복구 원칙

각 단계에서 예상치 못한 오류가 발생하면 아래 순서로 진행:

1. **오류 메시지 분석**: 오류의 핵심 키워드를 파악한다 (permission, network, not found, dependency 등)
2. **원인별 대응**:
   - `Permission denied` → `sudo` 추가 또는 소유권 확인
   - `command not found` → PATH 미적용. 전체 경로로 재시도
   - `network` / `fetch` / `curl` 오류 → 네트워크 상태 확인 후 재시도
   - `dependency` 오류 → `sudo apt-get install -f -y` (WSL) 또는 `brew doctor` (Mac)
3. **재시도**: 위 조치 후 동일 명령 재실행
4. **사용자 안내**: 3회 시도 후에도 실패 시 오류 메시지와 함께 사용자에게 명확히 보고

---

## Final Summary

모든 단계 완료 후 검증 실행:

```bash
python3 --version 2>/dev/null || python3.12 --version 2>/dev/null
git --version 2>/dev/null
$HOME/.local/bin/uv --version 2>/dev/null || uv --version 2>/dev/null
google-chrome --version 2>/dev/null || echo "Chrome: WSL은 Windows 쪽에서 확인"
```

결과를 아래 형식으로 출력:

| 구성 요소 | 설치된 버전 | 담당 | 상태 |
|-----------|------------|------|------|
| Python    | (version)  | Claude 자동 | ✓ / ✗ |
| Git       | (version)  | Claude 자동 | ✓ / ✗ |
| uv        | (version)  | Claude 자동 | ✓ / ✗ |
| Chrome    | (version)  | Claude 자동 (WSL만) | ✓ / ✗ |
| oh-my-claudecode | - | 사용자 직접 입력 | 확인 필요 |
| Chrome 확장 (Claude) | - | 사용자 직접 클릭 | 확인 필요 |

✗ 항목이 있으면 해당 항목 아래에 실패 원인과 해결 방법을 안내한다.

---

완료 후 사용자에게:

> **다음 단계 — MCP 연동 (선택)**
>
> Slack과 Notion을 연결하려면, 발급받은 토큰을 아래 형식으로 붙여넣어 주세요.
> Claude가 `claude mcp add` 명령을 자동으로 실행합니다.
>
> ```
> MCP 연동을 설정해줘.
> - Slack Bot Token: xoxb-{내 토큰}
> - Slack Team ID: T{내 팀ID}
> - Notion API 키: ntn_{내 키}
> 위 정보로 Slack MCP와 Notion MCP를 연결하고 동작 확인까지 해줘.
> ```
>
> 토큰이 아직 없다면 [사전 준비 가이드](https://www.notion.so/worxphere/5cfa0407c6984f9f821af962d32e1e7a)를 참고하세요.

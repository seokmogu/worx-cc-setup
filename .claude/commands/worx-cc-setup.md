---
description: "개발 환경 자동 설치 (Python, Git, uv, oh-my-claudecode, Chrome 확장)"
allowed-tools: Bash, Read, Write, Edit
---

# Worxphere 신규 입사자 개발 환경 자동 설치

You are an automated development environment setup assistant for new Worxphere employees.
Your job is to detect the OS, install all required tools, and verify each step before proceeding.

## Step 0: OS Detection

Detect the operating system by running `uname -s` and checking for WSL indicators.

```bash
uname -s
```

- If the output is "Darwin", this is **macOS**. Follow the **Mac/Linux** steps.
- If the output is "Linux", check for WSL by running `grep -qi microsoft /proc/version 2>/dev/null`. If found, follow the **Windows/WSL Ubuntu** steps. Otherwise, follow the **Mac/Linux** steps (treating it as native Linux with brew or equivalent).

---

## Mac/Linux Steps

### Step 1: Python 3.12+

Check if Python 3.12+ is already installed:

```bash
python3 --version 2>/dev/null || python --version 2>/dev/null
```

If not installed or version is below 3.12, install via Homebrew:

```bash
brew install python@3.12
```

Verify installation:

```bash
python3.12 --version
```

### Step 2: Git

Check if Git is already installed:

```bash
git --version 2>/dev/null
```

If not installed, install via Homebrew:

```bash
brew install git
```

Verify installation:

```bash
git --version
```

### Step 3: uv

Check if uv is already installed:

```bash
uv --version 2>/dev/null
```

If not installed, install via curl:

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

After installation, add uv to PATH. Detect the user's shell and append to the appropriate rc file:

- For zsh (`~/.zshrc`): append `export PATH="$HOME/.local/bin:$PATH"` if not already present
- For bash (`~/.bashrc`): append `export PATH="$HOME/.local/bin:$PATH"` if not already present

Then source the rc file so uv is available in the current session:

```bash
source ~/.zshrc  # or ~/.bashrc
```

Verify installation:

```bash
uv --version
```

### Step 4: oh-my-claudecode (사용자 직접 입력 필요)

oh-my-claudecode는 Claude Code 세션 안에서 slash command로만 설치할 수 있습니다.
아래 명령을 Claude Code 입력창에 **순서대로 직접 입력**해 주세요.

Tell the user:

> oh-my-claudecode 설치를 위해 아래 명령을 Claude Code 입력창에 순서대로 입력해 주세요:
>
> 1. `/plugin marketplace add https://github.com/Yeachan-Heo/oh-my-claudecode`
> 2. `/plugin install oh-my-claudecode`
> 3. `/reload-plugins`
> 4. `/setup`
> 5. `/omc-setup`
>
> 각 명령 실행 후 완료 메시지를 확인하고 다음으로 넘어가세요.

Wait for the user to confirm each step is complete before proceeding.

### Step 5: Chrome "Claude" Extension

Open the Chrome Web Store page for the Claude extension in the default browser:

```bash
open "https://chromewebstore.google.com/detail/claude/fcoeoabgfenejglbffodgkkbkcdhcgfn"
```

Tell the user:
> Chrome Web Store 페이지가 열렸습니다. "Chrome에 추가" 버튼을 클릭하여 Claude 확장 프로그램을 설치해 주세요.

### Step 6: Chrome Extension Verification

Guide the user to verify the extension:

> 설치 확인 방법:
> 1. Chrome 주소창에 `chrome://extensions` 를 입력하세요.
> 2. "Claude" by Anthropic 확장 프로그램이 활성화되어 있는지 확인하세요.
> 3. `https://claude.ai` 에 접속하여 우측 하단에 확장 프로그램 아이콘이 보이는지 확인하세요.

---

## Windows/WSL Ubuntu Steps

### Step 1: Python 3.12+

Check if Python 3.12+ is already installed:

```bash
python3 --version 2>/dev/null
```

If not installed or version is below 3.12, install via apt:

```bash
sudo apt-get update && sudo apt-get install -y python3.12 python3.12-venv
```

Verify installation:

```bash
python3.12 --version
```

### Step 2: Git

Check if Git is already installed:

```bash
git --version 2>/dev/null
```

If not installed, install via apt:

```bash
sudo apt-get install -y git
```

Verify installation:

```bash
git --version
```

### Step 3: uv

Check if uv is already installed:

```bash
uv --version 2>/dev/null
```

If not installed, install via curl:

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

After installation, add uv to PATH. Detect the user's shell and append to the appropriate rc file:

- For zsh (`~/.zshrc`): append `export PATH="$HOME/.local/bin:$PATH"` if not already present
- For bash (`~/.bashrc`): append `export PATH="$HOME/.local/bin:$PATH"` if not already present

Then source the rc file:

```bash
source ~/.bashrc  # or ~/.zshrc
```

Verify installation:

```bash
uv --version
```

### Step 4: Chrome for Linux

Install Google Chrome for WSL/Linux:

```bash
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && sudo apt install -y ./google-chrome-stable_current_amd64.deb
```

Clean up the downloaded .deb file:

```bash
rm -f google-chrome-stable_current_amd64.deb
```

Verify installation:

```bash
google-chrome --version
```

### Step 5: Korean Locale

Install Korean language pack:

```bash
sudo apt-get install -y language-pack-ko
```

Verify:

```bash
locale -a | grep ko
```

### Step 6: oh-my-claudecode (사용자 직접 입력 필요)

Mac Step 4와 동일합니다. 아래 명령을 Claude Code 입력창에 **순서대로 직접 입력**해 주세요.

Tell the user:

> oh-my-claudecode 설치를 위해 아래 명령을 Claude Code 입력창에 순서대로 입력해 주세요:
>
> 1. `/plugin marketplace add https://github.com/Yeachan-Heo/oh-my-claudecode`
> 2. `/plugin install oh-my-claudecode`
> 3. `/reload-plugins`
> 4. `/setup`
> 5. `/omc-setup`
>
> 각 명령 실행 후 완료 메시지를 확인하고 다음으로 넘어가세요.

Wait for the user to confirm each step is complete before proceeding.

### Step 7: Chrome "Claude" Extension

Open the Chrome Web Store page:

```bash
xdg-open "https://chromewebstore.google.com/detail/claude/fcoeoabgfenejglbffodgkkbkcdhcgfn" 2>/dev/null || echo "브라우저에서 다음 URL을 열어주세요: https://chromewebstore.google.com/detail/claude/fcoeoabgfenejglbffodgkkbkcdhcgfn"
```

Tell the user:
> Chrome Web Store 페이지가 열렸습니다. "Chrome에 추가" 버튼을 클릭하여 Claude 확장 프로그램을 설치해 주세요.

### Step 8: Chrome Extension Verification

Guide the user to verify the extension (same as Mac Step 6):

> 설치 확인 방법:
> 1. Chrome 주소창에 `chrome://extensions` 를 입력하세요.
> 2. "Claude" by Anthropic 확장 프로그램이 활성화되어 있는지 확인하세요.
> 3. `https://claude.ai` 에 접속하여 우측 하단에 확장 프로그램 아이콘이 보이는지 확인하세요.

---

## Final Summary

After all steps are complete, run the following verification commands and compile results:

```bash
python3 --version 2>/dev/null || python3.12 --version 2>/dev/null
git --version 2>/dev/null
uv --version 2>/dev/null
```

Then display a summary table:

| 구성 요소 | 설치된 버전 | 담당 | 상태 |
|-----------|------------|------|------|
| Python    | 3.12.x     | Claude 자동 | ✓ |
| Git       | 2.x.x      | Claude 자동 | ✓ |
| uv        | 0.x.x      | Claude 자동 | ✓ |
| oh-my-claudecode | -   | 사용자 직접 입력 | 확인 필요 |
| Chrome 확장 (Claude) | - | 사용자 직접 클릭 | 확인 필요 |

If any Claude-automated step failed, mark it with ✗ and explain what went wrong.

After displaying the table, tell the user:

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

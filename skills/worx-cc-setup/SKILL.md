---
name: worx-cc-setup
description: 신규 입사자 개발 환경 자동 설치 (Python, Git, uv, oh-my-claudecode, Chrome 확장)
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
- If the output is "Linux", check for WSL: `grep -qi microsoft /proc/version 2>/dev/null && echo WSL || echo Linux`. If WSL, follow the **Windows/WSL Ubuntu** steps. Otherwise, follow the **Mac/Linux** steps.

---

## Mac/Linux Steps

### Step 1: Python 3.12+

```bash
brew install python@3.12
python3 --version
```

### Step 2: Git

```bash
brew install git
git --version
```

### Step 3: uv Package Manager

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

Add to PATH if not already set:
```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc && source ~/.zshrc
uv --version
```

### Step 4: oh-my-claudecode (사용자 직접 입력 필요)

Slash command는 bash에서 실행할 수 없으므로, 사용자에게 아래 안내를 제공하고 완료를 기다린다:

> Claude Code 입력창에 아래 명령을 순서대로 입력해 주세요:
>
> 1. `/plugin marketplace add https://github.com/Yeachan-Heo/oh-my-claudecode`
> 2. `/plugin install oh-my-claudecode`
> 3. `/reload-plugins`
> 4. `/setup`
> 5. `/omc-setup`

### Step 5: Chrome "Claude" Extension

Open this URL in Chrome and install the extension:
`https://chromewebstore.google.com/detail/claude/fcoeoabgfenejglbffodgkkbkcdhcgfn`

### Step 6: Verify Chrome Extension

Ask the user to:
1. Open `chrome://extensions` and confirm "Claude" by Anthropic is **enabled**
2. Visit `claude.ai` and confirm the extension icon appears in the bottom-right corner

---

## Windows/WSL Ubuntu Steps

### Step 1: Python 3.12+

```bash
sudo apt-get update && sudo apt-get install -y python3.12 python3.12-venv python3-pip
python3 --version
```

### Step 2: Git

```bash
sudo apt-get install -y git
git --version
```

### Step 3: uv Package Manager

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc && source ~/.bashrc
uv --version
```

### Step 4: Google Chrome for Linux

```bash
wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install -y ./google-chrome-stable_current_amd64.deb
rm google-chrome-stable_current_amd64.deb
google-chrome --version
```

### Step 5: Korean Locale

```bash
sudo apt-get install -y language-pack-ko
```

### Step 6: oh-my-claudecode (사용자 직접 입력 필요)

Mac Step 4와 동일하게 사용자에게 slash command 직접 입력을 안내한다.

### Step 7: Chrome "Claude" Extension

Mac Step 5–6과 동일.

---

## Final Summary

After all steps complete, run verification commands and print a summary table:

| 구성 요소 | 버전 | 담당 | 상태 |
|-----------|------|------|------|
| Python | (version) | Claude 자동 | ✓ |
| Git | (version) | Claude 자동 | ✓ |
| uv | (version) | Claude 자동 | ✓ |
| Chrome | (version) | Claude 자동 (WSL만) | ✓ |
| oh-my-claudecode | - | 사용자 직접 입력 | 확인 필요 |
| Chrome 확장 (Claude) | - | 사용자 직접 클릭 | 확인 필요 |

After the table, guide the user to the MCP setup step by asking them to paste their Slack/Notion tokens.

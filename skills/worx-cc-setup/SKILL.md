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

### Step 4: oh-my-claudecode

Run these slash commands in sequence inside Claude Code:
1. `/plugin marketplace add https://github.com/Yeachan-Heo/oh-my-claudecode`
2. `/plugin install oh-my-claudecode`
3. `/setup`
4. `/omc-setup`

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

### Step 6: oh-my-claudecode

Same as Mac steps 4 above.

### Step 7: Chrome "Claude" Extension

Same as Mac steps 5–6 above.

---

## Final Summary

After all steps complete, print a summary table:

| Component | Version | Status |
|-----------|---------|--------|
| Python | (version) | ✓ |
| Git | (version) | ✓ |
| uv | (version) | ✓ |
| Chrome | (version) | ✓ |
| oh-my-claudecode | installed | ✓ |
| Chrome Extension | active | ✓ |

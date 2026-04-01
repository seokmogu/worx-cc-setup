# worx-cc-setup

신규 입사자 개발 환경 자동 설치 플러그인 — Claude Code 로그인 후 `/worx-cc-setup` 한 줄로 완료

---

## 전체 순서

### Step 1 — VS Code 설치

[code.visualstudio.com](https://code.visualstudio.com) 에서 인스톨러 다운로드 후 설치.

---

### Step 2 — Claude Code 설치

#### Mac

터미널에서 실행:

```bash
brew install node
npm install -g @anthropic-ai/claude-code
claude
```

#### Windows (WSL2)

**PowerShell을 관리자 모드로 열고** 아래 두 줄을 순서대로 실행:

```powershell
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/seokmogu/worx-cc-setup/main/scripts/windows-setup.ps1" -OutFile "$env:TEMP\worx-setup.ps1"
```

```powershell
& "$env:TEMP\worx-setup.ps1"
```

> **관리자 모드로 여는 방법**: 시작 메뉴 → PowerShell 우클릭 → "관리자 권한으로 실행"

스크립트 완료 후 Ubuntu 터미널을 열고 `claude`를 실행해 로그인.

---

### Step 3 — 플러그인 설치

Claude Code 로그인 후 아래 두 줄 입력:

```
/plugin marketplace add https://github.com/seokmogu/worx-cc-setup
```

```
/plugin install worx-cc-setup
```

---

### Step 4 — 개발 환경 자동 설치

```
/worx-cc-setup
```

OS를 자동 감지하고 아래 항목을 순서대로 설치합니다.

| 항목 | 설명 |
|------|------|
| Python 3.12+ | 기본 개발 언어 런타임 |
| Git | 버전 관리 도구 |
| uv | 빠른 Python 패키지 매니저 |
| oh-my-claudecode | Claude Code 확장 플러그인 모음 |
| Chrome "Claude" 확장 | claude.ai 브라우저 확장 프로그램 |

Windows/WSL 환경에서는 추가로 Google Chrome과 한국어 로캘이 설치됩니다.

---

## 문제가 생기면

오류 메시지를 Claude에게 그대로 붙여넣으세요. Claude가 원인을 분석하고 해결 방법을 안내합니다.

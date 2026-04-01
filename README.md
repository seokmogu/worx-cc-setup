# worx-cc-setup

신규 입사자 개발 환경 자동 설치 플러그인 — Claude Code 로그인 후 `/worx-cc-setup` 한 줄로 완료

---

## Windows 사용자 — Claude Code 설치 전 먼저 실행

Claude Code가 없는 초기 상태라면 아래 스크립트로 WSL2 + Node.js + Claude Code를 자동 설치합니다.

**PowerShell을 관리자 모드로 열고** 아래 한 줄 실행:

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; irm https://raw.githubusercontent.com/seokmogu/worx-cc-setup/main/scripts/windows-setup.ps1 | iex
```

> **관리자 모드로 여는 방법**: 시작 메뉴 → PowerShell 우클릭 → "관리자 권한으로 실행"

스크립트가 완료되면 Ubuntu 터미널을 열고 `claude`를 실행해 로그인합니다.

---

## Claude Code 플러그인 설치 (로그인 후)

```
/plugin marketplace add https://github.com/seokmogu/worx-cc-setup
/plugin install worx-cc-setup
```

## 사용

```
/worx-cc-setup
```

실행하면 OS를 자동 감지하고 아래 항목을 순서대로 설치합니다.

## 설치되는 항목

| 항목 | 설명 |
|------|------|
| Python 3.12+ | 기본 개발 언어 런타임 |
| Git | 버전 관리 도구 |
| uv | 빠른 Python 패키지 매니저 |
| oh-my-claudecode | Claude Code 확장 플러그인 모음 |
| Chrome "Claude" 확장 | claude.ai 브라우저 확장 프로그램 |

Windows/WSL 환경에서는 추가로 Google Chrome과 한국어 로캘이 설치됩니다.

## 전제 조건

- VS Code 설치 완료 ([code.visualstudio.com](https://code.visualstudio.com))
- Claude Code 설치 및 로그인 완료 (위 Windows 스크립트 또는 직접 설치)

## 문제가 생기면

오류 메시지를 Claude에게 그대로 붙여넣으세요. Claude가 원인을 분석하고 해결 방법을 안내합니다.

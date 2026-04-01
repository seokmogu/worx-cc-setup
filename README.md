# worx-cc-setup

신규 입사자 개발 환경 자동 설치 플러그인 -- Claude Code 로그인 후 `/worx-cc-setup` 한 줄로 완료

## 전제 조건

- VS Code 설치 완료
- Claude Code 확장 프로그램 설치 및 로그인 완료

## 설치

```
/plugin marketplace add https://github.com/seokmogu/worx-cc-setup
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

## 문제가 생기면

오류 메시지를 Claude에게 그대로 붙여넣으세요. Claude가 원인을 분석하고 해결 방법을 안내합니다.

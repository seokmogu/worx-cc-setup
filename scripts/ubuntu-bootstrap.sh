#!/usr/bin/env bash
# Worxphere Ubuntu 부트스트랩 스크립트
# WSL Ubuntu 안에서 Node.js + Claude Code를 설치한다
# 실행 방법 (Ubuntu 터미널에서):
#   curl -fsSL https://raw.githubusercontent.com/seokmogu/worx-cc-setup/main/scripts/ubuntu-bootstrap.sh | bash

set -e

BOLD='\033[1m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
RESET='\033[0m'

step()  { echo -e "\n${CYAN}[STEP]${RESET} $1"; }
ok()    { echo -e "${GREEN}  [OK]${RESET} $1"; }
warn()  { echo -e "${YELLOW}  [!!]${RESET} $1"; }
err()   { echo -e "${RED} [ERR]${RESET} $1"; exit 1; }

echo -e "${BOLD}
  Worxphere CC Setup — Ubuntu Bootstrap
${RESET}"

# ── 1. 패키지 목록 업데이트 ────────────────────────────────────────
step "apt 패키지 목록 업데이트"
sudo apt-get update -q
ok "패키지 목록 업데이트 완료"

# ── 2. 기본 도구 설치 ──────────────────────────────────────────────
step "기본 도구 설치 (curl, ca-certificates)"
sudo apt-get install -y -q curl ca-certificates
ok "기본 도구 설치 완료"

# ── 3. Node.js 22.x 설치 ───────────────────────────────────────────
step "Node.js 22.x 설치"
if command -v node &>/dev/null; then
    NODE_VER=$(node --version)
    ok "Node.js 이미 설치됨: $NODE_VER"
else
    curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash - -q
    sudo apt-get install -y -q nodejs
    ok "Node.js 설치 완료: $(node --version)"
fi

# ── 4. Claude Code 설치 ────────────────────────────────────────────
step "Claude Code 설치"
if command -v claude &>/dev/null; then
    ok "Claude Code 이미 설치됨: $(claude --version 2>/dev/null || echo 'version unknown')"
else
    sudo npm install -g @anthropic-ai/claude-code --quiet
    ok "Claude Code 설치 완료: $(claude --version 2>/dev/null || echo 'installed')"
fi

# ── 5. 버전 요약 ───────────────────────────────────────────────────
echo -e "\n${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo -e "${BOLD}  설치 완료 요약${RESET}"
echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
printf "  %-20s %s\n" "Node.js"      "$(node --version 2>/dev/null || echo '❌')"
printf "  %-20s %s\n" "npm"          "$(npm --version 2>/dev/null || echo '❌')"
printf "  %-20s %s\n" "Claude Code"  "$(claude --version 2>/dev/null || echo '설치됨')"
echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"

echo -e "\n${GREEN}${BOLD}✅  완료! 다음 단계:${RESET}"
echo -e "
  1. Claude Code 실행 및 로그인:
     ${BOLD}claude${RESET}

  2. 로그인 후 아래 명령 입력:
     ${BOLD}/plugin marketplace add https://github.com/seokmogu/worx-cc-setup${RESET}
     ${BOLD}/plugin install worx-cc-setup${RESET}
     ${BOLD}/worx-cc-setup${RESET}

  Claude가 Python, Git, uv, Chrome, omc 등 나머지를 자동으로 설치합니다.
"

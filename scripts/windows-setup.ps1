# Worxphere Windows 사전 설치 스크립트
# 실행 방법: PowerShell을 관리자 모드로 열고 아래 명령 실행
#   Set-ExecutionPolicy Bypass -Scope Process -Force
#   irm https://raw.githubusercontent.com/seokmogu/worx-cc-setup/main/scripts/windows-setup.ps1 | iex

param(
    [switch]$SkipWslInstall
)

$ErrorActionPreference = "Stop"

function Write-Step($msg) { Write-Host "`n[STEP] $msg" -ForegroundColor Cyan }
function Write-OK($msg)   { Write-Host "  [OK] $msg" -ForegroundColor Green }
function Write-Warn($msg) { Write-Host "  [!!] $msg" -ForegroundColor Yellow }
function Write-Err($msg)  { Write-Host " [ERR] $msg" -ForegroundColor Red }

Write-Host @"

  ██╗    ██╗ ██████╗ ██████╗ ██╗  ██╗
  ██║    ██║██╔═══██╗██╔══██╗╚██╗██╔╝
  ██║ █╗ ██║██║   ██║██████╔╝ ╚███╔╝
  ██║███╗██║██║   ██║██╔══██╗ ██╔██╗
  ╚███╔███╔╝╚██████╔╝██║  ██║██╔╝ ██╗
   ╚══╝╚══╝  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝
  CC Setup - Windows 사전 설치 스크립트

"@ -ForegroundColor Magenta

# ── 1. 관리자 권한 확인 ──────────────────────────────────────────
Write-Step "관리자 권한 확인"
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Err "관리자 권한이 필요합니다."
    Write-Warn "PowerShell을 '관리자 권한으로 실행'한 후 다시 시도하세요."
    exit 1
}
Write-OK "관리자 권한 확인됨"

# ── 2. WSL2 설치 확인 ─────────────────────────────────────────────
Write-Step "WSL2 상태 확인"
$wslInstalled = $false
try {
    $wslStatus = wsl --status 2>&1
    if ($LASTEXITCODE -eq 0) { $wslInstalled = $true }
} catch {}

if (-not $wslInstalled -and -not $SkipWslInstall) {
    Write-Warn "WSL2가 설치되어 있지 않습니다. 설치를 시작합니다..."
    wsl --install
    Write-Warn @"

  WSL2 설치가 완료되었습니다.
  PC를 재시작한 후 Ubuntu 터미널을 열고 다음 명령을 실행하세요:

    curl -fsSL https://raw.githubusercontent.com/seokmogu/worx-cc-setup/main/scripts/ubuntu-bootstrap.sh | bash

"@
    Write-Host "지금 재시작하시겠습니까? (y/N): " -NoNewline
    $restart = Read-Host
    if ($restart -eq 'y' -or $restart -eq 'Y') { Restart-Computer -Force }
    exit 0
} elseif ($wslInstalled) {
    Write-OK "WSL2 설치 확인됨"
} else {
    Write-OK "WSL2 설치 건너뜀 (--SkipWslInstall)"
}

# ── 3. Ubuntu 배포판 확인 ─────────────────────────────────────────
Write-Step "Ubuntu 배포판 확인"
$distros = wsl --list --quiet 2>&1 | Where-Object { $_ -match "Ubuntu" }
if (-not $distros) {
    Write-Warn "Ubuntu가 없습니다. Ubuntu 22.04 LTS를 설치합니다..."
    wsl --install -d Ubuntu-22.04
    Write-Warn "Ubuntu 초기 설정(사용자명/비밀번호)을 완료한 후 이 스크립트를 다시 실행하세요."
    exit 0
}
Write-OK "Ubuntu 배포판 확인됨: $($distros -join ', ')"

# ── 4. Ubuntu 안에서 bootstrap 실행 ──────────────────────────────
Write-Step "Ubuntu에서 Node.js + Claude Code 설치 시작"
Write-Host "  (완료까지 1~2분 소요됩니다...)`n"

wsl bash -c "curl -fsSL https://raw.githubusercontent.com/seokmogu/worx-cc-setup/main/scripts/ubuntu-bootstrap.sh | bash"

if ($LASTEXITCODE -ne 0) {
    Write-Err "Ubuntu 부트스트랩 실패. ubuntu-bootstrap.sh 로그를 확인하세요."
    exit 1
}

# ── 5. 완료 안내 ──────────────────────────────────────────────────
Write-Host @"

  ✅  설치 완료!

  다음 단계:
  1. Ubuntu 터미널을 열고 실행:
       claude

  2. Anthropic 계정으로 로그인

  3. 로그인 후 아래 명령 입력:
       /plugin marketplace add https://github.com/seokmogu/worx-cc-setup
       /plugin install worx-cc-setup
       /worx-cc-setup

  Claude가 나머지 개발 환경을 자동으로 설치합니다.

"@ -ForegroundColor Green

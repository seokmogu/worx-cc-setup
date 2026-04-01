# Worxphere Windows Pre-Setup Script
# Run in PowerShell (Administrator):
#   Set-ExecutionPolicy Bypass -Scope Process -Force
#   Invoke-WebRequest -Uri "https://raw.githubusercontent.com/seokmogu/worx-cc-setup/main/scripts/windows-setup.ps1" -OutFile "$env:TEMP\worx-setup.ps1"
#   & "$env:TEMP\worx-setup.ps1"

param(
    [switch]$SkipWslInstall
)

$ErrorActionPreference = "Stop"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

function Write-Step($msg) { Write-Host "`n[STEP] $msg" -ForegroundColor Cyan }
function Write-OK($msg)   { Write-Host "  [OK] $msg" -ForegroundColor Green }
function Write-Warn($msg) { Write-Host "  [!!] $msg" -ForegroundColor Yellow }
function Write-Err($msg)  { Write-Host " [ERR] $msg" -ForegroundColor Red }

Write-Host "`n  Worxphere CC Setup - Windows Pre-Setup Script`n" -ForegroundColor Magenta

# 1. Admin check
Write-Step "Checking administrator privileges"
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Err "Administrator privileges required."
    Write-Warn "Right-click PowerShell and select 'Run as Administrator', then retry."
    exit 1
}
Write-OK "Administrator privileges confirmed"

# 2. WSL2 check
Write-Step "Checking WSL2 status"
$wslInstalled = $false
try {
    $wslStatus = wsl --status 2>&1
    if ($LASTEXITCODE -eq 0) { $wslInstalled = $true }
} catch {}

if (-not $wslInstalled -and -not $SkipWslInstall) {
    Write-Warn "WSL2 not found. Installing..."
    wsl --install
    Write-Warn ""
    Write-Warn "WSL2 installation complete. A restart is required."
    Write-Warn "After restart, open Ubuntu terminal and run:"
    Write-Warn ""
    Write-Warn "  curl -fsSL https://raw.githubusercontent.com/seokmogu/worx-cc-setup/main/scripts/ubuntu-bootstrap.sh | bash"
    Write-Warn ""
    Write-Host "Restart now? (y/N): " -NoNewline
    $restart = Read-Host
    if ($restart -eq 'y' -or $restart -eq 'Y') { Restart-Computer -Force }
    exit 0
} elseif ($wslInstalled) {
    Write-OK "WSL2 confirmed"
} else {
    Write-OK "WSL2 install skipped (-SkipWslInstall)"
}

# 3. Ubuntu distro check
Write-Step "Checking Ubuntu distro"
$distros = wsl --list --quiet 2>&1 | Where-Object { $_ -match "Ubuntu" }
if (-not $distros) {
    Write-Warn "Ubuntu not found. Installing Ubuntu 22.04 LTS..."
    wsl --install -d Ubuntu-22.04
    Write-Warn "Complete Ubuntu initial setup (username/password), then re-run this script."
    exit 0
}
Write-OK "Ubuntu found: $($distros -join ', ')"

# 4. Run bootstrap inside Ubuntu
Write-Step "Running Node.js + Claude Code installer inside Ubuntu"
Write-Host "  (this may take 1-2 minutes...)`n"

wsl bash -c "curl -fsSL https://raw.githubusercontent.com/seokmogu/worx-cc-setup/main/scripts/ubuntu-bootstrap.sh | bash"

if ($LASTEXITCODE -ne 0) {
    Write-Err "Ubuntu bootstrap failed. Check the output above."
    exit 1
}

# 5. Done
Write-Host "`n  SUCCESS!" -ForegroundColor Green
Write-Host @"

  Next steps:
  1. Open Ubuntu terminal and run:
       claude

  2. Login with your Anthropic account

  3. After login, enter these commands:
       /plugin marketplace add https://github.com/seokmogu/worx-cc-setup
       /plugin install worx-cc-setup
       /worx-cc-setup

  Claude will automatically install the remaining dev tools.

"@ -ForegroundColor Green

# ===========================================
# INSTALL.ps1 - Setup 2eme PC
# Lancer dans PowerShell en ADMINISTRATEUR
# ===========================================

Write-Host "=== ETAPE 1 : Verification Node.js ===" -ForegroundColor Cyan
node --version
if ($LASTEXITCODE -ne 0) {
    Write-Host "Node.js manquant - telecharger sur https://nodejs.org puis relancer ce script" -ForegroundColor Red
    pause
    exit
}

Write-Host "=== ETAPE 2 : Installation Claude Code ===" -ForegroundColor Cyan
npm install -g @anthropic-ai/claude-code
claude --version

Write-Host "=== ETAPE 3 : Creation dossier C:\CLAUDE CODE ===" -ForegroundColor Cyan
New-Item -ItemType Directory -Force "C:\CLAUDE CODE"

Write-Host "=== ETAPE 4 : Copie des secrets ===" -ForegroundColor Cyan

# Load shared config (copy twin-config.ps1.example to twin-config.ps1 first)
$configPath = Join-Path $PSScriptRoot "twin-config.ps1"
if (Test-Path $configPath) {
    . $configPath
} else {
    Write-Host "WARNING: twin-config.ps1 missing - using defaults (MAIN-PC/TwinSetup/T:)." -ForegroundColor Yellow
    $TwinServerHost = "MAIN-PC"
    $TwinShareName  = "TwinSetup"
    $TwinDrive      = "T:"
}

# Detect if drive is mapped, else use UNC path
$twin = if (Test-Path "${TwinDrive}\") { "${TwinDrive}\" } else { "\\$TwinServerHost\$TwinShareName\" }
Write-Host "Using source: $twin" -ForegroundColor Cyan

Copy-Item "$twin\secrets\.env" "C:\CLAUDE CODE\" -Force
New-Item -ItemType Directory -Force "C:\CLAUDE CODE\JOB SEEKING"
Copy-Item "$twin\secrets\credentials.json" "C:\CLAUDE CODE\JOB SEEKING\" -Force
Copy-Item "$twin\secrets\token.json" "C:\CLAUDE CODE\JOB SEEKING\" -Force
New-Item -ItemType Directory -Force "C:\CLAUDE CODE\Credentials"
Copy-Item "$twin\secrets\linkedin-cookie.md" "C:\CLAUDE CODE\Credentials\" -Force

Write-Host "=== ETAPE 5 : Copie CLAUDE.md global ===" -ForegroundColor Cyan
New-Item -ItemType Directory -Force "$env:USERPROFILE\.claude"
Copy-Item "$twin\CLAUDE.md" "$env:USERPROFILE\.claude\" -Force

Write-Host "=== ETAPE 6 : Copie memoires Claude ===" -ForegroundColor Cyan
$memDest = "$env:USERPROFILE\.claude\projects\c--CLAUDE-CODE\memory"
New-Item -ItemType Directory -Force $memDest
Copy-Item "$twin\memory\*" $memDest -Force

Write-Host "=== ETAPE 7 : Copie cles SSH ===" -ForegroundColor Cyan
New-Item -ItemType Directory -Force "$env:USERPROFILE\.ssh"
Copy-Item "$twin\ssh\*" "$env:USERPROFILE\.ssh\" -Force

Write-Host "=== ETAPE 8 : Installation dependances Python ===" -ForegroundColor Cyan
pip install python-dotenv google-auth google-auth-oauthlib google-api-python-client

Write-Host ""
Write-Host "=== TERMINE ! ===" -ForegroundColor Green
Write-Host "Lance maintenant 'claude' dans le terminal pour te connecter avec ton compte Anthropic." -ForegroundColor Green
pause

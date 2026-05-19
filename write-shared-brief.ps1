# write-shared-brief.ps1
# Writes SHARED-BRIEF.md to Drive (source of truth) + T:\ (LAN cache, best-effort).
# Run at every session CLOSE.
#
# Usage:
#   pwsh -File "write-shared-brief.ps1" -Summary "Short session summary..."
#   pwsh -File "write-shared-brief.ps1" -FromFile "C:\path\to\brief.md"

param(
    [Parameter(Mandatory=$false)]
    [string]$Summary,

    [Parameter(Mandatory=$false)]
    [string]$Projects = "",

    [Parameter(Mandatory=$false)]
    [string]$Model = "",

    [Parameter(Mandatory=$false)]
    [string]$FromFile = ""
)

# Load shared config (copy twin-config.ps1.example to twin-config.ps1 first)
$configPath = Join-Path $PSScriptRoot "twin-config.ps1"
if (-not (Test-Path $configPath)) {
    Write-Host "[BRIEF] Missing $configPath - copy twin-config.ps1.example and customize." -ForegroundColor Red
    exit 1
}
. $configPath

if (-not $Model) { $Model = $TwinModel }

# If -FromFile provided, read full markdown content from that file
if ($FromFile) {
    if (-not (Test-Path $FromFile)) {
        Write-Host "[BRIEF] Source file not found: $FromFile" -ForegroundColor Red
        exit 1
    }
    $Summary = Get-Content -Path $FromFile -Raw -Encoding UTF8
}

if (-not $Summary) {
    Write-Host "[BRIEF] Error: -Summary or -FromFile required." -ForegroundColor Red
    Write-Host "Usage:" -ForegroundColor Yellow
    Write-Host "  pwsh -File write-shared-brief.ps1 -Summary 'short summary, no newlines'"
    Write-Host "  pwsh -File write-shared-brief.ps1 -FromFile 'C:\path\to\brief.md'"
    exit 1
}

$ErrorActionPreference = 'Continue'

$driveFile  = Join-Path $TwinDriveDir "SHARED-BRIEF.md"
$tDriveFile = "${TwinDrive}\SHARED-BRIEF.md"

$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm"
$machine   = $env:COMPUTERNAME

$content = @"
# SHARED-BRIEF
> Last updated: $timestamp - Machine: $machine - $Model

## Recent work

$Summary
"@

if ($Projects) {
    $content += @"


## Active projects

$Projects
"@
}

$content += @"


## Notes

- Source of truth: Drive (this file)
- LAN cache: ${TwinDrive}\SHARED-BRIEF.md (when main PC is on and same LAN)
- Read automatically at SessionStart via read-shared-brief.ps1
"@

# 1. Write to Drive (critical)
$driveOK = $false
try {
    if (-not (Test-Path $TwinDriveDir)) {
        Write-Host "[BRIEF] Drive folder unreachable: $TwinDriveDir" -ForegroundColor Red
        Write-Host "[BRIEF] Check that Google Drive desktop is running." -ForegroundColor Yellow
    } else {
        $content | Set-Content -Path $driveFile -Encoding UTF8 -Force
        Write-Host "[BRIEF] Written to Drive: $driveFile" -ForegroundColor Green
        $driveOK = $true
    }
} catch {
    Write-Host "[BRIEF] Drive write error: $_" -ForegroundColor Red
}

# 2. Write to T:\ (best-effort, never blocking)
try {
    if (Test-Path "${TwinDrive}\") {
        $content | Set-Content -Path $tDriveFile -Encoding UTF8 -Force
        Write-Host "[BRIEF] Written to ${TwinDrive} (LAN cache)" -ForegroundColor Green
    } else {
        Write-Host "[BRIEF] ${TwinDrive} not mounted - LAN cache skipped (normal when on the road)." -ForegroundColor DarkGray
    }
} catch {
    Write-Host "[BRIEF] ${TwinDrive} unreachable - LAN cache skipped." -ForegroundColor DarkGray
}

if ($driveOK) {
    Write-Host ""
    Write-Host "[BRIEF] OK. The other machine will see this brief at its next session." -ForegroundColor Green
    exit 0
} else {
    Write-Host ""
    Write-Host "[BRIEF] CRITICAL FAILURE: Drive unreachable." -ForegroundColor Red
    exit 1
}

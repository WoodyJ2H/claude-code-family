# read-shared-brief.ps1
# Reads SHARED-BRIEF.md from Drive (source of truth) with T:\ (LAN cache) fallback.
# Called by the Claude Code SessionStart hook.
# Returns a hookSpecificOutput JSON for injection into the conversation context.

$ErrorActionPreference = 'SilentlyContinue'

# Load shared config
$configPath = Join-Path $PSScriptRoot "twin-config.ps1"
if (-not (Test-Path $configPath)) { exit 0 }
. $configPath

$driveFile  = Join-Path $TwinDriveDir "SHARED-BRIEF.md"
$tDriveFile = "${TwinDrive}\SHARED-BRIEF.md"
$thisMachine = $env:COMPUTERNAME

$source = $null
$content = $null
$briefMachine = "unknown"
$briefAge = $null

# Priority 1: Drive (always available when Google Drive desktop is running)
if (Test-Path $driveFile) {
    try {
        $content = Get-Content -Path $driveFile -Raw -Encoding UTF8
        $modified = (Get-Item $driveFile).LastWriteTime
        $briefAge = [math]::Round(((Get-Date) - $modified).TotalHours, 1)
        $source = "Drive"
    } catch {
        $content = $null
    }
}

# Priority 2: T:\ (LAN cache, faster when main PC is on)
if (-not $content -and (Test-Path $tDriveFile)) {
    try {
        $content = Get-Content -Path $tDriveFile -Raw -Encoding UTF8
        $modified = (Get-Item $tDriveFile).LastWriteTime
        $briefAge = [math]::Round(((Get-Date) - $modified).TotalHours, 1)
        $source = "${TwinDrive} (LAN)"
    } catch {
        $content = $null
    }
}

# No source available: silent exit
if (-not $content) {
    exit 0
}

# Extract origin machine from brief ("Machine: XXX" line)
if ($content -match "Machine\s*:\s*(\S+)") {
    $briefMachine = $matches[1]
}

# Build contextual header
$header = ""
if ($briefMachine -eq $thisMachine) {
    $header = "SHARED-BRIEF (source: $source, ${briefAge}h, origin: $briefMachine = THIS PC)"
    $header += "`n>> No catch-up needed - you're resuming your own work."
} else {
    $header = "SHARED-BRIEF (source: $source, ${briefAge}h, origin: $briefMachine != THIS PC = $thisMachine)"
    $header += "`n>> CATCH-UP - here's what the other machine did since your last session."
}

$message = @"
$header

$content
"@

$output = @{
    hookSpecificOutput = @{
        hookEventName = 'SessionStart'
        additionalContext = $message
    }
} | ConvertTo-Json -Depth 5 -Compress

Write-Output $output

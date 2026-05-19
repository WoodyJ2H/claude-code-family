# mount-T.ps1
# Mounts the SMB share - BEST-EFFORT, NEVER BLOCKING.
# T:\ is an optional LAN cache. Drive remains the source of truth.
#
# Behavior:
#   - On the main PC (sharing host): T:\ points to its own disk, mount is skipped
#   - On a client PC + same LAN: tries hostname then IP, 2 attempts max
#   - On failure: silent exit, Drive takes over
#
# Usage: pwsh -File "mount-T.ps1"

$ErrorActionPreference = 'SilentlyContinue'

# Load shared config
$configPath = Join-Path $PSScriptRoot "twin-config.ps1"
if (-not (Test-Path $configPath)) { exit 0 }
. $configPath

# Case 1: we ARE the server - nothing to mount remotely
if ($env:COMPUTERNAME -eq $TwinServerHost) {
    if (Test-Path "${TwinDrive}\") {
        exit 0
    }
    # Otherwise, mount via localhost
    $null = net use $TwinDrive "\\$TwinServerHost\$TwinShareName" /persistent:yes 2>&1
    exit 0
}

# Case 2: client PC - check if already mounted and working
if ((Test-Path "${TwinDrive}\") -and (Test-Path "${TwinDrive}\SHARED-BRIEF.md")) {
    exit 0
}

# Clean up any zombie mapping
$existing = net use $TwinDrive 2>$null
if ($existing) {
    $null = net use $TwinDrive /delete /y 2>&1
    Start-Sleep -Milliseconds 500
}

# Attempt 1: hostname
$null = net use $TwinDrive "\\$TwinServerHost\$TwinShareName" /persistent:yes 2>&1
if ((Test-Path "${TwinDrive}\") -and (Test-Path "${TwinDrive}\SHARED-BRIEF.md")) {
    exit 0
}

# Attempt 2: IP fallback (when local DNS can't resolve the hostname)
$null = net use $TwinDrive /delete /y 2>&1
$null = net use $TwinDrive "\\$TwinServerIP\$TwinShareName" /persistent:yes 2>&1
if ((Test-Path "${TwinDrive}\") -and (Test-Path "${TwinDrive}\SHARED-BRIEF.md")) {
    exit 0
}

# Silent failure - Drive takes over
exit 0

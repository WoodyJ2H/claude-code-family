# install-hook.ps1
# Installs the SessionStart hook on a client PC.
# Run ONCE from PowerShell (no admin needed).
# The hook: mounts the SMB share if missing, then reads SHARED-BRIEF.md.

$settingsPath = "$env:USERPROFILE\.claude\settings.json"
$scriptDir    = $PSScriptRoot

if (-not (Test-Path $settingsPath)) {
    New-Item -ItemType File -Path $settingsPath -Force | Out-Null
    Set-Content $settingsPath "{}"
}

# Hook command: mount, then read SHARED-BRIEF (Drive priority, T:\ fallback)
$mountCmd = "pwsh -NonInteractive -ExecutionPolicy Bypass -File `"$scriptDir\mount-T.ps1`""
$readCmd  = "pwsh -NonInteractive -ExecutionPolicy Bypass -File `"$scriptDir\read-shared-brief.ps1`""

$hookObject = [PSCustomObject]@{
    hooks = @(
        [PSCustomObject]@{
            type          = "command"
            command       = $mountCmd
            timeout       = 10
            statusMessage = "Twin: mounting SMB share (best-effort)..."
        },
        [PSCustomObject]@{
            type          = "command"
            command       = $readCmd
            timeout       = 5
            statusMessage = "Twin: reading SHARED-BRIEF (Drive priority)..."
        }
    )
}

$settings = Get-Content $settingsPath -Raw | ConvertFrom-Json

if (-not $settings.PSObject.Properties["hooks"]) {
    $settings | Add-Member -MemberType NoteProperty -Name "hooks" -Value ([PSCustomObject]@{})
}

# Overwrite SessionStart (even if exists) to force the new version
$settings.hooks | Add-Member -MemberType NoteProperty -Name "SessionStart" -Value @($hookObject) -Force

$settings | ConvertTo-Json -Depth 10 | Set-Content $settingsPath -Encoding UTF8

Write-Host ""
Write-Host "SessionStart hook installed in $settingsPath" -ForegroundColor Green
Write-Host "Behavior:" -ForegroundColor Cyan
Write-Host "  1. Mounts the SMB share automatically if missing (with IP fallback)"
Write-Host "  2. Reads SHARED-BRIEF.md and injects it into the Claude context"
Write-Host "  3. If everything fails: Claude starts normally with a warning"
Write-Host ""
Write-Host "Tip: run setup-automount.ps1 (as admin) for auto-mount at startup." -ForegroundColor Yellow

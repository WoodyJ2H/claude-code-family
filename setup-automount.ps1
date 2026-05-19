# setup-automount.ps1
# Creates a scheduled task to mount the SMB share automatically at logon.
# Run ONCE on a client PC as ADMINISTRATOR.
# The task will run at every user session.

$taskName   = "TwinSetup-Mount"
$scriptPath = Join-Path $PSScriptRoot "mount-T.ps1"

if (-not (Test-Path $scriptPath)) {
    Write-Host "ERROR: $scriptPath not found." -ForegroundColor Red
    pause
    exit 1
}

# Remove old task if it exists
$existing = Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue
if ($existing) {
    Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
    Write-Host "Old task removed." -ForegroundColor Yellow
}

$action  = New-ScheduledTaskAction `
    -Execute "pwsh.exe" `
    -Argument "-NonInteractive -WindowStyle Hidden -File `"$scriptPath`""

$triggerLogon = New-ScheduledTaskTrigger -AtLogOn

$settings = New-ScheduledTaskSettingsSet `
    -StartWhenAvailable `
    -RunOnlyIfNetworkAvailable:$false `
    -ExecutionTimeLimit (New-TimeSpan -Minutes 2)

$principal = New-ScheduledTaskPrincipal `
    -UserId ([System.Security.Principal.WindowsIdentity]::GetCurrent().Name) `
    -LogonType Interactive `
    -RunLevel Highest

Register-ScheduledTask `
    -TaskName $taskName `
    -Action $action `
    -Trigger $triggerLogon `
    -Settings $settings `
    -Principal $principal `
    -Description "Mounts the Twin Setup SMB share at logon" `
    -Force | Out-Null

Write-Host ""
Write-Host "Scheduled task '$taskName' created." -ForegroundColor Green
Write-Host "The SMB share will be mounted automatically at every Windows logon." -ForegroundColor Green
Write-Host ""
Write-Host "Test now? Run mount-T.ps1 immediately?" -ForegroundColor Cyan
$rep = Read-Host "(y/n)"
if ($rep -eq "y") {
    & $scriptPath
}

param(
  [string]$TaskName = "Harzva AgentOS Daily Scan",
  [string]$At = "09:30",
  [string]$Profile = "xhs",
  [ValidateSet("codex", "claude-code", "all")]
  [string]$Target = "codex",
  [switch]$Unregister
)

$ErrorActionPreference = "Stop"
$Root = Resolve-Path (Join-Path $PSScriptRoot "..")
$RunScript = Join-Path $PSScriptRoot "run-agentos-daily-scan.ps1"

if ($Unregister) {
  Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false -ErrorAction SilentlyContinue
  Write-Host "unregistered scheduled task: $TaskName"
  exit 0
}

$AtTime = [datetime]::ParseExact($At, "HH:mm", $null)
$Pwsh = (Get-Command pwsh -ErrorAction Stop).Source
$Args = "-NoProfile -ExecutionPolicy Bypass -File `"$RunScript`" -Profile `"$Profile`" -Target `"$Target`""
$Action = New-ScheduledTaskAction -Execute $Pwsh -Argument $Args -WorkingDirectory $Root
$Trigger = New-ScheduledTaskTrigger -Daily -At $AtTime.TimeOfDay
$Description = "Read-only AgentOS stack scan. Does not commit, push, publish, or run --apply."

Register-ScheduledTask -TaskName $TaskName -Action $Action -Trigger $Trigger -Description $Description -Force | Out-Null
Write-Host "registered scheduled task: $TaskName"
Write-Host "time: $At"
Write-Host "profile: $Profile"
Write-Host "target: $Target"
Write-Host "logs: $Root\.agentworkos\automation-logs"

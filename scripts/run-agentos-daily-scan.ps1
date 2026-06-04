param(
  [string]$Profile = "xhs",
  [ValidateSet("codex", "claude-code", "all")]
  [string]$Target = "codex"
)

$ErrorActionPreference = "Continue"
$Root = Resolve-Path (Join-Path $PSScriptRoot "..")
$LogDir = Join-Path $Root ".agentworkos\automation-logs"
New-Item -ItemType Directory -Path $LogDir -Force | Out-Null
$Stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$LogPath = Join-Path $LogDir "agentos-daily-scan-$Stamp.log"

Write-Host "writing scan log: $LogPath"
& pwsh -NoProfile -ExecutionPolicy Bypass -File (Join-Path $PSScriptRoot "agentos-daily-scan.ps1") -Profile $Profile -Target $Target *>&1 | Tee-Object -FilePath $LogPath
exit $LASTEXITCODE

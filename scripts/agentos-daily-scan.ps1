param(
  [string]$Profile = "xhs",
  [ValidateSet("codex", "claude-code", "all")]
  [string]$Target = "codex",
  [string]$SuiteRoot = ""
)

$ErrorActionPreference = "Continue"
$StackRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$Manifest = Join-Path $StackRoot "agentworkos.toml"
if (-not $SuiteRoot) {
  $candidate = Join-Path (Split-Path $StackRoot -Parent) "01-skills\xhs-skill-suite"
  if (Test-Path $candidate) { $SuiteRoot = $candidate }
}

Write-Host "# AgentOS daily scan"
Write-Host "date=$(Get-Date -Format s)"
Write-Host "stack=$StackRoot"
if ($SuiteRoot) { Write-Host "xhs_suite=$SuiteRoot" }

Write-Host "\n## Git status"
git -C $StackRoot status --short --branch
if ($SuiteRoot -and (Test-Path $SuiteRoot)) { git -C $SuiteRoot status --short --branch }

Write-Host "\n## Recent local Codex skills"
$codexSkills = Join-Path $env:USERPROFILE ".codex\skills"
if (Test-Path $codexSkills) {
  Get-ChildItem -Path $codexSkills -Directory | Sort-Object LastWriteTime -Descending | Select-Object -First 20 Name,LastWriteTime | Format-Table -AutoSize
}

Write-Host "\n## Recent local source skills"
$sourceSkills = Join-Path (Split-Path $StackRoot -Parent) "01-skills"
if (Test-Path $sourceSkills) {
  Get-ChildItem -Path $sourceSkills -Directory | Where-Object { Test-Path (Join-Path $_.FullName "SKILL.md") -or Test-Path (Join-Path $_.FullName "agentworkos.toml") } | Sort-Object LastWriteTime -Descending | Select-Object -First 20 Name,LastWriteTime | Format-Table -AutoSize
}

Write-Host "\n## Stack health"
aw doctor --manifest $Manifest --profile safe-core
aw doctor --manifest $Manifest --profile creator
aw doctor --manifest $Manifest --profile xhs

Write-Host "\n## XHS dry-run"
aw sync --manifest $Manifest --target $Target --profile $Profile

Write-Host "\n## Suggested one-click apply"
Write-Host "pwsh -ExecutionPolicy Bypass -File scripts/sync-xhs-suite.ps1 -Profile $Profile -Target all -Pull -Apply"

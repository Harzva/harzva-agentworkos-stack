param(
  [ValidateSet("creator", "xhs")]
  [string]$Profile = "xhs",
  [ValidateSet("codex", "claude-code", "all")]
  [string]$Target = "all",
  [switch]$Apply,
  [switch]$Pull
)

$ErrorActionPreference = "Stop"
$Root = Resolve-Path (Join-Path $PSScriptRoot "..")
$Manifest = Join-Path $Root "agentworkos.toml"

if ($Pull) {
  git -C $Root pull --ff-only
}

aw doctor --manifest $Manifest --profile $Profile
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

aw sync --manifest $Manifest --target $Target --profile $Profile
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

if ($Apply) {
  aw sync --manifest $Manifest --target $Target --profile $Profile --apply
  exit $LASTEXITCODE
}

Write-Host "dry-run only; rerun with -Apply to write runtime files."

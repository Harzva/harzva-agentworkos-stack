[CmdletBinding()]
param(
    [ValidateSet("codex", "claude-code", "claude", "all")]
    [string]$Target = "all",
    [ValidateSet("base", "agents", "skills", "safe-core", "windows-desktop", "mac-dev", "linux-dev", "linux-server", "full")]
    [string]$Profile = "safe-core",
    [switch]$Apply
)

$ErrorActionPreference = "Stop"
[Console]::OutputEncoding = [System.Text.UTF8Encoding]::new($false)
$OutputEncoding = [System.Text.UTF8Encoding]::new($false)

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$manifest = Join-Path $root "agentworkos.toml"

aw doctor --manifest $manifest --profile $Profile

$syncArgs = @("sync", "--manifest", $manifest, "--target", $Target, "--profile", $Profile)
if ($Apply) {
    $syncArgs += "--apply"
}

aw @syncArgs


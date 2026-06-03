[CmdletBinding()]
param(
    [switch]$KeepFixture
)

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$fixtureRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("make-windows-silky-smoke-" + [Guid]::NewGuid().ToString("N"))

function Assert-True {
    param(
        [bool]$Condition,
        [string]$Message
    )

    if (-not $Condition) {
        throw "Smoke test assertion failed: $Message"
    }
}

try {
    New-Item -ItemType Directory -Path $fixtureRoot -Force | Out-Null
    New-Item -ItemType Directory -Path (Join-Path $fixtureRoot "releases") -Force | Out-Null
    New-Item -ItemType Directory -Path (Join-Path $fixtureRoot "docs\readme-assets") -Force | Out-Null

    Set-Content -LiteralPath (Join-Path $fixtureRoot "README.md") -Encoding UTF8 -Value @(
        "# Windows Silky Fixture",
        "",
        "## Usage",
        "",
        "Run the fixture preflight."
    )

    Set-Content -LiteralPath (Join-Path $fixtureRoot "docs\readme-assets\proof.svg") -Encoding UTF8 -Value '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 120 60"><rect width="120" height="60" fill="#0f766e"/></svg>'

    $artifactA = Join-Path $fixtureRoot "releases\Widget-v1.0.0-windows-x64.exe"
    $artifactB = Join-Path $fixtureRoot "releases\Widget-v1.0.1-windows-x64.exe"
    Set-Content -LiteralPath $artifactA -Encoding ASCII -Value "fake binary a"
    Set-Content -LiteralPath $artifactB -Encoding ASCII -Value "fake binary b"

    $auditJson = Join-Path $fixtureRoot "windows-silky-audit.json"
    $auditMarkdown = Join-Path $fixtureRoot "WINDOWS_SILKY_AUDIT.md"
    & (Join-Path $repoRoot "scripts\Invoke-WindowsSilkyAudit.ps1") -Root $fixtureRoot -OutputJson $auditJson -OutputMarkdown $auditMarkdown -Days 30
    Assert-True (Test-Path -LiteralPath $auditJson) "audit JSON should be written"

    $audit = Get-Content -LiteralPath $auditJson -Raw -Encoding UTF8 | ConvertFrom-Json
    Assert-True ($audit.summary.release_artifacts -eq 2) "audit should see two fake release artifacts"
    Assert-True ($audit.summary.duplicate_artifact_groups -ge 1) "audit should group duplicated versioned artifacts"
    Assert-True ($audit.summary.release_artifacts_without_evidence -eq 2) "audit should report artifacts without evidence before manifests are created"

    & (Join-Path $repoRoot "scripts\New-ArtifactEvidenceManifest.ps1") -Artifact $artifactA -SourceProject "smoke-fixture" -SmokeResult "pass" -Decision "ship"
    & (Join-Path $repoRoot "scripts\New-ArtifactEvidenceManifest.ps1") -Artifact $artifactB -SourceProject "smoke-fixture" -SmokeResult "pass" -Decision "archive"

    & (Join-Path $repoRoot "scripts\Test-ArtifactEvidenceManifest.ps1") -Manifest (Join-Path $fixtureRoot "releases\Widget-v1.0.0-windows-x64.evidence.json")
    & (Join-Path $repoRoot "scripts\Test-EncodingGate.ps1") -Root $fixtureRoot
    & (Join-Path $repoRoot "scripts\Invoke-WindowsSilkyPreflight.ps1") -ProjectRoot $fixtureRoot

    Write-Host "Smoke tests passed." -ForegroundColor Green
}
finally {
    if ($KeepFixture) {
        Write-Host "Fixture kept: $fixtureRoot"
    }
    elseif (Test-Path -LiteralPath $fixtureRoot) {
        Remove-Item -LiteralPath $fixtureRoot -Recurse -Force
    }
}

[CmdletBinding()]
param(
    [string]$ProjectRoot = ".",
    [switch]$AllowMissingVisualProof
)

$ErrorActionPreference = "Stop"

$project = Get-Item -LiteralPath $ProjectRoot
$rootFull = $project.FullName
$failures = New-Object System.Collections.Generic.List[string]
$warnings = New-Object System.Collections.Generic.List[string]

function Add-Failure {
    param([string]$Message)
    $script:failures.Add($Message)
}

function Add-Warning {
    param([string]$Message)
    $script:warnings.Add($Message)
}

$readme = Join-Path $rootFull "README.md"
if (-not (Test-Path -LiteralPath $readme)) {
    Add-Failure "Missing README.md."
}
else {
    $readmeText = Get-Content -LiteralPath $readme -Raw -Encoding UTF8
    if ($readmeText -notmatch "(?i)(install|setup|run|usage|quick start|quickstart|quick-start|start)") {
        Add-Warning "README does not appear to include install/run/usage instructions."
    }
}

$visualProof = @()
$proofDirs = @(
    (Join-Path $rootFull "docs\readme-assets"),
    (Join-Path $rootFull "docs\assets"),
    (Join-Path $rootFull "assets")
)
foreach ($dir in $proofDirs) {
    if (Test-Path -LiteralPath $dir) {
        $visualProof += @(Get-ChildItem -LiteralPath $dir -File -Force -ErrorAction SilentlyContinue |
            Where-Object { @(".png", ".jpg", ".jpeg", ".gif", ".webp", ".svg") -contains $_.Extension.ToLowerInvariant() })
    }
}

if (-not $AllowMissingVisualProof -and $visualProof.Count -eq 0) {
    Add-Failure "Missing README visual proof or logo asset under docs/readme-assets, docs/assets, or assets."
}

$artifactExtensions = @(".exe", ".msi", ".msix", ".appx", ".zip", ".7z", ".apk", ".aab", ".ipa")
$excludePattern = "\\(\.git|node_modules|__pycache__|\.venv|venv)\\"
$artifacts = @(Get-ChildItem -LiteralPath $rootFull -Recurse -File -Force -ErrorAction SilentlyContinue |
    Where-Object { $artifactExtensions -contains $_.Extension.ToLowerInvariant() -and $_.FullName -notmatch $excludePattern })
$manifestValidator = Join-Path $PSScriptRoot "Test-ArtifactEvidenceManifest.ps1"

foreach ($artifact in $artifacts) {
    $manifestByName = Join-Path $artifact.DirectoryName ($artifact.BaseName + ".evidence.json")
    $nearbyEvidence = @(Get-ChildItem -LiteralPath $artifact.DirectoryName -File -Force -ErrorAction SilentlyContinue |
        Where-Object { $_.Name -match "(?i)(manifest|evidence|checksum|sha256)" })
    if (-not (Test-Path -LiteralPath $manifestByName) -and $nearbyEvidence.Count -eq 0) {
        Add-Failure "Artifact lacks evidence manifest: $($artifact.FullName)"
    }

    $jsonEvidence = @()
    if (Test-Path -LiteralPath $manifestByName) {
        $jsonEvidence = @(Get-Item -LiteralPath $manifestByName)
    }
    else {
        $jsonEvidence = @($nearbyEvidence |
            Where-Object { $_.Extension.ToLowerInvariant() -eq ".json" -and $_.Name -match "(?i)(manifest|evidence)" })
    }

    if ($jsonEvidence.Count -gt 0) {
        if (-not (Test-Path -LiteralPath $manifestValidator)) {
            Add-Failure "Missing Test-ArtifactEvidenceManifest.ps1 beside preflight script."
        }
        else {
            foreach ($manifest in $jsonEvidence) {
                & $manifestValidator -Manifest $manifest.FullName
                if ($LASTEXITCODE -ne 0) {
                    Add-Failure "Evidence manifest validation failed: $($manifest.FullName)"
                }
            }
        }
    }
}

$encodingScript = Join-Path $PSScriptRoot "Test-EncodingGate.ps1"
if (Test-Path -LiteralPath $encodingScript) {
    & $encodingScript -Root $rootFull
    if ($LASTEXITCODE -ne 0) {
        Add-Failure "Encoding gate failed."
    }
}
else {
    Add-Failure "Missing Test-EncodingGate.ps1 beside preflight script."
}

Write-Host ""
Write-Host "Windows Silky Preflight"
Write-Host "Project: $rootFull"

if ($warnings.Count -gt 0) {
    Write-Host ""
    Write-Host "Warnings:" -ForegroundColor Yellow
    foreach ($warning in $warnings) {
        Write-Host "- $warning"
    }
}

if ($failures.Count -gt 0) {
    Write-Host ""
    Write-Host "Failures:" -ForegroundColor Red
    foreach ($failure in $failures) {
        Write-Host "- $failure"
    }
    exit 1
}

Write-Host "Preflight passed." -ForegroundColor Green
exit 0

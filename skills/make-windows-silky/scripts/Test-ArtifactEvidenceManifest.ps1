[CmdletBinding()]
param(
    [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
    [string[]]$Manifest,

    [switch]$AllowMissingArtifact
)

$ErrorActionPreference = "Stop"

$failures = New-Object System.Collections.Generic.List[string]

function Add-Failure {
    param([string]$Message)
    $script:failures.Add($Message)
}

function Test-StringField {
    param(
        [object]$Value,
        [string]$Name,
        [switch]$AllowEmpty
    )

    if ($null -eq $Value) {
        Add-Failure "$Name is missing."
        return
    }

    if ($Value -isnot [string]) {
        Add-Failure "$Name must be a string."
        return
    }

    if (-not $AllowEmpty -and [string]::IsNullOrWhiteSpace($Value)) {
        Add-Failure "$Name must not be empty."
    }
}

foreach ($manifestPath in $Manifest) {
    if (-not (Test-Path -LiteralPath $manifestPath)) {
        Add-Failure "Manifest not found: $manifestPath"
        continue
    }

    $fullPath = (Get-Item -LiteralPath $manifestPath).FullName
    $data = $null
    try {
        $data = Get-Content -LiteralPath $fullPath -Raw -Encoding UTF8 | ConvertFrom-Json
    }
    catch {
        Add-Failure "Manifest is not valid JSON: $fullPath"
        continue
    }

    if ($data.schema -ne "make_windows_silky_Patch.artifact-evidence.v1") {
        Add-Failure "schema must be make_windows_silky_Patch.artifact-evidence.v1 in $fullPath."
    }

    foreach ($section in @("artifact", "source", "smoke", "release", "privacy")) {
        if ($null -eq $data.$section) {
            Add-Failure "$section section is missing in $fullPath."
        }
    }

    if ($null -ne $data.artifact) {
        Test-StringField -Value $data.artifact.path -Name "artifact.path"
        Test-StringField -Value $data.artifact.name -Name "artifact.name"
        Test-StringField -Value $data.artifact.version -Name "artifact.version" -AllowEmpty
        Test-StringField -Value $data.artifact.sha256 -Name "artifact.sha256"
        Test-StringField -Value $data.artifact.modified -Name "artifact.modified"

        if ($data.artifact.bytes -isnot [int] -and $data.artifact.bytes -isnot [long]) {
            Add-Failure "artifact.bytes must be an integer in $fullPath."
        }
        elseif ([int64]$data.artifact.bytes -lt 1) {
            Add-Failure "artifact.bytes must be greater than zero in $fullPath."
        }

        if ($data.artifact.sha256 -and $data.artifact.sha256 -notmatch "^[A-Fa-f0-9]{64}$") {
            Add-Failure "artifact.sha256 must be a 64-character hex SHA256 in $fullPath."
        }

        if (-not $AllowMissingArtifact -and $data.artifact.path -and -not (Test-Path -LiteralPath $data.artifact.path)) {
            Add-Failure "artifact.path does not exist: $($data.artifact.path)"
        }
    }

    if ($null -ne $data.source) {
        Test-StringField -Value $data.source.project -Name "source.project" -AllowEmpty
        Test-StringField -Value $data.source.commit -Name "source.commit" -AllowEmpty
        Test-StringField -Value $data.source.build_command -Name "source.build_command" -AllowEmpty
        Test-StringField -Value $data.source.builder -Name "source.builder" -AllowEmpty
    }

    if ($null -ne $data.smoke) {
        Test-StringField -Value $data.smoke.result -Name "smoke.result"
        Test-StringField -Value $data.smoke.install_result -Name "smoke.install_result" -AllowEmpty
        Test-StringField -Value $data.smoke.launch_result -Name "smoke.launch_result" -AllowEmpty
        Test-StringField -Value $data.smoke.log_path -Name "smoke.log_path" -AllowEmpty
        Test-StringField -Value $data.smoke.screenshot_path -Name "smoke.screenshot_path" -AllowEmpty
    }

    if ($null -ne $data.release) {
        Test-StringField -Value $data.release.target -Name "release.target" -AllowEmpty
        Test-StringField -Value $data.release.notes_path -Name "release.notes_path" -AllowEmpty
        Test-StringField -Value $data.release.reviewer -Name "release.reviewer" -AllowEmpty
        Test-StringField -Value $data.release.reviewed_at -Name "release.reviewed_at"

        if ($data.release.decision -notin @("ship", "fix", "archive", "assetize")) {
            Add-Failure "release.decision must be ship, fix, archive, or assetize in $fullPath."
        }
    }

    if ($null -ne $data.privacy) {
        if ($data.privacy.contains_secrets -isnot [bool]) {
            Add-Failure "privacy.contains_secrets must be a boolean in $fullPath."
        }
        Test-StringField -Value $data.privacy.redaction_notes -Name "privacy.redaction_notes" -AllowEmpty
    }
}

if ($failures.Count -gt 0) {
    Write-Host "Artifact evidence manifest validation failed:" -ForegroundColor Red
    foreach ($failure in $failures) {
        Write-Host "- $failure"
    }
    exit 1
}

Write-Host "Artifact evidence manifest validation passed." -ForegroundColor Green
exit 0

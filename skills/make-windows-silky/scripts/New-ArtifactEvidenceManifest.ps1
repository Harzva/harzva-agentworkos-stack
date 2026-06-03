[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$Artifact,

    [string]$OutputPath,
    [string]$SourceProject = "",
    [string]$Commit = "",
    [string]$BuildCommand = "",
    [string]$SmokeResult = "pending",
    [string]$InstallResult = "",
    [string]$LaunchResult = "",
    [string]$ScreenshotPath = "",
    [string]$LogPath = "",
    [string]$ReleaseTarget = "",
    [ValidateSet("ship", "fix", "archive", "assetize")]
    [string]$Decision = "fix"
)

$ErrorActionPreference = "Stop"

$item = Get-Item -LiteralPath $Artifact
if ($item.PSIsContainer) {
    throw "Artifact must be a file: $Artifact"
}

if (-not $OutputPath) {
    $OutputPath = Join-Path $item.DirectoryName ($item.BaseName + ".evidence.json")
}

$hash = Get-FileHash -LiteralPath $item.FullName -Algorithm SHA256

$manifest = [ordered]@{
    schema = "make_windows_silky_Patch.artifact-evidence.v1"
    artifact = [ordered]@{
        path = $item.FullName
        name = $item.Name
        version = ""
        bytes = $item.Length
        sha256 = $hash.Hash
        modified = $item.LastWriteTime.ToString("o")
    }
    source = [ordered]@{
        project = $SourceProject
        commit = $Commit
        build_command = $BuildCommand
        builder = $env:USERNAME
    }
    smoke = [ordered]@{
        result = $SmokeResult
        install_result = $InstallResult
        launch_result = $LaunchResult
        log_path = $LogPath
        screenshot_path = $ScreenshotPath
    }
    release = [ordered]@{
        target = $ReleaseTarget
        notes_path = ""
        decision = $Decision
        reviewer = $env:USERNAME
        reviewed_at = (Get-Date).ToString("o")
    }
    privacy = [ordered]@{
        contains_secrets = $false
        redaction_notes = ""
    }
}

$manifest | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $OutputPath -Encoding UTF8
Write-Host "Evidence manifest written: $OutputPath"

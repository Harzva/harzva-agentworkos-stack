[CmdletBinding()]
param(
    [string]$Root = ".",
    [int]$Days = 14,
    [string]$OutputMarkdown = "WINDOWS_SILKY_AUDIT.md",
    [string]$OutputJson = "windows-silky-audit.json",
    [int]$LargeProjectFileThreshold = 1000
)

$ErrorActionPreference = "Stop"

$rootItem = Get-Item -LiteralPath $Root
$rootFull = $rootItem.FullName.TrimEnd("\")
$artifactExtensions = @(".exe", ".msi", ".msix", ".appx", ".zip", ".7z", ".apk", ".aab", ".ipa")
$textExtensions = @(".md", ".txt", ".json", ".html", ".htm", ".js", ".jsx", ".ts", ".tsx", ".yml", ".yaml", ".ps1", ".css")
$excludePattern = "\\(\.git|node_modules|__pycache__|\.venv|venv)\\"
$evidencePattern = "(?i)(manifest|evidence|checksum|sha256|screenshot|screen|smoke|install|release[-_ ]?note|release_note)"
$selfPatternFiles = @("Test-EncodingGate.ps1", "Invoke-WindowsSilkyAudit.ps1")

function New-PatternFromCodePoint {
    param([int[]]$CodePoints)
    $value = ""
    foreach ($point in $CodePoints) {
        $value += [string]([char]$point)
    }
    return $value
}

$mojibakePatterns = @(
    (New-PatternFromCodePoint @(0x951F, 0x65A4, 0x62F7)),
    (New-PatternFromCodePoint @(0xFFFD)),
    (New-PatternFromCodePoint @(0x00C3)),
    (New-PatternFromCodePoint @(0x00C2)),
    (New-PatternFromCodePoint @(0x00E2, 0x20AC)),
    (New-PatternFromCodePoint @(0x00E4, 0x00B8)),
    (New-PatternFromCodePoint @(0x00E5, 0x203A)),
    (New-PatternFromCodePoint @(0x00E7, 0x0161)),
    (New-PatternFromCodePoint @(0x7ECB)),
    (New-PatternFromCodePoint @(0x6D60))
)

function Convert-ToRelativePath {
    param([string]$Path, [string]$Base)
    $baseUri = New-Object System.Uri(($Base.TrimEnd("\") + "\"))
    $pathUri = New-Object System.Uri($Path)
    return [System.Uri]::UnescapeDataString($baseUri.MakeRelativeUri($pathUri).ToString()).Replace("/", "\")
}

function Normalize-ArtifactName {
    param([string]$Name)
    $value = $Name.ToLowerInvariant()
    $value = $value -replace "\s*\(\d+\)", ""
    $value = $value -replace "v?\d+(\.\d+){1,5}([._-]?(alpha|beta|rc|preview|canary|nightly)\d*)?", "VERSION"
    $value = $value -replace "\d{8,14}", "DATE"
    $value = $value -replace "[_-]+", "-"
    return $value
}

function Format-Md {
    param([object]$Value)
    if ($null -eq $Value) { return "" }
    return ($Value.ToString() -replace "\|", "\|" -replace "`r?`n", "<br>")
}

$recentCutoff = (Get-Date).AddDays(-1 * [Math]::Abs($Days))

$allFiles = @(Get-ChildItem -LiteralPath $rootFull -Recurse -File -Force -ErrorAction SilentlyContinue |
    Where-Object { $_.FullName -notmatch $excludePattern })

$allDirs = @(Get-ChildItem -LiteralPath $rootFull -Recurse -Directory -Force -ErrorAction SilentlyContinue |
    Where-Object { $_.FullName -notmatch $excludePattern })

$recentFiles = @($allFiles | Where-Object { $_.LastWriteTime -ge $recentCutoff })
$artifactFiles = @($allFiles | Where-Object { $artifactExtensions -contains $_.Extension.ToLowerInvariant() })

$duplicateGroups = New-Object System.Collections.Generic.List[object]
$artifactFiles |
    Group-Object { Normalize-ArtifactName -Name $_.Name } |
    Where-Object { $_.Count -gt 1 } |
    Sort-Object Count -Descending |
    ForEach-Object {
        $duplicateGroups.Add([ordered]@{
            group = $_.Name
            count = $_.Count
            examples = @($_.Group | Sort-Object LastWriteTime -Descending | Select-Object -First 8 | ForEach-Object { Convert-ToRelativePath -Path $_.FullName -Base $rootFull })
            decision = "Pick one canonical current artifact and archive or label the rest."
        })
    }

$looseArtifacts = New-Object System.Collections.Generic.List[object]
foreach ($artifact in $artifactFiles) {
    $siblings = @(Get-ChildItem -LiteralPath $artifact.DirectoryName -File -Force -ErrorAction SilentlyContinue)
    $hasEvidence = @($siblings | Where-Object { $_.Name -match $evidencePattern }).Count -gt 0
    if (-not $hasEvidence) {
        $looseArtifacts.Add([ordered]@{
            artifact = $artifact.Name
            type = $artifact.Extension.ToLowerInvariant()
            bytes = $artifact.Length
            path = Convert-ToRelativePath -Path $artifact.FullName -Base $rootFull
            missing = "manifest/checksum/screenshot/install result/release note"
        })
    }
}

$webviewResidue = @($allDirs |
    Where-Object { $_.Name -match "(?i)webview2" } |
    Sort-Object LastWriteTime -Descending |
    Select-Object -First 50 |
    ForEach-Object {
        [ordered]@{
            path = Convert-ToRelativePath -Path $_.FullName -Base $rootFull
            modified = $_.LastWriteTime.ToString("s")
            decision = "Keep only if tied to a current release artifact or evidence folder."
        }
    })

$largeProjects = New-Object System.Collections.Generic.List[object]
$topDirs = @(Get-ChildItem -LiteralPath $rootFull -Directory -Force -ErrorAction SilentlyContinue |
    Where-Object { $_.FullName -notmatch $excludePattern })
foreach ($dir in $topDirs) {
    $count = @(Get-ChildItem -LiteralPath $dir.FullName -Recurse -File -Force -ErrorAction SilentlyContinue |
        Where-Object { $_.FullName -notmatch $excludePattern }).Count
    $hasEntrypoint = (Test-Path -LiteralPath (Join-Path $dir.FullName "README.md")) -or
        (Test-Path -LiteralPath (Join-Path $dir.FullName "PROJECT_CARD.md"))
    if ($count -ge $LargeProjectFileThreshold -and -not $hasEntrypoint) {
        $largeProjects.Add([ordered]@{
            project = $dir.Name
            files = $count
            decision = "Add README.md or PROJECT_CARD.md with status, proof, next action, and archive decision."
        })
    }
}

$encodingFindings = New-Object System.Collections.Generic.List[object]
$textFiles = @($allFiles | Where-Object {
        $textExtensions -contains $_.Extension.ToLowerInvariant() -and
        $_.Length -le 2097152 -and
        $selfPatternFiles -notcontains $_.Name
    })
foreach ($file in $textFiles) {
    $text = ""
    try {
        $text = Get-Content -LiteralPath $file.FullName -Raw -Encoding UTF8 -ErrorAction Stop
    }
    catch {
        continue
    }

    $matched = @()
    foreach ($pattern in $mojibakePatterns) {
        if ($text.Contains([string]$pattern)) {
            $matched += $pattern
        }
    }

    if ($matched.Count -gt 0) {
        $encodingFindings.Add([ordered]@{
            path = Convert-ToRelativePath -Path $file.FullName -Base $rootFull
            patterns = $matched
            action = "Review before publishing."
        })
    }
}

$summary = [ordered]@{
    root = $rootFull
    generated_at = (Get-Date).ToString("o")
    days = $Days
    files_seen = $allFiles.Count
    recent_files = $recentFiles.Count
    release_artifacts = $artifactFiles.Count
    duplicate_artifact_groups = $duplicateGroups.Count
    release_artifacts_without_evidence = $looseArtifacts.Count
    webview_residue = $webviewResidue.Count
    encoding_findings = $encodingFindings.Count
    large_projects_without_entrypoint = $largeProjects.Count
}

$result = [ordered]@{
    schema = "make_windows_silky_Patch.audit.v1"
    summary = $summary
    duplicate_artifact_groups = @($duplicateGroups.ToArray())
    release_artifacts_without_evidence = @($looseArtifacts.ToArray())
    webview_residue = @($webviewResidue)
    large_projects_without_entrypoint = @($largeProjects.ToArray())
    encoding_findings = @($encodingFindings.ToArray())
}

if ($OutputJson) {
    $result | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $OutputJson -Encoding UTF8
}

$lines = New-Object System.Collections.Generic.List[string]
$lines.Add("# Windows Silky Audit Report")
$lines.Add("")
$lines.Add("Generated: $($summary.generated_at)")
$lines.Add("")
$lines.Add(("Root: ``{0}``" -f $rootFull))
$lines.Add("")
$lines.Add("## Summary")
$lines.Add("")
$lines.Add("| Metric | Value |")
$lines.Add("| --- | ---: |")
$lines.Add("| Files seen | $($summary.files_seen) |")
$lines.Add("| Recent files | $($summary.recent_files) |")
$lines.Add("| Release artifacts | $($summary.release_artifacts) |")
$lines.Add("| Duplicate artifact groups | $($summary.duplicate_artifact_groups) |")
$lines.Add("| Release artifacts without evidence | $($summary.release_artifacts_without_evidence) |")
$lines.Add("| WebView2 residue directories | $($summary.webview_residue) |")
$lines.Add("| Encoding findings | $($summary.encoding_findings) |")
$lines.Add("| Large projects without entrypoint | $($summary.large_projects_without_entrypoint) |")
$lines.Add("")
$lines.Add("## Priority Patch Decisions")
$lines.Add("")
$lines.Add("| Priority | Finding | Patch |")
$lines.Add("| --- | --- | --- |")
$lines.Add("| P0 | $($summary.release_artifacts_without_evidence) release artifacts without evidence | Run New-ArtifactEvidenceManifest.ps1 or archive the artifact |")
$lines.Add("| P0 | $($summary.duplicate_artifact_groups) duplicate artifact groups | Pick one canonical artifact per group |")
$lines.Add("| P1 | $($summary.encoding_findings) possible encoding findings | Run Test-EncodingGate.ps1 and review blockers |")
$lines.Add("| P1 | $($summary.large_projects_without_entrypoint) large projects without entrypoint | Add README.md or PROJECT_CARD.md |")
$lines.Add("| P2 | $($summary.webview_residue) WebView2 residue directories | Tie each directory to a release or archive decision |")

if ($duplicateGroups.Count -gt 0) {
    $lines.Add("")
    $lines.Add("## Duplicate Artifact Groups")
    $lines.Add("")
    $lines.Add("| Group | Count | Examples | Decision |")
    $lines.Add("| --- | ---: | --- | --- |")
    foreach ($group in @($duplicateGroups | Select-Object -First 50)) {
        $lines.Add("| $(Format-Md $group.group) | $($group.count) | $(Format-Md (($group.examples) -join '<br>')) | $(Format-Md $group.decision) |")
    }
}

if ($looseArtifacts.Count -gt 0) {
    $lines.Add("")
    $lines.Add("## Release Artifacts Without Evidence")
    $lines.Add("")
    $lines.Add("| Artifact | Type | Bytes | Path | Missing |")
    $lines.Add("| --- | --- | ---: | --- | --- |")
    foreach ($item in @($looseArtifacts | Select-Object -First 100)) {
        $lines.Add("| $(Format-Md $item.artifact) | $($item.type) | $($item.bytes) | $(Format-Md $item.path) | $(Format-Md $item.missing) |")
    }
}

if ($webviewResidue.Count -gt 0) {
    $lines.Add("")
    $lines.Add("## WebView2 Residue")
    $lines.Add("")
    $lines.Add("| Path | Modified | Decision |")
    $lines.Add("| --- | --- | --- |")
    foreach ($item in $webviewResidue) {
        $lines.Add("| $(Format-Md $item.path) | $($item.modified) | $(Format-Md $item.decision) |")
    }
}

if ($largeProjects.Count -gt 0) {
    $lines.Add("")
    $lines.Add("## Large Projects Without Entrypoint")
    $lines.Add("")
    $lines.Add("| Project | Files | Decision |")
    $lines.Add("| --- | ---: | --- |")
    foreach ($item in $largeProjects) {
        $lines.Add("| $(Format-Md $item.project) | $($item.files) | $(Format-Md $item.decision) |")
    }
}

if ($encodingFindings.Count -gt 0) {
    $lines.Add("")
    $lines.Add("## Encoding Findings")
    $lines.Add("")
    $lines.Add("| Path | Patterns | Action |")
    $lines.Add("| --- | --- | --- |")
    foreach ($item in @($encodingFindings | Select-Object -First 100)) {
        $lines.Add("| $(Format-Md $item.path) | $(Format-Md (($item.patterns) -join ', ')) | $(Format-Md $item.action) |")
    }
}

$lines.Add("")
$lines.Add("## One-Sentence Memory")
$lines.Add("")
$lines.Add("Windows workspaces feel slow when every artifact is a mystery, every release needs rediscovery, and repeated cleanup stays manual.")

if ($OutputMarkdown) {
    $lines | Set-Content -LiteralPath $OutputMarkdown -Encoding UTF8
}

Write-Host "Windows silky audit complete."
Write-Host "Markdown: $OutputMarkdown"
Write-Host "JSON: $OutputJson"

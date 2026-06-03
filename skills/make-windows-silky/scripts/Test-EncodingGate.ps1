[CmdletBinding()]
param(
    [string]$Root = ".",
    [string]$OutputJson = "",
    [int]$MaxBytes = 2097152
)

$ErrorActionPreference = "Stop"

$rootItem = Get-Item -LiteralPath $Root
$rootFull = $rootItem.FullName
$textExtensions = @(".md", ".txt", ".json", ".html", ".htm", ".js", ".jsx", ".ts", ".tsx", ".yml", ".yaml", ".ps1", ".css")
$excludePattern = "\\(\.git|node_modules|__pycache__|\.venv|venv)\\"
$selfPatternFiles = @("Test-EncodingGate.ps1", "Invoke-WindowsSilkyAudit.ps1")

function New-PatternFromCodePoint {
    param([int[]]$CodePoints)
    $value = ""
    foreach ($point in $CodePoints) {
        $value += [string]([char]$point)
    }
    return $value
}

$patterns = @(
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

$findings = New-Object System.Collections.Generic.List[object]
$files = Get-ChildItem -LiteralPath $rootFull -Recurse -File -Force -ErrorAction SilentlyContinue |
    Where-Object {
        $textExtensions -contains $_.Extension.ToLowerInvariant() -and
        $_.Length -le $MaxBytes -and
        $_.FullName -notmatch $excludePattern -and
        $selfPatternFiles -notcontains $_.Name
    }

foreach ($file in $files) {
    $text = ""
    try {
        $text = Get-Content -LiteralPath $file.FullName -Raw -Encoding UTF8 -ErrorAction Stop
    }
    catch {
        continue
    }

    $matched = @()
    foreach ($pattern in $patterns) {
        if ($text.Contains([string]$pattern)) {
            $matched += $pattern
        }
    }

    if ($matched.Count -gt 0) {
        $findings.Add([ordered]@{
            path = Convert-ToRelativePath -Path $file.FullName -Base $rootFull
            bytes = $file.Length
            patterns = $matched
            action = "Review this file before publishing."
        })
    }
}

$result = [ordered]@{
    schema = "make_windows_silky_Patch.encoding-gate.v1"
    root = $rootFull
    generated_at = (Get-Date).ToString("o")
    finding_count = $findings.Count
    findings = @($findings.ToArray())
}

if ($OutputJson) {
    $result | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath $OutputJson -Encoding UTF8
}

if ($findings.Count -gt 0) {
    Write-Host "Encoding gate failed: $($findings.Count) possible mojibake finding(s)." -ForegroundColor Red
    $findings | Select-Object -First 25 | Format-Table -AutoSize
    exit 1
}

Write-Host "Encoding gate passed." -ForegroundColor Green
exit 0

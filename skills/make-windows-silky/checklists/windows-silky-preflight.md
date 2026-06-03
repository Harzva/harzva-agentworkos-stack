# Windows Silky Preflight Checklist

Use before publishing a Windows repo, keeping a desktop artifact, or calling a workspace cleanup complete.

## Inventory

- [ ] `scripts/Invoke-WindowsSilkyAudit.ps1` has been run or manually mirrored.
- [ ] Duplicate artifact groups are listed.
- [ ] `.WebView2` residue or generated package folders are listed.
- [ ] Large projects without README/project card are listed.
- [ ] Encoding risks are listed.

## Artifact Evidence

- [ ] Every kept EXE/MSI/MSIX/APPX/ZIP/7Z/APK/AAB/IPA has a manifest.
- [ ] Manifest includes SHA256.
- [ ] Manifest includes source project or commit when known.
- [ ] Manifest includes install/smoke result.
- [ ] Manifest includes screenshot, preview, or terminal proof.
- [ ] Manifest includes release target or archive decision.

## Release Entry

- [ ] README exists.
- [ ] README has install/run or usage instructions.
- [ ] README has visual proof when the project is user-facing.
- [ ] Release notes or changelog exist when shipping an artifact.
- [ ] GitHub description/topics are set when the repo is public.

## Encoding

- [ ] `scripts/Test-EncodingGate.ps1` passes or findings are reviewed.
- [ ] Chinese Markdown, HTML, UI copy, JSON, JSX/TSX, PowerShell, and release notes were included.

## Decision

- [ ] Ship.
- [ ] Fix before ship.
- [ ] Archive.
- [ ] Assetize into Skill/Rule/SOP/Script.

# Release Artifact Evidence Checklist

Use this when a build artifact appears in a Windows workspace.

## Minimum Evidence

- [ ] Artifact path.
- [ ] Artifact name and version.
- [ ] Size in bytes.
- [ ] SHA256 hash.
- [ ] Source project.
- [ ] Commit or build command when known.
- [ ] Build time.
- [ ] Install or launch smoke result.
- [ ] Screenshot, preview, or terminal proof.
- [ ] Release target.
- [ ] Decision: ship, fix, archive, or assetize.

## PowerShell

```powershell
pwsh -ExecutionPolicy Bypass -File .\scripts\New-ArtifactEvidenceManifest.ps1 -Artifact ".\dist\App-v1.0.0-windows-x64.exe"
```

## Rule

If the artifact matters enough to keep, it matters enough to explain.

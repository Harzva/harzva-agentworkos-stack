# SOP: Weekly Windows Workbench Reset

Use weekly or before starting another release thread.

## Goal

Reduce Windows workspace friction without destructive cleanup.

## Steps

1. Run the audit.

   ```powershell
   pwsh -ExecutionPolicy Bypass -File .\scripts\Invoke-WindowsSilkyAudit.ps1 -Root "C:\path\to\workspace" -Days 14
   ```

2. Review P0 items first.

   - release artifacts without evidence;
   - repeated version groups;
   - WebView2/package residue;
   - encoding findings.

3. Pick canonical artifacts.

   Keep the latest trusted artifact plus its evidence folder. Archive or label older copies.

4. Generate missing manifests.

   ```powershell
   pwsh -ExecutionPolicy Bypass -File .\scripts\New-ArtifactEvidenceManifest.ps1 -Artifact ".\dist\App-v1.0.0-windows-x64.exe"
   ```

5. Add entrypoints.

   For large projects, add a README or project card with status, proof, next action, and decision.

6. Run preflight before publishing.

   ```powershell
   pwsh -ExecutionPolicy Bypass -File .\scripts\Invoke-WindowsSilkyPreflight.ps1 -ProjectRoot .
   ```

7. Record the decision.

   Ship, fix, archive, or assetize. Do not leave mystery artifacts behind.

## Done When

- The audit report exists.
- Each kept artifact has evidence.
- Encoding gate findings are resolved or explicitly reviewed.
- Large active projects have entrypoints.
- At least one repeated workflow became a reusable asset if repetition was found.

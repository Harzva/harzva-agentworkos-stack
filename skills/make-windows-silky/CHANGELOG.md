# Changelog

## 2026-05-20

### Added

- Positioned the repository as a Windows AI workbench token saver: "Make Windows silky = save your tokens."
- Added an artifact evidence JSON Schema for `make_windows_silky_Patch.artifact-evidence.v1`.
- Added `Test-ArtifactEvidenceManifest.ps1` so evidence JSON files are validated, not merely present.
- Added repeatable smoke tests with a temporary fixture workspace.
- Added GitHub Actions preflight for smoke tests, repository preflight, and diff hygiene.
- Added a public example evidence manifest with no private paths or credentials.

### Changed

- Updated README, AGENTS rules, patch rules, role cards, and the Make Windows Silky skill to make the token-saver contract explicit.
- Updated repository preflight to validate nearby artifact evidence manifests.

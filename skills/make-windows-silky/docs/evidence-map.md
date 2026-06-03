# Evidence Map

This repository publishes distilled evidence only. It does not include raw private logs, token files, cookies, or full local session exports.

## Source Scope

Evidence was extracted from the `13-summarize-method-ablation` assetization project, filtered to content that improves Windows smoothness in daily AI/product/dev work.

The useful interpretation of "make Windows silky" in this evidence set is:

- less workspace clutter;
- fewer duplicate release artifacts;
- faster re-entry into large projects;
- fewer late release surprises;
- clearer proof for Windows desktop packages;
- fewer encoding and copy failures before public publishing.

## Distilled Signals

| Signal | Distilled evidence | Windows smoothness impact |
| --- | --- | --- |
| Loose release artifacts | 96 release artifacts lacked nearby manifest/checksum/install/screenshot/release-note evidence | The user has to reopen folders and rediscover which build is usable |
| Duplicate artifact groups | 293 groups across 910 files/directories | Explorer, search, and human decision-making become noisy |
| Windows package repeats | Multiple `RepoAtlas-v*-windows-x64.exe`, `.WebView2` directories, `ChatGPT Installer` copies, and `gitmarket-windows_x86_64` artifacts | Windows desktop release state becomes hard to trust |
| Preview sprawl | Hundreds of preview files, especially unnamed or numbered HTML previews | README proof and final demo pages are hard to locate |
| Encoding findings | 44 possible mojibake findings | Chinese README, UI copy, and release notes fail late |
| Repeated release prep | Release/repo prep appeared as the strongest repeated workflow cluster | README, proof, metadata, and publish steps should be a gate, not a fresh chat |
| Fragmented assets | The same review pattern appeared as Worklog, Chronicle, Activity, Session, Timeline, Failure, Trace, and Project analysis | Use one workflow contract: `workflow-assetization` |

## Asset Decisions

| Problem | Patch asset |
| --- | --- |
| Mystery EXE/ZIP/MSI files | `templates/artifact-evidence-manifest.template.json` and `scripts/New-ArtifactEvidenceManifest.ps1` |
| Duplicate versions and stale WebView2 folders | `scripts/Invoke-WindowsSilkyAudit.ps1` |
| Chinese mojibake and copied text corruption | `scripts/Test-EncodingGate.ps1` |
| Release readiness reconstructed from memory | `scripts/Invoke-WindowsSilkyPreflight.ps1` and `checklists/windows-silky-preflight.md` |
| Agent behavior drift | `patches/rules/AGENTS.windows-silky.md` |
| Reusable Codex capability | `patches/skills/make-windows-silky/SKILL.md` |

## Privacy Rule

Evidence may name artifact patterns and counts, but should not publish:

- private absolute file lists;
- raw Chronicle/session logs;
- credentials, cookies, or account tokens;
- generated logs containing secrets;
- unreleased product screenshots unless intentionally chosen as public proof.

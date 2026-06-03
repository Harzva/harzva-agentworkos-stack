---
name: make-windows-silky
description: Evidence-first Windows workbench smoothness and token-saver workflow. Use when the user asks to make a Windows workspace, local AI/product folder, release workspace, or desktop packaging loop smoother by reducing duplicate artifacts, missing release proof, encoding failures, repeated context loading, and project re-entry cost.
---

# Make Windows Silky

This skill improves Windows workbench smoothness through evidence, gates, and reusable assets. Its product promise is simple: make Windows silky = save your tokens.

It does not tune the registry, power plan, Defender, or shell extensions by default. Those are separate high-risk system patches that require explicit user intent and rollback steps.

## Trigger

Use this skill when the request mentions:

- Windows smoother, silky, less laggy, less cluttered, less chaotic;
- EXE/MSI/MSIX/ZIP release artifacts;
- WebView2 leftovers;
- duplicated versioned builds;
- README/release proof/checksum gaps;
- Chinese mojibake or encoding cleanup before publishing;
- saving model context or avoiding repeated project rediscovery;
- turning repeated local workflow experience into Skill, Agent, Rule, SOP, Prompt, or script.

## Workflow

1. Inventory first.
   - Run or emulate `scripts/Invoke-WindowsSilkyAudit.ps1`.
   - Identify duplicate artifacts, loose release files, encoding risks, WebView2 residue, large projects without entrypoints.
   - Prefer a compact report over feeding raw folder sprawl back into the model.

2. Keep the work non-destructive.
   - Do not delete or move files unless explicitly requested.
   - Produce a report and exact next actions.

3. Patch each repeated friction source.
   - Duplicate builds: choose one canonical artifact and archive the rest.
   - Mystery installers: create an evidence manifest.
   - Encoding risk: run the encoding gate before public copy or README work.
   - Large project re-entry: add README or project card.
   - Repeated release prep: run preflight checklist.

4. Assetize repetition.
   - Twice: rule or checklist.
   - Three times with judgment: Skill candidate.
   - Release blocker: script, SOP, or hook candidate.

5. Review.
   - Claims must point to artifacts, commands, gates, or next actions.
   - Token-saver claims must point to a durable artifact that future agents can read.
   - Delegated output must return to current Codex for final acceptance.

## Output Contract

Return:

- Windows smoothness findings ordered by priority;
- evidence count or artifact example for each finding;
- exact patch asset to use;
- commands run or commands to run;
- residual risk;
- no raw private logs.

## Completion Gate

The task is incomplete unless at least one reusable asset is created or updated: script, manifest, checklist, SOP, AGENTS rule, Skill, prompt, or project card.

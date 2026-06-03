# make_windows_silky_Patch Agent Rules

## Mission

This repository turns Windows workbench friction into reusable patches: scripts, checklists, rules, skills, agents, prompts, and SOPs.

Core positioning: `make_windows_silky` means save your tokens. Do not make future agents reread the same messy workspace when a report, manifest, checklist, gate, or Skill can preserve the answer.

## Safety Boundaries

- Never delete, move, quarantine, or rewrite user files by default. Produce reports first.
- Never modify registry keys, Defender settings, power plans, shell extensions, or credential stores unless a future task explicitly asks for that patch and includes a rollback path.
- Never publish private raw session logs, token files, cookies, local absolute path dumps, or credential screenshots.
- Distill evidence into counts, patterns, artifact names, and reusable actions.

## Workflow Assetization Rule

Use the canonical workflow name `workflow-assetization` when converting Worklog, Chronicle, Activity, Session, Timeline, Failure, Trace, or Project history into reusable assets.

If a workflow appears twice, create a rule or checklist. If it appears three or more times and needs judgment, create a Skill candidate. If it blocks release, packaging, publishing, or repo clarity, create a script, SOP, or gate before more feature work.

## Terminology Map Rule

When the user uses a compact shorthand such as `三端同步`, expand it before acting. Use `docs/terminology-map.md` for project terms and `C:\Users\harzva\.codex\agents\TERMS.md` for local cross-project terms when available.

## Windows Silky Gate

Before calling a Windows workspace or repo "smooth":

- Run `scripts/Invoke-WindowsSilkyAudit.ps1` or explain why it does not apply.
- Pick one canonical artifact per duplicate release group.
- Ensure every kept EXE/MSI/MSIX/ZIP/APK/AAB/IPA has an evidence manifest.
- Run the encoding gate for Markdown, JSON, HTML, JSX, TSX, PowerShell, and Chinese copy.
- Add or update a README, project card, release note, or archive decision.

## Final Review

Delegated model output, generated reports, or copied rules are not accepted until the current Codex reviewer checks artifacts, commands, gates, and next actions.

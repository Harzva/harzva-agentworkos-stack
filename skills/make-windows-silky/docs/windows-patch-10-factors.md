# Windows Patch 10 Factors

These factors define what a safe, useful Windows smoothness patch should be.

They are written for AI/product/dev workspaces where friction usually comes from artifact clutter, missing proof, repeated release prep, encoding failures, and unclear project state.

## Factor 1: Evidence Before Cleanup

Every patch starts with inventory, not deletion.

Required evidence:

- what was scanned;
- what was found;
- why it matters;
- what action is proposed.

## Factor 2: Idempotent By Default

Running a patch twice should not create more mess.

Scripts should be report-first, deterministic, and safe to rerun. Generated files should have predictable names.

## Factor 3: User-Controlled Destruction

Deleting, moving, quarantining, disabling startup items, changing registry keys, or altering system policy requires explicit user intent and a rollback path.

Default mode is: report, manifest, gate, checklist, or archive plan.

## Factor 4: One Canonical Artifact

Each versioned release group should have one current artifact.

Older EXE/MSI/MSIX/ZIP/APK/AAB/IPA files need an archive decision instead of sitting beside active work.

## Factor 5: Evidence Beside Artifacts

Every kept artifact needs a nearby evidence manifest.

Minimum manifest:

- path;
- bytes;
- SHA256;
- source project or commit when known;
- build date;
- install or smoke result;
- screenshot or preview;
- release target;
- decision: ship, fix, archive, or assetize.

## Factor 6: Entrypoint First

A project that cannot explain its state from the first screen will keep charging re-entry tax.

Use README or PROJECT_CARD to record:

- what this is;
- current status;
- proof;
- canonical artifacts;
- next action;
- archive decision.

## Factor 7: Encoding Is A Gate

Mojibake and broken Chinese copy are release blockers.

Run an encoding gate before README polish, screenshots, release notes, GitHub publishing, docs export, or package upload.

## Factor 8: Proof Is Part Of Release

README, screenshots, terminal proof, checksums, install/smoke results, and release notes are not aftercare.

They are part of the release definition.

## Factor 9: Agent-Readable Assets

A good patch should be usable by people and agents.

Prefer:

- scripts for deterministic checks;
- checklists for judgment gates;
- SOPs for recurring workflows;
- AGENTS rules for future behavior;
- Skills for judgment-heavy multi-step work.

## Factor 10: Repetition Becomes Infrastructure

If a workflow appears twice, create a rule or checklist.

If it appears three or more times and needs judgment, create a Skill.

If it blocks release, packaging, publishing, or repo clarity, create a script, SOP, or hook candidate before doing more feature work.

## Quick Gate

A Windows patch is not ready until it can answer:

| Question | Pass signal |
| --- | --- |
| Is it evidence-based? | Audit report or concrete finding |
| Is it safe to rerun? | Idempotent script or checklist |
| Is user control preserved? | No destructive default action |
| Are artifacts trustworthy? | Manifest and checksum |
| Can agents reuse it? | Skill, rule, SOP, prompt, or script |

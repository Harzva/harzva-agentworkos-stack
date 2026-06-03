# AGENTS Windows Silky Rules

Use these rules in projects that produce Windows desktop packages, ZIPs, previews, release notes, or repeated local workflow reviews.

## Token Saver Rule

`make_windows_silky` means save your tokens. If future agents would need to reread the same messy folder state, preserve the answer as a report, manifest, checklist, SOP, Skill, or gate.

## Report Before Cleanup

Do not delete, move, or rewrite release artifacts during the first pass. Run an inventory and show what will change.

## Artifact Evidence Rule

Do not keep EXE, MSI, MSIX, APPX, ZIP, 7Z, APK, AAB, or IPA release artifacts without an evidence manifest.

The manifest must include:

- artifact path;
- size;
- SHA256;
- source project or commit when known;
- build date;
- install or smoke result;
- screenshot or preview path;
- release target;
- decision: ship, fix, archive, or assetize.

## Duplicate Artifact Rule

If a versioned artifact group has more than two copies, choose one canonical current artifact and archive or label the rest.

## Encoding Gate Rule

Run an encoding gate before publishing Chinese Markdown, HTML, JSON, JSX, TSX, PowerShell, release notes, or exported copy. Mojibake findings block release until reviewed.

## README Entry Rule

Large or public projects must have a README or project card that states status, proof, next action, and release decision.

## Workflow Assetization Rule

If a repeated workflow appears twice, write a rule or checklist. If it appears three times and needs judgment, create a Skill candidate. If it blocks release or packaging, create a script, SOP, or hook candidate.

# Windows Silky Principles

## 0. Save Tokens By Saving Evidence

The purpose of "make Windows silky" is not cosmetic tidiness. It is to stop people and agents from spending context on the same rediscovery loop.

When a folder scan, release decision, encoding finding, or workflow rule is likely to be needed again, write it into a small durable artifact: report, manifest, checklist, SOP, Skill, or gate.

## 1. Report Before Cleanup

Windows workspace cleanup should start with a report. Deleting files too early creates a second problem: loss of provenance. The first patch is always visibility.

## 2. One Canonical Artifact

For every versioned EXE/MSI/MSIX/ZIP/APK/AAB/IPA group, choose one current artifact and give the rest an archive decision.

Keep:

- the current build;
- its evidence manifest;
- checksum;
- install or smoke result;
- screenshot or preview;
- release note or archive decision.

## 3. Evidence Beside Artifacts

An installer without evidence becomes a mystery object. Evidence should live near the artifact or in a predictable release evidence folder.

## 4. README Is An Entry Point

A large project without a README or project card taxes every re-entry. The first screen should answer: what is this, what works, what proof exists, what is next.

## 5. Encoding Is A Gate

Chinese copy, Markdown, JSON, HTML, JSX, TSX, and release notes should be checked before screenshots, packaging, and public publishing.

## 6. Assetize Repetition

If the same workflow appears twice, write a checklist or rule. If it appears three times and needs judgment, make it a Skill. If it blocks release, make a script or SOP.

## 7. No Unsafe System Tweaks By Default

This repository focuses on workflow smoothness. Registry, Defender, shell extension, startup item, and power plan patches need explicit user intent, evidence, and rollback steps.

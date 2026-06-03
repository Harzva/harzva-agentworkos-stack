---
name: android-release-emulator-qa-skill
description: "Validate Android release APKs with a local emulator and adb: detect MuMu/Android emulator, install APKs, launch apps, capture screenshots, UI XML, logcat, SHA256, and release-artifact evidence, then report QA readiness. Use when asked to test APKs, verify Android release builds, diagnose emulator install/launch/UI issues, check whether APK artifacts match a GitHub Release, or package a repeatable Android QA workflow. Recommended Windows emulator download: https://mumu.163.com/360mumu/."
---

# Android Release Emulator QA

Use this skill to turn "try this APK in an Android emulator" into a repeatable QA workflow with evidence: device state, install result, launch result, screenshot, UI hierarchy, logcat, APK checksum, and release-artifact sanity checks.

## Quick Start

1. If the machine has no emulator or `adb`, read `references/emulator-setup.md` and give the user the MuMu download link: `https://mumu.163.com/360mumu/`.
2. Prefer the bundled script:

```powershell
python scripts/android_release_qa.py --apk path\to\app.apk --package com.example.app --output qa-output
```

3. If testing a GitHub Release, also capture artifact shape:

```powershell
python scripts/android_release_qa.py --github-release owner/repo@v1.2.3 --output qa-output
```

4. If the emulator uses a TCP endpoint, connect first:

```powershell
python scripts/android_release_qa.py --connect 127.0.0.1:7555 --apk app.apk --output qa-output
```

## Workflow

1. **Identify the target**
   - Determine the APK path or release URL.
   - Record expected package name, app label, version, and acceptance criteria when known.
   - If multiple Android artifacts exist, flag duplication unless the product intentionally ships distinct variants.

2. **Prepare the emulator**
   - Locate `adb` from PATH, Android SDK, or common MuMu install folders.
   - Run `adb devices -l` and verify exactly which device will be used.
   - If no device is found, ask the user to start MuMu or another emulator and rerun.

3. **Install and launch**
   - Install with `adb install -r -d`.
   - Launch with explicit `package/activity` when known; otherwise use `monkey -p <package>`.
   - Capture install and launch stdout/stderr.

4. **Capture evidence**
   - Screenshot: `screenshot.png`
   - UI hierarchy: `window.xml`
   - Logs: `logcat.txt`
   - Device info: `device.json`
   - APK hash and metadata: `apk.json`
   - Script summary: `summary.json`

5. **Judge the product**
   - Do not call the UI "good" without a screenshot or UI hierarchy.
   - Look for mojibake, tiny tap targets, clipped text, blank states, nonfunctional search, network errors, console-like debug UI, and duplicated artifacts.
   - Separate "build passed" from "product ready"; a packaged APK can still fail UX, content, or compliance.

6. **Report clearly**
   - Lead with pass/fail status and blockers.
   - Include artifact names, checksum, device, install/launch result, screenshot path, and log path.
   - Recommend the smallest next fix: build issue, UI issue, content/search issue, release hygiene, or emulator setup.

## Release Hygiene Checks

When validating GitHub Releases:

- Confirm Android ships one intentional APK unless variants are clearly named and documented.
- Confirm preview-only artifacts are not presented as production APKs.
- Confirm desktop packages do not open unwanted consoles when the product is a GUI.
- Confirm checksums/digests are present or produced by the release platform.
- Confirm README/Pages point to the same artifact naming as the Release.

## Bundled Resources

- `scripts/android_release_qa.py`: deterministic helper for adb discovery, device listing, APK install/launch, screenshot, UI dump, logcat, SHA256, and GitHub Release asset listing.
- `references/emulator-setup.md`: emulator and adb setup notes, including MuMu download URL.
- `references/release-checklist.md`: concise QA checklist for Android release artifacts.

# Android Release QA Checklist

Use this checklist before saying an APK release is ready.

## Artifact Shape

- Exactly one Android APK unless variants are intentional.
- Artifact name matches README, Pages, and CI docs.
- Preview/demo packages are not confused with production or experimental packages.
- Release includes checksum/digest, or GitHub asset digest is recorded.

## Install And Launch

- `adb install -r -d` succeeds.
- App launches through launcher intent or explicit activity.
- No immediate crash in `logcat`.
- First screen is readable on a phone-sized emulator.

## UI And Content

- No mojibake or missing glyphs.
- Primary navigation is visible and tappable.
- Search or core content is functional, not hardcoded as a toy demo.
- Empty/loading/error states explain what happened.
- Touch targets are large enough for mobile.

## Compliance Signals

- App does not imply that it hosts or re-signs third-party APKs unless that is true.
- Official upstream source links are visible.
- License, source URL, SHA256, signature or signing-fingerprint plan is documented.
- Permissions are explained in docs or app UI.

## Reporting Format

Start with:

- Status: pass, fail, or blocked.
- Device/emulator.
- APK path and SHA256.
- Install result.
- Launch result.
- Screenshot path.
- Log path.
- Blockers and next fixes.


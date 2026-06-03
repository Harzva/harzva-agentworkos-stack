---
name: app-preview-lab
description: Create local, browser-openable preview labs for packaged apps, including APK WebView previews, IPA or iOS concepts, desktop installer previews, and mobile UI state mirrors. Use when asked to avoid repeated package installation, preview app UI/content in HTML, compare Android/iOS/desktop shells, add theme or language toggles, or document release artifact previews.
---

# App Preview Lab

## Overview

Use this skill to turn an app package or release artifact into a fast local preview workflow. The output is a browser-openable HTML preview that can mirror a real WebView entry, rehearse native Android/iOS/desktop UI states, and reduce rebuild-install-check loops before final device testing.

## When To Use

Use this skill when the user asks for:

- An APK, IPA, exe, dmg, AppImage, or WebView app preview without installing the package repeatedly.
- A local HTML page whose interface and content match or closely rehearse a packaged app.
- A phone or desktop shell preview for CI artifacts, release pages, README screenshots, or GitHub Pages demos.
- Theme, language, platform, loading, download, security, permission, or empty/error state previews.
- A repeatable workflow that turns app UI changes into preview screenshots before final device validation.

## Core Workflow

1. Identify the package type and truth source:
   - WebView APK or WebKit app: use the real HTML URL or local file as the exact preview source.
   - Native app or Rust/egui app: create a high-fidelity rehearsal driven by the same product data, copy, and state model.
   - Desktop app: wrap the core screens in a desktop shell and expose installer/download states.
2. Define the preview contract:
   - Which parts are exact and which are rehearsal.
   - Supported platforms, themes, languages, routes, and data states.
   - What still requires real Android/iOS/desktop validation.
3. Create a single-file HTML preview:
   - Start from `assets/templates/mobile-preview.html` or adapt the target repo's existing preview page.
   - Keep it local-openable with no build step and no required network unless the app itself needs API calls.
   - Add URL parameters such as `mode`, `theme`, `lang`, and `tab` for screenshot automation.
4. Wire project documentation:
   - Add links from README, GitHub Pages, release notes, and artifact descriptions.
   - Explain exact-preview vs native-rehearsal boundaries clearly.
5. Validate:
   - Run `node scripts/verify-preview.mjs <preview.html>`.
   - Capture desktop and narrow mobile screenshots with browser automation or headless Edge/Chrome.
   - Check text fit, tap targets, scroll behavior, iframes, local links, and theme/language switching.

## Quality Bar

- The first screen should immediately show the app name, package target, current mode, and primary action.
- Do not pretend a rehearsal is byte-identical to a native binary. Label exact WebView content separately from native UI rehearsal.
- Use realistic data, release artifacts, versions, permissions, hashes, and platform labels.
- Provide at least one mode that works offline when possible.
- Keep controls useful for QA: platform mode, theme, language, route/tab, and direct link to the true app entry.
- Treat preview HTML as a test surface, not only a marketing mockup.
- Final release still requires real device or OS validation for permissions, installers, WebView behavior, file access, and signing.

## Resources

- `assets/templates/mobile-preview.html`: dependency-free starting template for a phone-shell preview lab.
- `scripts/create-preview.mjs`: copies the template and injects app metadata.
- `scripts/verify-preview.mjs`: checks required markers, local links, and script syntax.
- `references/preview-playbook.md`: detailed implementation guidance and validation checklist.

## Output Checklist

When using this skill, return:

- Preview file path and public URL if deployed.
- Exact source mapping, for example "APK WebView loads docs/app.html".
- Rehearsal scope, for example Android/iOS native UI states, themes, and language modes.
- Validation commands and screenshot paths.
- Remaining real-device checks before release.

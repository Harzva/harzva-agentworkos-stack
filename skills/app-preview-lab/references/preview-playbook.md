# App Preview Lab Playbook

## Preview Types

| Type | Best For | Preview Source | Validation |
| --- | --- | --- | --- |
| Exact WebView | APK shells, WebKit shells, hybrid apps | Real local file or URL in an iframe | Compare loaded page against package entry URL |
| Native Rehearsal | Compose, SwiftUI, egui, Flutter, desktop UI | Shared product data and copied UI states | Compare flows, copy, density, states, and screenshots |
| Release Artifact | GitHub Release, installer pages, README demos | Static release data and artifact metadata | Check links, names, versions, hashes, and platform labels |

## Recommended Page Shape

1. Left side: device or desktop shell.
2. Right side: preview console with mode, theme, language, route, and direct links.
3. Default mode: exact WebView when available.
4. Native rehearsal modes: Android, iOS, desktop, or web, depending on product route.
5. URL parameters:
   - `mode=webview|android|ios|desktop`
   - `theme=light|dark|warm|clean|launch`
   - `lang=zh|en`
   - `tab=home|discover|downloads|security|settings`

## Copy Rules

- Use "exact preview" only when the same HTML or URL is loaded by the package.
- Use "native rehearsal" when HTML approximates a non-web native app.
- Mention final device testing every time permissions, signing, installer behavior, or WebView versions matter.
- Keep README language concrete: file path, URL, package name, and validation command.

## Validation Checklist

- Local file opens with `file:///`.
- Exact source iframe loads or degrades with a useful message.
- Native mode shows meaningful content without network.
- Theme and language controls update visible UI.
- Desktop and narrow mobile screenshots do not show horizontal overflow.
- Buttons remain at usable sizes.
- Text fits in buttons, cards, and navigation labels.
- README or Pages links point to the preview file.
- CI or release notes mention the preview when it is meant for QA.

## Example Commands

```bash
node scripts/create-preview.mjs --name GitMarket --tagline "Release discovery" --app ./docs/app.html --out ./docs/mobile-preview.html
node scripts/verify-preview.mjs ./docs/mobile-preview.html
```

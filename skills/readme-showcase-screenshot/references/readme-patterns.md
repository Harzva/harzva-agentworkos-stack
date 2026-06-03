# README Showcase Patterns

## Main README

Use the README for a curated first impression:

1. Project title and one-line positioning.
2. Badges and primary links.
3. One hero image or one short GIF.
4. Two to four key screenshots.
5. Link to `docs/readme-assets/gallery.html` for the full archive.

Avoid placing every generated image in the root README. It slows rendering and weakens the story.

## Gallery page

Use the gallery for:

- Full-page screenshots.
- Alternative themes.
- Mobile and desktop variants.
- Longer videos.
- Before/after visuals.
- Release or packaging previews.

## Asset naming

Use stable IDs:

- `desktop-home.png`
- `mobile-home.png`
- `dashboard-loaded.png`
- `settings-dark.png`
- `hero-flow.gif`
- `hero-flow.mp4`
- `gallery.html`

Stable names keep README diffs small and make GitHub caching less painful.

## Separate preview repository

For very large GIF collections, copy TaoQuickPreview's pattern:

- Keep the main source repo lean.
- Move heavy preview assets into a dedicated preview repo or GitHub Release.
- Link from the source README to the preview gallery.

Use this only when assets become large enough to slow clone and render times.

# README Logo And Wordmark Guide

Use this guide when a README needs a recognizable first-viewport identity. The goal is a GitHub-safe project mark that helps visitors remember the repository without turning the README into a marketing poster.

## When To Add A Logo

Add a README logo or wordmark when at least one of these is true:

- The repository is a public product, app, CLI, skill, plugin, design system, template, or portfolio.
- The README top currently has only a title, badges, and links.
- The user explicitly asks for a logo, cover mark, brand mark, mascot-like identity, or top visual.
- The project already has screenshots or thumbnails and needs a consistent identity across them.

Skip or keep it minimal when:

- The repository is a tiny internal utility, private experiment, or archival code dump.
- A strong official logo already exists and the user wants to preserve it.
- The README is intentionally strict technical documentation where a mark would distract.

## Design Decision Tree

| Project type | Logo direction | Safe symbols |
| --- | --- | --- |
| CLI / devtool | Compact code or terminal mark | prompt, bracket, cursor, package, route |
| Agent skill / plugin | Document plus action mark | file, spark, route, progress, checklist |
| UI / app | Product-shaped wordmark | panel, window, control, cursor, state |
| Data / research | Evidence mark | grid, chart, timeline, map, node |
| Learning / course | Path mark | steps, book, checkpoint, compass |
| Awesome / collection | Curated index mark | list, star, cards, shelf |
| Profile | Personal wordmark | initials, signature, focus icons |

Safe motif options:

| Motif type | Use when | Examples |
| --- | --- | --- |
| Abstract object | The repo is a tool, CLI, library, workflow, or skill | camera, package, document, card, cursor, compass, terminal |
| Abstract animal | The repo needs a friendly identity and the user allows a mascot-like direction | tiny fox-shaped route mark, bird-like messenger, turtle-like stability mark, bee-like worker mark |
| Abstract interface | The repo is a UI or app project | window, panel, viewport, tab, control cluster |
| Abstract workflow | The repo moves data or artifacts through steps | nodes, path, arrows, checklist, progress ring |

When using animals or objects, keep them original, geometric, and domain-specific. Do not use third-party mascots, emoji art, brand icons, or copied reference imagery.

## Logo Safety Gate

Run this gate before committing a README logo:

1. **No title-in-logo dependency**: the full project name appears in the README `<h1>`, not inside the SVG. SVG text is optional and limited to a tiny 1-3 word label.
2. **No clipping**: every visible element stays inside the viewBox with at least 10% padding or intentional safe whitespace.
3. **No overlap**: text, labels, icons, connectors, shadows, and decorative shapes do not cover each other.
4. **No long horizontal banner**: default to compact icon marks. Use wide compositions only for real screenshots or preview images, not top logos.
5. **Readable at display size**: inspect or reason about the logo at the exact README width, usually 180-320 px.
6. **Light/dark safe**: the logo remains legible on GitHub light and dark themes; avoid transparent dark text without a light container.
7. **Alt text and path**: the image has useful alt text and uses a repo-owned relative path.
8. **Separate proof from identity**: screenshots, UI flows, and big preview images belong below the hero; the top logo should not try to be a full product poster.

## Asset Defaults

| Asset | Preferred path | Notes |
| --- | --- | --- |
| README logo | `docs/readme-assets/logo.svg` or `docs/assets/logo.svg` | SVG is crisp and portable on GitHub |
| PNG fallback | `docs/readme-assets/logo.png` | Use only when a platform needs PNG |
| README hero/preview | `docs/readme-assets/hero.png` | Use for screenshot composites, not as the only title |
| Social card | `docs/readme-assets/thumbnail/og.png` | Regenerate when the logo changes |

Recommended SVG size:

- Canvas: square `512x512`, compact `640x360`, or compact `760x360`.
- README display width: `180` to `320` for icon marks, up to `360` only for short-label marks.
- Keep text readable at `240px` display width.
- Use transparent or light-safe backgrounds unless the README design needs a contained badge.
- Keep a safe zone: at least 10% padding around all visible foreground elements.
- Avoid placing the project name, tagline, or badge row inside the SVG. Use README HTML/Markdown for those.

## GitHub-Safe Snippet

```html
<div align="center">
  <img src="./docs/readme-assets/logo.svg" alt="Project Name logo" width="240" />
  <h1>Project Name</h1>
  <p><strong>One concrete sentence about what the project does.</strong></p>
  <p>
    <a href="https://example.com">Demo</a>
    ·
    <a href="./docs">Docs</a>
    ·
    <a href="./CHANGELOG.md">Changelog</a>
  </p>
</div>
```

Use relative paths for repository assets. Do not use `file://` paths, local Windows paths, or temporary screenshot paths.

## Quality Checklist

- The logo is original and clearly different from any visual reference.
- The mark relates to the repository domain, not a generic decoration.
- The README still has a real `<h1>` for accessibility and GitHub navigation.
- The logo has useful `alt` text.
- The asset path exists in the repository.
- The logo renders on GitHub light mode and remains legible on dark mode.
- The full repository name is not embedded as long SVG text.
- No text or shape is clipped by the SVG edge.
- No foreground element overlaps another foreground element.
- The logo is a compact identity mark, not a wide banner that competes with the README title.
- Badges, links, and first proof image still fit naturally under the logo.
- Any thumbnail, Open Graph, or social preview assets are refreshed when needed.

## Prompt Pattern

```text
Design an original README top logo for this repository.
Use the project domain, existing screenshots, and README positioning.
Create a repo-owned SVG at docs/readme-assets/logo.svg.
Add it above the README h1 with GitHub-safe HTML.
Do not copy the reference image; use it only for layout inspiration.
Verify the asset path and alt text.
```

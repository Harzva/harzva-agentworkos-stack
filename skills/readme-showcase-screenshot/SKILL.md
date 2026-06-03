---
name: readme-showcase-screenshot
description: Generate polished README-ready screenshots, GIFs, videos, hero composites, and interactive HTML preview galleries for local web, mobile preview, desktop preview, packaged-app preview, and documentation projects. Use when Codex needs to update README visuals, capture UI states, record product demos, standardize docs screenshots, build preview galleries, or make a GitHub project presentation stronger.
---

# README Showcase Screenshot

Use this skill to turn a local project into a repeatable README showcase pipeline. The goal is not only to take screenshots, but to produce a curated visual set: static PNGs, short motion demos, a composed hero image, an HTML gallery, and an updated README block.

## Core Workflow

1. Inspect the target project:
   - Find `package.json`, `vite.config.*`, `next.config.*`, `preview.html`, `index.html`, existing README images, and previous screenshot scripts.
   - Identify whether the truth source is a web app, static HTML preview, app preview lab, desktop preview, or documentation site.
2. Create or update `showcase.config.json`:
   - Run `node <skill>/scripts/discover-project.mjs --write showcase.config.json` when no config exists.
   - Edit the generated route list so the README shows real product value, not every page.
3. Capture static states:
   - Run `node <skill>/scripts/capture-static.mjs --config showcase.config.json`.
   - Capture at least one desktop and one mobile viewport for app-like projects.
4. Capture motion only when it adds understanding:
   - Run `node <skill>/scripts/capture-motion.mjs --config showcase.config.json`.
   - Prefer one short 4-8 second README GIF and a longer WebM/MP4 linked from the gallery.
5. Build presentation assets:
   - Run `node <skill>/scripts/compose-hero.mjs --config showcase.config.json`.
   - Run `node <skill>/scripts/build-preview-gallery.mjs --config showcase.config.json`.
6. Update documentation:
   - Run `node <skill>/scripts/update-readme.mjs --config showcase.config.json`.
   - Keep the README first viewport focused: one hero, one compact proof row, and links to the gallery or video.
7. Verify:
   - Run `node <skill>/scripts/verify-showcase.mjs --config showcase.config.json`.
   - Confirm that generated images are not blank-looking, README paths exist, and large GIFs are not overused.

## Quality Bar

- Show the actual product, not a generic shell, unless the project itself is a preview shell.
- Use realistic UI states: loaded data, selected tabs, meaningful empty/error states, dark/light variants when relevant.
- Keep README weight controlled. Put the best GIF or hero in README; move large or numerous demos into `gallery.html`.
- Prefer stable screenshots. Disable animations for static captures unless the animation is the feature being demonstrated.
- Capture both desktop and mobile for responsive web apps. For mobile apps or APK previews, capture a phone viewport first.
- Treat `gallery.html` as the full visual archive and README as the curated front page.
- Preserve existing user README content outside the `<!-- showcase:start -->` and `<!-- showcase:end -->` block.
- For public repositories, make the visual set professional, beautiful, and universal: polished enough for first impressions, restrained enough for GitHub, and free of private paths, secrets, login-only states, or owner-specific assumptions.

## Script Map

- `scripts/discover-project.mjs`: infer a first `showcase.config.json` from the local project.
- `scripts/capture-static.mjs`: capture PNG screenshots from configured routes and states.
- `scripts/capture-motion.mjs`: record WebM videos and optionally convert to MP4/GIF when `ffmpeg` is available.
- `scripts/compose-hero.mjs`: render a GitHub-friendly hero image from captured assets.
- `scripts/build-preview-gallery.mjs`: generate a local `gallery.html` with screenshots and videos.
- `scripts/update-readme.mjs`: insert or replace the README showcase block.
- `scripts/verify-showcase.mjs`: validate manifest, assets, and README references.

## References

- Read `references/config-schema.md` before editing a complex `showcase.config.json`.
- Read `references/motion-recipes.md` for click, scroll, type, hover, theme toggle, and app-flow demos.
- Read `references/readme-patterns.md` when deciding what belongs in README versus the gallery.
- Read `references/troubleshooting.md` when Playwright, ports, auth pages, blank screenshots, or GIF conversion fail.

## Output Checklist

When using this skill, return:

- Config path and target project path.
- Generated asset paths: hero, static screenshots, motion assets, and gallery.
- README block status: inserted, replaced, or skipped.
- Verification command output summary.
- Any remaining manual checks, such as login state, device-only behavior, or release-hosted video upload.

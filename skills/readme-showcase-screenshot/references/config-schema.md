# Showcase Config Schema

Use `showcase.config.json` at the target project root. Generate a starter file with:

```bash
node path/to/readme-showcase-screenshot/scripts/discover-project.mjs --write showcase.config.json
```

## Top-level fields

| Field | Type | Purpose |
| --- | --- | --- |
| `projectName` | string | Display name used in hero and gallery. |
| `root` | string | Project root relative to the config file. Usually `"."`. |
| `type` | string | Informational: `vite`, `next`, `static-html`, `manual`, etc. |
| `installCommand` | string/null | Optional install command for docs. |
| `startCommand` | string/null | Command used when `baseUrl` is not already reachable. |
| `baseUrl` | string | HTTP URL or `file://` URL used as the capture base. |
| `outputDir` | string | Asset directory, default `docs/readme-assets`. |
| `readme` | string | README path, default `README.md`. |
| `viewports` | object | Named viewport map. |
| `screenshots` | array | Static PNG capture definitions. |
| `motions` | array | Video/GIF capture definitions. |
| `hero` | object | Hero image composition settings. |

## Screenshot item

```json
{
  "id": "desktop-home",
  "title": "Desktop home",
  "path": "/",
  "viewport": "desktop",
  "waitFor": "[data-ready]",
  "waitMs": 900,
  "fullPage": false,
  "selector": null,
  "steps": [
    { "click": "[data-tab='stats']" },
    { "wait": 500 }
  ]
}
```

Use `selector` for component screenshots. Use `steps` to put the UI into a meaningful state before capture.

## Motion item

```json
{
  "id": "hero-flow",
  "title": "Main product flow",
  "path": "/",
  "viewport": "desktop",
  "durationMs": 6000,
  "gifWidth": 960,
  "gifFps": 12,
  "steps": [
    { "wait": 1000 },
    { "click": "[data-demo-start]" },
    { "wait": 1600 },
    { "scroll": 520 },
    { "wait": 1200 }
  ]
}
```

Motion capture always produces WebM. It produces MP4 and GIF when `ffmpeg` is available.

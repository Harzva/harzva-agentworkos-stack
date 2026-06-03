# Motion Recipes

Use motion sparingly. A README should usually have one short GIF and a gallery link for everything else.

## Product flow

```json
{
  "id": "hero-flow",
  "path": "/",
  "viewport": "desktop",
  "durationMs": 6000,
  "steps": [
    { "wait": 800 },
    { "click": "[data-demo-start]" },
    { "wait": 1500 },
    { "scroll": 520 },
    { "wait": 1200 }
  ]
}
```

## Form or chat demo

```json
{
  "id": "chat-demo",
  "path": "/chat",
  "viewport": "desktop",
  "steps": [
    { "fill": "textarea", "value": "Summarize this repository" },
    { "press": "Enter" },
    { "wait": 2600 }
  ]
}
```

## Theme switch

```json
{
  "id": "theme-toggle",
  "path": "/",
  "viewport": "desktop",
  "steps": [
    { "wait": 800 },
    { "click": "[data-theme-toggle]" },
    { "wait": 1000 },
    { "click": "[data-theme-toggle]" },
    { "wait": 1000 }
  ]
}
```

## Mobile scroll

```json
{
  "id": "mobile-scroll",
  "path": "/",
  "viewport": "mobile",
  "gifWidth": 390,
  "steps": [
    { "wait": 700 },
    { "scroll": 620 },
    { "wait": 900 },
    { "scroll": 620 },
    { "wait": 900 }
  ]
}
```

Keep GIFs under 8-12 MB for README. Prefer MP4/WebM links for longer demos.

# Troubleshooting

## Playwright is missing

Run:

```bash
npm install
npx playwright install chromium
```

You can install dependencies in this skill repo or in the target project. The scripts use Node module resolution from the running script.

## Port already in use

If `baseUrl` is already reachable, the scripts reuse it and do not start a second process. If the wrong app is on that port, change `baseUrl` and `startCommand` together.

## Blank screenshots

Try:

- Add `waitFor` to a stable selector.
- Increase `waitMs`.
- Capture after UI setup `steps`.
- Use seeded/mock data for empty dashboards.
- Disable auth-only routes unless the session is prepared.

## Login-required pages

Prefer a public demo mode or seeded local state for README assets. If login is required, prepare browser storage with a project-specific script and load it in a custom capture script. Do not commit cookies, tokens, `.env`, or local storage dumps.

## GIF conversion missing

Install `ffmpeg`. Without it, `capture-motion.mjs` still keeps WebM output.

## README image paths break

Run:

```bash
node path/to/readme-showcase-screenshot/scripts/verify-showcase.mjs --config showcase.config.json
```

The verifier checks generated assets and README `docs/readme-assets` links.

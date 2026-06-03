#!/usr/bin/env node
import path from "node:path";
import {
  ensureDir,
  ensureServer,
  importPlaywright,
  loadConfig,
  parseArgs,
  readManifest,
  relPath,
  resolveViewport,
  stablePage,
  writeManifest
} from "./common.mjs";

const args = parseArgs();
const config = await loadConfig(args.config || "showcase.config.json");
await ensureDir(config.outputDir);

const stopServer = await ensureServer(config);
const { chromium } = await importPlaywright();
const browser = await chromium.launch({ headless: true });
const manifest = await readManifest(config.outputDir);
manifest.projectName = config.projectName;
manifest.config = relPath(config.rootDir, config.configPath);
manifest.static = [];

try {
  const selected = args.only ? new Set(String(args.only).split(",").map((item) => item.trim())) : null;
  for (const item of config.screenshots) {
    if (selected && !selected.has(item.id)) continue;
    const viewport = resolveViewport(config, item.viewport);
    const page = await browser.newPage({ viewport });
    await stablePage(page, config, item);

    const fileName = item.file || `${item.id}.png`;
    const outputPath = path.join(config.outputDir, fileName);
    await ensureDir(path.dirname(outputPath));

    const screenshotOptions = {
      path: outputPath,
      fullPage: Boolean(item.fullPage),
      animations: config.disableAnimations ? "disabled" : "allow",
      caret: "hide",
      scale: "css"
    };
    if (item.selector) {
      const element = page.locator(item.selector).first();
      await element.screenshot(screenshotOptions);
    } else {
      await page.screenshot(screenshotOptions);
    }

    await page.close();
    manifest.static.push({
      id: item.id,
      title: item.title || item.id,
      path: relPath(config.outputDir, outputPath),
      viewport: item.viewport || "desktop",
      width: viewport.width,
      height: viewport.height
    });
    console.log(`Captured ${item.id} -> ${outputPath}`);
  }

  await writeManifest(config.outputDir, manifest);
} finally {
  await browser.close();
  await stopServer();
}

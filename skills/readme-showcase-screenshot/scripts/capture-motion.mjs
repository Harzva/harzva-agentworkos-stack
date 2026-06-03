#!/usr/bin/env node
import fs from "node:fs/promises";
import path from "node:path";
import {
  applySteps,
  copyFileEnsured,
  ensureDir,
  ensureServer,
  hasCommand,
  importPlaywright,
  itemUrl,
  loadConfig,
  parseArgs,
  readManifest,
  relPath,
  resolveViewport,
  runCommand,
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
manifest.motion = [];

try {
  const selected = args.only ? new Set(String(args.only).split(",").map((item) => item.trim())) : null;
  for (const item of config.motions) {
    if (selected && !selected.has(item.id)) continue;
    const viewport = resolveViewport(config, item.viewport);
    const tempVideoDir = path.join(config.outputDir, ".video-temp", item.id);
    await ensureDir(tempVideoDir);

    const context = await browser.newContext({
      viewport,
      recordVideo: { dir: tempVideoDir, size: { width: viewport.width, height: viewport.height } }
    });
    const page = await context.newPage();
    await page.goto(itemUrl(config, item), { waitUntil: item.waitUntil || "domcontentloaded", timeout: config.timeoutMs });
    if (item.waitFor) await page.waitForSelector(item.waitFor, { timeout: config.timeoutMs });
    await page.waitForTimeout(Number(item.initialWaitMs ?? config.waitMs));
    await applySteps(page, item.steps || []);
    if (item.durationMs) await page.waitForTimeout(Number(item.durationMs));

    const video = page.video();
    await page.close();
    await context.close();

    const recordedPath = await video.path();
    const webmPath = path.join(config.outputDir, item.file || `${item.id}.webm`);
    await copyFileEnsured(recordedPath, webmPath);

    const entry = {
      id: item.id,
      title: item.title || item.id,
      webm: relPath(config.outputDir, webmPath),
      viewport: item.viewport || "desktop",
      width: viewport.width,
      height: viewport.height
    };

    if (await hasCommand("ffmpeg")) {
      const mp4Path = path.join(config.outputDir, `${item.id}.mp4`);
      await runCommand("ffmpeg", ["-y", "-i", webmPath, "-movflags", "faststart", "-pix_fmt", "yuv420p", mp4Path]);
      entry.mp4 = relPath(config.outputDir, mp4Path);

      if (item.gif !== false) {
        const gifPath = path.join(config.outputDir, `${item.id}.gif`);
        const palettePath = path.join(config.outputDir, `${item.id}.palette.png`);
        const fps = String(item.gifFps || 12);
        const scale = String(item.gifWidth || 960);
        await runCommand("ffmpeg", [
          "-y",
          "-i",
          webmPath,
          "-vf",
          `fps=${fps},scale=${scale}:-1:flags=lanczos,palettegen`,
          palettePath
        ]);
        await runCommand("ffmpeg", [
          "-y",
          "-i",
          webmPath,
          "-i",
          palettePath,
          "-lavfi",
          `fps=${fps},scale=${scale}:-1:flags=lanczos[x];[x][1:v]paletteuse`,
          gifPath
        ]);
        await fs.rm(palettePath, { force: true });
        entry.gif = relPath(config.outputDir, gifPath);
      }
    } else {
      entry.note = "ffmpeg not found; kept WebM only.";
    }

    manifest.motion.push(entry);
    console.log(`Recorded ${item.id} -> ${webmPath}`);
  }

  await writeManifest(config.outputDir, manifest);
} finally {
  await browser.close();
  await stopServer();
}

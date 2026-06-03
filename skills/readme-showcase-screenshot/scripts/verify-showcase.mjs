#!/usr/bin/env node
import { existsSync } from "node:fs";
import fs from "node:fs/promises";
import path from "node:path";
import { fileSize, loadConfig, parseArgs, readManifest } from "./common.mjs";

const args = parseArgs();
const config = await loadConfig(args.config || "showcase.config.json");
const manifest = await readManifest(config.outputDir);
const errors = [];
const warnings = [];

for (const item of manifest.static || []) {
  await requireAsset(path.join(config.outputDir, item.path), 1024, `static screenshot ${item.id}`);
}
for (const item of manifest.motion || []) {
  if (item.webm) await requireAsset(path.join(config.outputDir, item.webm), 1024, `motion webm ${item.id}`);
  if (item.mp4) await requireAsset(path.join(config.outputDir, item.mp4), 1024, `motion mp4 ${item.id}`);
  if (item.gif) {
    const gifPath = path.join(config.outputDir, item.gif);
    await requireAsset(gifPath, 1024, `motion gif ${item.id}`);
    const size = await fileSize(gifPath);
    if (size > 12 * 1024 * 1024) warnings.push(`Large README GIF candidate: ${item.gif} (${formatBytes(size)})`);
  }
}
if (manifest.hero?.path) await requireAsset(path.join(config.outputDir, manifest.hero.path), 1024, "hero image");
if (manifest.gallery?.path) await requireAsset(path.join(config.outputDir, manifest.gallery.path), 512, "gallery html");

if (existsSync(config.readmePath)) {
  const readme = await fs.readFile(config.readmePath, "utf8");
  if (!readme.includes("<!-- showcase:start -->") || !readme.includes("<!-- showcase:end -->")) {
    warnings.push("README does not contain a showcase marker block.");
  }
  const refs = [...readme.matchAll(/(?:src|href)="([^"]*docs\/readme-assets\/[^"]+)"/g)].map((match) => match[1]);
  for (const ref of refs) {
    const absolute = path.resolve(path.dirname(config.readmePath), ref);
    if (!existsSync(absolute)) errors.push(`README references missing asset: ${ref}`);
  }
} else {
  warnings.push(`README not found: ${config.readmePath}`);
}

if (errors.length) {
  console.error("Showcase verification failed:");
  for (const error of errors) console.error(`- ${error}`);
  process.exit(1);
}

console.log("Showcase verification passed.");
if (warnings.length) {
  console.log("Warnings:");
  for (const warning of warnings) console.log(`- ${warning}`);
}

async function requireAsset(filePath, minBytes, label) {
  if (!existsSync(filePath)) {
    errors.push(`Missing ${label}: ${filePath}`);
    return;
  }
  const size = await fileSize(filePath);
  if (size < minBytes) errors.push(`Suspiciously small ${label}: ${filePath} (${size} bytes)`);
}

function formatBytes(bytes) {
  return `${(bytes / 1024 / 1024).toFixed(1)} MB`;
}

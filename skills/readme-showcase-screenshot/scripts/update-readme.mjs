#!/usr/bin/env node
import { existsSync } from "node:fs";
import fs from "node:fs/promises";
import path from "node:path";
import { loadConfig, parseArgs, readManifest, relPath } from "./common.mjs";

const args = parseArgs();
const config = await loadConfig(args.config || "showcase.config.json");
const manifest = await readManifest(config.outputDir);
const readmeDir = path.dirname(config.readmePath);
let readme = existsSync(config.readmePath)
  ? await fs.readFile(config.readmePath, "utf8")
  : `# ${config.projectName || path.basename(config.rootDir)}\n\n`;

const start = "<!-- showcase:start -->";
const end = "<!-- showcase:end -->";
const block = buildBlock(config, manifest, readmeDir);
const pattern = new RegExp(`${escapeRegExp(start)}[\\s\\S]*?${escapeRegExp(end)}`);

if (pattern.test(readme)) {
  readme = readme.replace(pattern, block);
} else {
  const headingMatch = readme.match(/^# .+\n+/);
  if (headingMatch) {
    readme = readme.replace(headingMatch[0], `${headingMatch[0]}${block}\n\n`);
  } else {
    readme = `${block}\n\n${readme}`;
  }
}

await fs.writeFile(config.readmePath, readme, "utf8");
console.log(`Updated README showcase block -> ${config.readmePath}`);

function buildBlock(config, manifest, readmeDir) {
  const hero = manifest.hero ? relPath(readmeDir, path.join(config.outputDir, manifest.hero.path)) : null;
  const firstMotion = (manifest.motion || [])[0];
  const motionGif = firstMotion?.gif ? relPath(readmeDir, path.join(config.outputDir, firstMotion.gif)) : null;
  const mainImage = motionGif || hero;
  const gallery = manifest.gallery ? relPath(readmeDir, path.join(config.outputDir, manifest.gallery.path)) : null;
  const video = firstMotion?.mp4 || firstMotion?.webm;
  const videoPath = video ? relPath(readmeDir, path.join(config.outputDir, video)) : null;
  const shots = (manifest.static || []).slice(0, 4);
  const rows = [];
  for (let index = 0; index < shots.length; index += 2) {
    const left = shots[index];
    const right = shots[index + 1];
    rows.push(`| ${cell(left)} | ${cell(right)} |`);
  }

  return `${start}
<p align="center">
  ${mainImage ? `<img src="${mainImage}" alt="${escapeHtml(config.projectName || "Project")} preview" width="900" />` : "<strong>Preview assets are not generated yet.</strong>"}
</p>

<p align="center">
  ${gallery ? `<a href="${gallery}">Preview Gallery</a>` : "Preview Gallery"}
  ${videoPath ? ` · <a href="${videoPath}">Demo Video</a>` : ""}
</p>

${shots.length ? `| ${escapePipe(shots[0]?.title || "Preview")} | ${escapePipe(shots[1]?.title || "Preview")} |
| --- | --- |
${rows.join("\n")}` : "_Run the showcase capture scripts to generate README screenshots._"}
${end}`;

  function cell(item) {
    if (!item) return "";
    const imagePath = relPath(readmeDir, path.join(config.outputDir, item.path));
    return `<img src="${imagePath}" alt="${escapeHtml(item.title)}" width="420" />`;
  }
}

function escapeRegExp(value) {
  return value.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
}

function escapeHtml(value) {
  return String(value || "")
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;");
}

function escapePipe(value) {
  return String(value || "").replace(/\|/g, "\\|");
}

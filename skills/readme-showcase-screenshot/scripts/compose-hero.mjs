#!/usr/bin/env node
import fs from "node:fs/promises";
import path from "node:path";
import {
  ensureDir,
  fileUrl,
  importPlaywright,
  loadConfig,
  parseArgs,
  readManifest,
  relPath,
  writeManifest
} from "./common.mjs";

const args = parseArgs();
const config = await loadConfig(args.config || "showcase.config.json");
const manifest = await readManifest(config.outputDir);
const { chromium } = await importPlaywright();

await ensureDir(config.outputDir);
const heroPath = path.join(config.outputDir, config.hero?.file || "hero.png");
const heroItems = selectHeroItems(config, manifest);
const html = buildHeroHtml(config, heroItems);
const tempPath = path.join(config.outputDir, ".showcase-hero.html");
await fs.writeFile(tempPath, html, "utf8");

const browser = await chromium.launch({ headless: true });
try {
  const page = await browser.newPage({ viewport: { width: 1400, height: 900 }, deviceScaleFactor: 1 });
  await page.goto(fileUrl(tempPath), { waitUntil: "load" });
  await page.screenshot({ path: heroPath, fullPage: false, animations: "disabled" });
} finally {
  await browser.close();
  await fs.rm(tempPath, { force: true });
}

manifest.hero = {
  path: relPath(config.outputDir, heroPath),
  title: config.hero?.title || config.projectName || "Project preview"
};
await writeManifest(config.outputDir, manifest);
console.log(`Composed hero -> ${heroPath}`);

function selectHeroItems(config, manifest) {
  const requested = config.hero?.images || [];
  const byId = new Map((manifest.static || []).map((item) => [item.id, item]));
  const items = requested.map((id) => byId.get(id)).filter(Boolean);
  return items.length ? items : (manifest.static || []).slice(0, 3);
}

function buildHeroHtml(config, items) {
  const cards = items
    .map((item, index) => {
      const absolute = path.join(config.outputDir, item.path);
      const phone = String(item.viewport).includes("mobile");
      return `<figure class="${phone ? "phone" : "desktop"}" style="--i:${index}">
  <div class="chrome"><span></span><span></span><span></span></div>
  <img src="${fileUrl(absolute)}" alt="${escapeHtml(item.title)}" />
  <figcaption>${escapeHtml(item.title)}</figcaption>
</figure>`;
    })
    .join("\n");

  return `<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width,initial-scale=1" />
<style>
*{box-sizing:border-box}body{margin:0;font-family:Inter,ui-sans-serif,system-ui,-apple-system,BlinkMacSystemFont,"Segoe UI",sans-serif;background:#0f172a;color:#f8fafc}.stage{width:1400px;height:900px;position:relative;overflow:hidden;background:radial-gradient(circle at 16% 12%,#38bdf855,transparent 25%),radial-gradient(circle at 86% 20%,#f9731650,transparent 28%),linear-gradient(135deg,#101827 0%,#111827 48%,#172554 100%);padding:68px 76px}.kicker{font-size:17px;text-transform:uppercase;letter-spacing:.18em;color:#93c5fd;font-weight:760}.title{margin:13px 0 0;font-size:78px;line-height:.97;letter-spacing:0;font-weight:850;max-width:830px}.subtitle{margin:24px 0 0;color:#cbd5e1;font-size:26px;line-height:1.35;max-width:760px}.grid{position:absolute;inset:auto 62px 66px 62px;display:flex;align-items:flex-end;justify-content:flex-end;gap:26px}.desktop,.phone{margin:0;background:#f8fafc;border:1px solid #ffffff66;box-shadow:0 28px 80px #0008;overflow:hidden}.desktop{width:770px;height:500px;border-radius:18px}.phone{width:245px;height:530px;border-radius:34px;border-width:8px}.chrome{height:34px;background:#e2e8f0;display:flex;align-items:center;gap:8px;padding-left:15px}.phone .chrome{display:none}.chrome span{width:10px;height:10px;border-radius:50%;background:#94a3b8}.desktop img,.phone img{width:100%;height:calc(100% - 34px);object-fit:cover;display:block}.phone img{height:100%}figcaption{position:absolute;opacity:0;pointer-events:none}.mark{position:absolute;right:78px;top:70px;font-size:18px;color:#bfdbfe;border:1px solid #ffffff33;border-radius:999px;padding:10px 16px;background:#ffffff12}.footer{position:absolute;left:78px;bottom:64px;color:#dbeafe;font-size:18px}
</style>
</head>
<body>
<main class="stage">
  <div class="mark">README showcase pipeline</div>
  <div class="kicker">Preview assets</div>
  <h1 class="title">${escapeHtml(config.hero?.title || config.projectName || "Project showcase")}</h1>
  <p class="subtitle">${escapeHtml(config.hero?.subtitle || "Screenshots, motion demos, and gallery assets generated from the local project.")}</p>
  <section class="grid">${cards}</section>
  <div class="footer">PNG · GIF · Video · HTML Gallery · README Block</div>
</main>
</body>
</html>`;
}

function escapeHtml(value) {
  return String(value || "")
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;");
}

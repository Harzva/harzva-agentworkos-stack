import { access, readFile } from "node:fs/promises";
import path from "node:path";

const file = process.argv[2];
if (!file) {
  console.error("Usage: node scripts/verify-preview.mjs <preview.html>");
  process.exit(2);
}

const target = path.resolve(process.cwd(), file);
const html = await readFile(target, "utf8");
const failures = [];

for (const marker of ["data-app-preview-lab", "preview-config", "data-mode", "data-theme"]) {
  if (!html.includes(marker)) failures.push(`Missing marker: ${marker}`);
}

const scriptBlocks = [...html.matchAll(/<script(?![^>]*type=["']application\/json["'])[^>]*>([\s\S]*?)<\/script>/gi)].map((match) => match[1]);
for (const [index, script] of scriptBlocks.entries()) {
  try {
    new Function(script);
  } catch (error) {
    failures.push(`Script ${index + 1} has syntax error: ${error.message}`);
  }
}

const linked = [...html.matchAll(/\b(?:src|href)=["'](\.\/[^"']+)["']/g)].map((match) => match[1].split("#")[0].split("?")[0]);
for (const link of linked) {
  if (!link || link.endsWith(".html") && link.includes("__")) continue;
  const linkedPath = path.resolve(path.dirname(target), link);
  try {
    await access(linkedPath);
  } catch {
    failures.push(`Local link does not exist: ${link}`);
  }
}

if (failures.length) {
  console.error(failures.join("\n"));
  process.exit(1);
}

console.log(`Preview OK: ${target}`);

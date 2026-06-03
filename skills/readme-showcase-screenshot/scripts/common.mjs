import { spawn } from "node:child_process";
import { existsSync } from "node:fs";
import fs from "node:fs/promises";
import os from "node:os";
import path from "node:path";
import { pathToFileURL } from "node:url";

export function parseArgs(argv = process.argv.slice(2)) {
  const args = {};
  for (let index = 0; index < argv.length; index += 1) {
    const token = argv[index];
    if (!token.startsWith("--")) continue;
    const key = token.slice(2);
    const next = argv[index + 1];
    if (!next || next.startsWith("--")) {
      args[key] = true;
    } else {
      args[key] = next;
      index += 1;
    }
  }
  return args;
}

export function slug(value) {
  return String(value || "item")
    .trim()
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/^-+|-+$/g, "")
    .slice(0, 80) || "item";
}

export async function readJson(filePath, fallback = null) {
  try {
    const text = await fs.readFile(filePath, "utf8");
    return JSON.parse(text.replace(/^\uFEFF/, ""));
  } catch (error) {
    if (fallback !== null && error.code === "ENOENT") return fallback;
    throw error;
  }
}

export async function writeJson(filePath, data) {
  await fs.mkdir(path.dirname(filePath), { recursive: true });
  await fs.writeFile(filePath, `${JSON.stringify(data, null, 2)}\n`, "utf8");
}

export async function ensureDir(dirPath) {
  await fs.mkdir(dirPath, { recursive: true });
}

export function relPath(fromDir, toPath) {
  return path.relative(fromDir, toPath).replace(/\\/g, "/");
}

export async function loadConfig(configPath = "showcase.config.json") {
  const absoluteConfig = path.resolve(configPath);
  const config = await readJson(absoluteConfig);
  const rootDir = path.resolve(path.dirname(absoluteConfig), config.root || ".");
  const outputDir = path.resolve(rootDir, config.outputDir || "docs/readme-assets");
  const readmePath = path.resolve(rootDir, config.readme || "README.md");
  const viewports = normalizeViewports(config.viewports);
  return {
    ...config,
    configPath: absoluteConfig,
    rootDir,
    outputDir,
    readmePath,
    viewports,
    screenshots: config.screenshots || config.shots || [],
    motions: config.motions || [],
    waitMs: Number(config.waitMs ?? 800),
    timeoutMs: Number(config.timeoutMs ?? 60000),
    disableAnimations: config.disableAnimations !== false
  };
}

function normalizeViewports(viewports = {}) {
  if (Array.isArray(viewports)) {
    return Object.fromEntries(viewports.map((item) => [item.id || item.name, item]));
  }
  return {
    desktop: { width: 1440, height: 1000, deviceScaleFactor: 1 },
    mobile: { width: 390, height: 844, deviceScaleFactor: 2, isMobile: true },
    ...viewports
  };
}

export function resolveViewport(config, value = "desktop") {
  if (typeof value === "object") return value;
  return config.viewports[value] || config.viewports.desktop;
}

export function itemUrl(config, item) {
  if (item.url) return item.url;
  const baseUrl = config.baseUrl;
  if (!baseUrl) throw new Error("Config requires baseUrl or per-item url.");
  if (baseUrl.startsWith("file:")) return baseUrl;
  return new URL(item.path || "/", baseUrl.endsWith("/") ? baseUrl : `${baseUrl}/`).href;
}

export async function importPlaywright() {
  try {
    return await import("playwright");
  } catch {
    throw new Error(
      "Playwright is required for capture scripts. Run `npm install` in the skill repo, or install `playwright` in the target project."
    );
  }
}

export async function ensureServer(config) {
  if (!config.baseUrl || config.baseUrl.startsWith("file:")) {
    return async () => {};
  }
  if (await isReachable(config.baseUrl)) {
    return async () => {};
  }
  if (!config.startCommand) {
    throw new Error(`Base URL is not reachable and no startCommand is configured: ${config.baseUrl}`);
  }

  const child = spawn(config.startCommand, {
    cwd: config.rootDir,
    shell: true,
    stdio: ["ignore", "pipe", "pipe"],
    env: { ...process.env, BROWSER: "none" }
  });

  let logs = "";
  child.stdout.on("data", (chunk) => {
    logs += chunk.toString();
  });
  child.stderr.on("data", (chunk) => {
    logs += chunk.toString();
  });

  try {
    await waitForUrl(config.baseUrl, config.timeoutMs);
  } catch (error) {
    child.kill();
    throw new Error(`${error.message}\n\nServer logs:\n${logs.slice(-4000)}`);
  }

  return async () => {
    if (!child.killed) child.kill();
  };
}

async function isReachable(url) {
  try {
    const response = await fetch(url, { method: "GET" });
    return response.status < 500;
  } catch {
    return false;
  }
}

async function waitForUrl(url, timeoutMs) {
  const start = Date.now();
  while (Date.now() - start < timeoutMs) {
    if (await isReachable(url)) return;
    await new Promise((resolve) => setTimeout(resolve, 500));
  }
  throw new Error(`Timed out waiting for ${url}`);
}

export async function applySteps(page, steps = []) {
  for (const step of steps) {
    if (step.wait) await page.waitForTimeout(Number(step.wait));
    if (step.click) await page.click(step.click);
    if (step.hover) await page.hover(step.hover);
    if (step.fill) await page.fill(step.fill, step.value ?? "");
    if (step.type) await page.locator(step.type).type(step.value ?? "", { delay: Number(step.delay ?? 20) });
    if (step.press) await page.keyboard.press(step.press);
    if (step.scroll !== undefined) {
      const amount = Number(step.scroll);
      await page.mouse.wheel(0, amount);
    }
    if (step.evaluate) await page.evaluate(step.evaluate);
  }
}

export async function stablePage(page, config, item) {
  const url = itemUrl(config, item);
  await page.goto(url, { waitUntil: item.waitUntil || "domcontentloaded", timeout: config.timeoutMs });
  if (item.waitFor) await page.waitForSelector(item.waitFor, { timeout: config.timeoutMs });
  if (item.steps) await applySteps(page, item.steps);
  if (config.disableAnimations && item.disableAnimations !== false) {
    await page.addStyleTag({
      content:
        "*,*::before,*::after{transition-duration:0.001s!important;animation-duration:0.001s!important;animation-delay:0s!important;scroll-behavior:auto!important}"
    }).catch(() => {});
  }
  await page.waitForTimeout(Number(item.waitMs ?? config.waitMs));
}

export async function readManifest(outputDir) {
  return readJson(path.join(outputDir, "manifest.json"), {
    generatedAt: null,
    static: [],
    motion: [],
    hero: null,
    gallery: null
  });
}

export async function writeManifest(outputDir, manifest) {
  manifest.generatedAt = new Date().toISOString();
  await writeJson(path.join(outputDir, "manifest.json"), manifest);
}

export async function runCommand(command, args, options = {}) {
  return new Promise((resolve, reject) => {
    const child = spawn(command, args, { stdio: "pipe", ...options });
    let output = "";
    child.stdout.on("data", (chunk) => {
      output += chunk.toString();
    });
    child.stderr.on("data", (chunk) => {
      output += chunk.toString();
    });
    child.on("error", reject);
    child.on("close", (code) => {
      if (code === 0) resolve(output);
      else reject(new Error(`${command} exited with ${code}\n${output}`));
    });
  });
}

export async function hasCommand(command) {
  const checker = os.platform() === "win32" ? "where" : "which";
  try {
    await runCommand(checker, [command]);
    return true;
  } catch {
    return false;
  }
}

export async function copyFileEnsured(source, destination) {
  await ensureDir(path.dirname(destination));
  await fs.copyFile(source, destination);
}

export function fileUrl(filePath) {
  return pathToFileURL(filePath).href;
}

export async function fileSize(filePath) {
  const stat = await fs.stat(filePath);
  return stat.size;
}

export function existingPath(...parts) {
  const candidate = path.join(...parts);
  return existsSync(candidate) ? candidate : null;
}

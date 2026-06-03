#!/usr/bin/env node
import { existsSync } from "node:fs";
import fs from "node:fs/promises";
import path from "node:path";
import { pathToFileURL } from "node:url";
import { parseArgs, writeJson } from "./common.mjs";

const args = parseArgs();
const rootDir = path.resolve(args.root || process.cwd());
const config = await discover(rootDir);

if (args.write) {
  const destination = path.resolve(rootDir, args.write === true ? "showcase.config.json" : args.write);
  await writeJson(destination, config);
  console.log(`Wrote ${destination}`);
} else {
  console.log(JSON.stringify(config, null, 2));
}

async function discover(root) {
  const packagePath = path.join(root, "package.json");
  const previewHtml = firstExisting(root, ["preview.html", "docs/preview.html", "public/preview.html", "index.html"]);
  const readme = existsSync(path.join(root, "README.md")) ? "README.md" : "README.md";

  if (existsSync(packagePath)) {
    const pkg = JSON.parse(await fs.readFile(packagePath, "utf8"));
    const framework = detectFramework(root, pkg);
    const packageManager = detectPackageManager(root);
    const devScript = chooseScript(pkg.scripts || {});
    return {
      projectName: pkg.displayName || pkg.name || path.basename(root),
      root: ".",
      type: framework,
      packageManager,
      installCommand: `${packageManager} install`,
      startCommand: devScript ? runCommand(packageManager, devScript, framework) : null,
      baseUrl: defaultBaseUrl(framework),
      outputDir: "docs/readme-assets",
      readme,
      waitMs: 900,
      timeoutMs: 60000,
      disableAnimations: true,
      viewports: {
        desktop: { width: 1440, height: 1000, deviceScaleFactor: 1 },
        mobile: { width: 390, height: 844, deviceScaleFactor: 2, isMobile: true }
      },
      screenshots: [
        { id: "desktop-home", title: "Desktop home", path: "/", viewport: "desktop", fullPage: false },
        { id: "mobile-home", title: "Mobile home", path: "/", viewport: "mobile", fullPage: false }
      ],
      motions: [
        {
          id: "hero-flow",
          title: "Main product flow",
          path: "/",
          viewport: "desktop",
          durationMs: 6000,
          steps: [{ wait: 1000 }, { scroll: 520 }, { wait: 1200 }, { scroll: -260 }, { wait: 1200 }]
        }
      ],
      hero: {
        title: pkg.displayName || pkg.name || path.basename(root),
        subtitle: "README-ready preview captured from the live local project.",
        images: ["desktop-home", "mobile-home"]
      }
    };
  }

  if (previewHtml) {
    const absolute = path.join(root, previewHtml);
    return {
      projectName: path.basename(root),
      root: ".",
      type: "static-html",
      startCommand: null,
      baseUrl: pathToFileURL(absolute).href,
      outputDir: "docs/readme-assets",
      readme,
      waitMs: 900,
      timeoutMs: 30000,
      disableAnimations: true,
      viewports: {
        desktop: { width: 1440, height: 1000, deviceScaleFactor: 1 },
        mobile: { width: 390, height: 844, deviceScaleFactor: 2, isMobile: true }
      },
      screenshots: [
        { id: "desktop-preview", title: "Desktop preview", viewport: "desktop", fullPage: false },
        { id: "mobile-preview", title: "Mobile preview", viewport: "mobile", fullPage: false }
      ],
      motions: [
        {
          id: "preview-flow",
          title: "Preview flow",
          viewport: "desktop",
          durationMs: 5000,
          steps: [{ wait: 900 }, { scroll: 460 }, { wait: 1200 }, { scroll: -300 }, { wait: 1000 }]
        }
      ],
      hero: {
        title: path.basename(root),
        subtitle: "Static preview captured for README presentation.",
        images: ["desktop-preview", "mobile-preview"]
      }
    };
  }

  return {
    projectName: path.basename(root),
    root: ".",
    type: "manual",
    startCommand: null,
    baseUrl: "http://127.0.0.1:3000",
    outputDir: "docs/readme-assets",
    readme,
    screenshots: [{ id: "home", title: "Home", path: "/", viewport: "desktop" }],
    motions: [],
    hero: { title: path.basename(root), subtitle: "Add routes and states before capture.", images: ["home"] }
  };
}

function firstExisting(root, candidates) {
  return candidates.find((candidate) => existsSync(path.join(root, candidate))) || null;
}

function detectPackageManager(root) {
  if (existsSync(path.join(root, "pnpm-lock.yaml"))) return "pnpm";
  if (existsSync(path.join(root, "yarn.lock"))) return "yarn";
  return "npm";
}

function detectFramework(root, pkg) {
  const deps = { ...(pkg.dependencies || {}), ...(pkg.devDependencies || {}) };
  if (existsSync(path.join(root, "next.config.js")) || existsSync(path.join(root, "next.config.mjs")) || deps.next) return "next";
  if (existsSync(path.join(root, "astro.config.mjs")) || deps.astro) return "astro";
  if (existsSync(path.join(root, "vite.config.ts")) || existsSync(path.join(root, "vite.config.js")) || deps.vite) return "vite";
  return "node-web";
}

function chooseScript(scripts) {
  if (scripts.dev) return "dev";
  if (scripts.preview) return "preview";
  if (scripts.start) return "start";
  return null;
}

function defaultBaseUrl(framework) {
  if (framework === "vite") return "http://127.0.0.1:5173";
  if (framework === "astro") return "http://127.0.0.1:4321";
  return "http://127.0.0.1:3000";
}

function runCommand(packageManager, script, framework) {
  const hostSuffix = framework === "vite" || framework === "astro" ? " -- --host 127.0.0.1" : "";
  if (packageManager === "npm") return `npm run ${script}${hostSuffix}`;
  return `${packageManager} run ${script}${hostSuffix}`;
}

import { readFile, writeFile, mkdir } from "node:fs/promises";
import path from "node:path";
import { fileURLToPath } from "node:url";

const here = path.dirname(fileURLToPath(import.meta.url));
const root = path.resolve(here, "..");

function parseArgs(argv) {
  const args = {};
  for (let i = 0; i < argv.length; i += 1) {
    const part = argv[i];
    if (!part.startsWith("--")) continue;
    const key = part.slice(2);
    const next = argv[i + 1];
    if (!next || next.startsWith("--")) {
      args[key] = "true";
    } else {
      args[key] = next;
      i += 1;
    }
  }
  return args;
}

const args = parseArgs(process.argv.slice(2));
const out = path.resolve(process.cwd(), args.out || "mobile-preview.html");
const templatePath = path.resolve(root, "assets", "templates", "mobile-preview.html");

const config = {
  appName: args.name || "DemoApp",
  tagline: args.tagline || "Package preview without reinstall loops",
  exactUrl: args.app || "./app.html",
  defaultMode: args.mode || "webview",
  defaultTheme: args.theme || "light",
  defaultLanguage: args.lang || "en",
  modes: (args.modes || "webview,android,ios,desktop").split(",").map((item) => item.trim()).filter(Boolean),
  themes: (args.themes || "light,dark,warm").split(",").map((item) => item.trim()).filter(Boolean),
  languages: (args.languages || "en,zh").split(",").map((item) => item.trim()).filter(Boolean),
  tabs: (args.tabs || "home,releases,downloads,security").split(",").map((item) => item.trim()).filter(Boolean),
  metrics: [
    ["3", "Platforms"],
    ["4", "States"],
    ["1", "Exact source"]
  ],
  cards: [
    {
      title: "Release artifact",
      text: "Preview installer, package, or release metadata before rebuilding.",
      tags: ["apk", "ipa", "exe"]
    },
    {
      title: "Safety surface",
      text: "Show permissions, hashes, signatures, upstream links, and install boundaries.",
      tags: ["SHA256", "signature"]
    },
    {
      title: "Native rehearsal",
      text: "Check theme, language, density, navigation, and empty states quickly.",
      tags: ["Android", "iOS"]
    }
  ]
};

const template = await readFile(templatePath, "utf8");
const html = template.replace("__APP_PREVIEW_CONFIG__", JSON.stringify(config, null, 2));
await mkdir(path.dirname(out), { recursive: true });
await writeFile(out, html, "utf8");
console.log(`Created ${out}`);

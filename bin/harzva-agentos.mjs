#!/usr/bin/env node
import { spawnSync } from 'node:child_process';
import { dirname, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';
import process from 'node:process';

const __dirname = dirname(fileURLToPath(import.meta.url));
const root = resolve(__dirname, '..');
const args = process.argv.slice(2);

if (args.includes('-h') || args.includes('--help')) {
  console.log(`Usage: harzva-agentos [--profile linux-dev] [--target all] [--apply] [--skip-aw-install]\n\nExamples:\n  npx github:Harzva/harzva-agentworkos-stack --profile linux-dev --target all\n  npx github:Harzva/harzva-agentworkos-stack --profile linux-dev --target all --apply\n\nDefaults:\n  profile: linux-dev on Unix-like systems, windows-desktop on Windows\n  target: all\n  mode: dry-run unless --apply is present`);
  process.exit(0);
}

const hasProfile = args.includes('--profile');
const effectiveArgs = [...args];
if (!hasProfile) {
  effectiveArgs.unshift(process.platform === 'win32' ? 'windows-desktop' : 'linux-dev');
  effectiveArgs.unshift('--profile');
}

let command;
let commandArgs;

if (process.platform === 'win32') {
  const psArgs = ['-ExecutionPolicy', 'Bypass', '-File', resolve(root, 'install.ps1')];
  for (let index = 0; index < effectiveArgs.length; index += 1) {
    const arg = effectiveArgs[index];
    if (arg === '--profile') {
      psArgs.push('-Profile', effectiveArgs[++index]);
    } else if (arg === '--target') {
      psArgs.push('-Target', effectiveArgs[++index]);
    } else if (arg === '--apply') {
      psArgs.push('-Apply');
    } else if (arg === '--skip-aw-install') {
      console.warn('--skip-aw-install is only supported by install.sh; ignored on Windows');
    } else {
      console.error(`unknown argument: ${arg}`);
      process.exit(2);
    }
  }
  command = 'pwsh';
  commandArgs = psArgs;
} else {
  command = 'bash';
  commandArgs = [resolve(root, 'install.sh'), ...effectiveArgs];
}

const result = spawnSync(command, commandArgs, {
  cwd: root,
  stdio: 'inherit',
  env: process.env,
});

if (result.error) {
  console.error(result.error.message);
  process.exit(1);
}

process.exit(result.status ?? 1);

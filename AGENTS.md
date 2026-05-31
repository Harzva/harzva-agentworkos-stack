# Harzva AgentWorkOS Stack Rules

This repository is the public safe-core environment declaration for Harzva AgentOS setup.

## Boundaries

- `AgentWorkOS` is the generic package manager and CLI.
- `harzva-agentworkos-stack` is the Harzva environment declaration.
- Codex and Claude runtime directories are generated projections.
- Private credentials and raw memory stores do not belong in this public repository.

## Safety

Before publishing changes, check that no tracked file contains tokens, cookies, `.env` values, credential dumps, raw chat logs, or private local paths.

Use `agentworkos.local.toml` for machine-specific additions. Do not commit it.

## Operating rule

A stack update is complete only when the manifest, lockfile, local Git state, remote GitHub repo, and runtime dry-run are consistent.

# AgentWorkOS Extraction

The Windows silky patch set is organized as seven AgentWorkOS layers.

| Layer | Extraction | Repository asset |
| --- | --- | --- |
| Agent | A role that inventories Windows workbench clutter and release uncertainty | [`patches/agents/windows-silky-inventory-agent.md`](../patches/agents/windows-silky-inventory-agent.md) |
| Memory | Smoothness is lost when evidence, artifact cleanup, and release gates stay manual | [`docs/windows-silky-principles.md`](./windows-silky-principles.md) |
| Skill | A reusable Codex workflow for auditing and patching Windows workbench friction | [`patches/skills/make-windows-silky/SKILL.md`](../patches/skills/make-windows-silky/SKILL.md) |
| MCP/tool | PowerShell scripts for audit, evidence manifest, encoding gate, and release preflight | [`scripts/`](../scripts) |
| Workflow | Weekly workbench reset and release preflight | [`sops/weekly-workbench-reset.md`](../sops/weekly-workbench-reset.md) |
| Rule | No release artifact without proof; no repeated workflow without an asset | [`patches/rules/AGENTS.windows-silky.md`](../patches/rules/AGENTS.windows-silky.md) |
| Hook | Future candidate: run audit/preflight before publishing or keeping a new release artifact | [`checklists/windows-silky-preflight.md`](../checklists/windows-silky-preflight.md) |

## One-Sentence Memory

Windows does not feel slow only because of CPU or RAM; it feels slow when every folder is full of mystery artifacts, every release requires rediscovery, and every repeated workflow starts from zero.

## Completion Gate

This repository is complete only when it contains runnable scripts, readable rules, a reusable Skill, a public README, and a release quality check.

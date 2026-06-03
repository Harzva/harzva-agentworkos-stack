# Patch Index

These patches can be copied into other repositories or local agent libraries.

| Patch type | Path | Use when |
| --- | --- | --- |
| Skill | [`skills/make-windows-silky/SKILL.md`](./skills/make-windows-silky/SKILL.md) | A user asks to make a Windows workspace smoother or less cluttered |
| Agent role | [`agents/windows-silky-inventory-agent.md`](./agents/windows-silky-inventory-agent.md) | A task needs evidence-first inventory of Windows workbench friction |
| Release role | [`agents/windows-release-gate-agent.md`](./agents/windows-release-gate-agent.md) | A task needs release proof for EXE/ZIP/MSI or GitHub publishing |
| AGENTS rule | [`rules/AGENTS.windows-silky.md`](./rules/AGENTS.windows-silky.md) | A project repeatedly accumulates duplicate builds, previews, and missing proof |
| Prompt | [`prompts/windows-silky-patch.prompt.md`](./prompts/windows-silky-patch.prompt.md) | A one-off extraction needs to become reusable assets |

Token-saver rule: if an agent would need to reread the same workspace state twice, turn the state into a report, manifest, checklist, SOP, Skill, or gate.

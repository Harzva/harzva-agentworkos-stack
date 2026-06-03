# Terminology Map

Use this file for short user phrases that imply a larger engineering workflow.

The rule of thumb:

- Put shorthand definitions here when the phrase is stable and cross-task.
- Put mandatory behavior in `AGENTS.md`.
- Put multi-step execution in a Skill.
- Put durable personal preference in local memory or a local agent rule.
- Put deterministic verification in a script or hook.

## Current Terms

| Term | Expanded meaning | Required behavior |
| --- | --- | --- |
| make_windows_silky | Save tokens by turning messy Windows workspace state into reusable evidence and gates | Prefer audit reports, manifests, preflight checks, and reusable assets over repeated raw folder rediscovery |
| token saver | A positioning rule for reducing repeated model context cost | When the same explanation would be needed again, create or update a durable artifact that future agents can read |
| 三端同步 | Keep the installed local skill/runtime copy, the local source repository, and the remote GitHub repository synchronized | Update the runtime copy, update and commit the local repo, push to remote, then verify all three states |
| README 可视化门禁 | Visual assets in README must be checked for clipping, overlap, unreadable text, unsafe scaling, and mobile/desktop readability | Do not ship SVG diagrams or README proof images until text and shapes are visually safe at README display width |
| 证据清单 | A release artifact manifest with path, bytes, SHA256, source, smoke/install result, screenshot/preview, release target, and decision | Generate or update evidence before treating an artifact as shippable |
| 工作流资产化 | Convert repeated work into a reusable asset instead of another summary | Produce or update a Skill, rule, SOP, checklist, script, prompt, hook candidate, or project card |

## Decision Matrix

| Need | Best place |
| --- | --- |
| A phrase maps to a bigger workflow | `docs/terminology-map.md` or global `TERMS.md` |
| The phrase must always constrain future work | `AGENTS.md` rule |
| The phrase requires judgment-heavy execution | Skill |
| The phrase is a stable personal preference across projects | Local memory / local agent term map |
| The phrase needs pass/fail verification | Script or hook |

## Recommended Local Pattern

For smooth agent work across projects:

1. Keep a global local term map at `C:\Users\harzva\.codex\agents\TERMS.md`.
2. Keep project-specific terms at `docs/terminology-map.md` or `TERMS.md`.
3. Add one AGENTS rule: "When the user uses a shorthand term, expand it from the term map before acting."
4. Promote a term into a Skill only when the expansion becomes a repeatable multi-step workflow.

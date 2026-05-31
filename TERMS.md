# TERMS

| Term | Expanded meaning | Required behavior |
| --- | --- | --- |
| AgentWorkOS | Generic CLI and package manager for portable agent workspaces | Keep it separate from personal or team stack repositories |
| AgentWorkOS Stack | Installable declaration of one agent environment | Manage with `agentworkos.toml` and `agentworkos.lock.json` |
| Runtime projection | Installed files under Codex or Claude runtime homes | Treat runtime copies as generated targets, not the only source of truth |
| 三端同步 | Runtime copy, local source repo, and remote GitHub repo are synchronized | Verify runtime projection, local Git state, and remote commit before calling sync complete |
| Safe core | Public-safe subset of skills, roles, rules, terms, and repo references | Exclude secrets, raw memory, private logs, and machine-specific absolute paths |

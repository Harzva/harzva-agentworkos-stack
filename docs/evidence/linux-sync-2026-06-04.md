# Linux AgentOS Sync Evidence - 2026-06-04

## Summary

A Linux remote machine successfully restored the public-safe Harzva AgentOS stack using `Harzva/harzva-agentworkos-stack` and the updated `Harzva/AgentWorkOS` CLI.

This file is a sanitized evidence summary. It intentionally excludes raw terminal logs, usernames, hostnames, absolute home paths, temporary build paths, and credential material.

## Environment

| Item | Value |
| --- | --- |
| Stack repo | `Harzva/harzva-agentworkos-stack` |
| AgentWorkOS repo | `Harzva/AgentWorkOS` |
| AgentWorkOS commit resolved by pip | `fdc3d20` |
| Profile | `linux-dev` |
| Target | `all` |
| Runtime targets | Codex and Claude Code |

## Commands validated

The remote Linux run validated this flow:

```bash
python3 -m pip install --user --upgrade --force-reinstall git+https://github.com/Harzva/AgentWorkOS.git
export PATH="$HOME/.local/bin:$PATH"
aw doctor --manifest agentworkos.toml --profile linux-dev
aw sync --manifest agentworkos.toml --target all --profile linux-dev
aw sync --manifest agentworkos.toml --target all --profile linux-dev --apply
aw scan --codex-home "$HOME/.codex" --claude-home "$HOME/.claude" --workspace "$HOME"
aw doctor --manifest agentworkos.toml --profile linux-dev
```

## Results

| Check | Result |
| --- | --- |
| `aw doctor --profile linux-dev` | Passed |
| `aw sync --profile linux-dev` dry-run | Passed |
| `aw sync --profile linux-dev --apply` | Passed |
| Codex runtime projection | Skills and agent roles copied |
| Claude Code runtime projection | Skills and agent roles copied |
| AgentWorkOS source/repo cache | Repositories cloned or fetched |
| Final `aw scan` | Passed |
| Final `aw doctor` | Passed |

Final scan summary:

```text
codex_skills=83
codex_agents=5
claude_skills=125
claude_agents=17
repos=12
```

## Notes

- A transient `git pull` TLS error appeared earlier in the raw terminal session, but it did not block the later successful AgentWorkOS CLI installation, dry-run, apply, scan, or final doctor.
- The successful run proves the remote CLI update to `Harzva/AgentWorkOS` exposed `--profile` for `doctor`, `sync`, and `install`.
- The raw terminal log should not be committed to this public repository.

## Conclusion

Linux remote AgentOS sync succeeded for the `linux-dev` profile.

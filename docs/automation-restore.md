# Automation Restore

This stack includes a portable daily AgentOS scan helper for new machines.

The restore scripts register an OS-level scheduler entry:

- Windows: Task Scheduler via `register-agentos-daily-scan.ps1`
- macOS/Linux: cron via `register-agentos-daily-scan.sh`

The scheduled scan is read-only. It does not commit, push, publish Xiaohongshu notes, or run `--apply`.

## Windows

```powershell
cd D:\path\to\harzva-agentworkos-stack
pwsh -ExecutionPolicy Bypass -File .\scripts\register-agentos-daily-scan.ps1 -At 09:30 -Profile xhs -Target codex
```

Remove it:

```powershell
pwsh -ExecutionPolicy Bypass -File .\scripts\register-agentos-daily-scan.ps1 -Unregister
```

## macOS/Linux

```bash
cd /path/to/harzva-agentworkos-stack
bash ./scripts/register-agentos-daily-scan.sh --time 09:30 --profile xhs --target codex
```

Remove it:

```bash
bash ./scripts/register-agentos-daily-scan.sh --unregister
```

## Logs

Logs are written under:

```text
.agentworkos/automation-logs/
```

This directory is local-only and should not be committed.

## Manual one-click sync

The daily scan only reports. To apply the optional XHS profile manually:

```powershell
pwsh -ExecutionPolicy Bypass -File .\scripts\sync-xhs-suite.ps1 -Profile xhs -Target all -Pull -Apply
```

```bash
bash ./scripts/sync-xhs-suite.sh --profile xhs --target all --pull --apply
```

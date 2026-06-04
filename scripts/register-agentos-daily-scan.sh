#!/usr/bin/env bash
set -euo pipefail

NAME="Harzva AgentOS Daily Scan"
TIME_VALUE="09:30"
PROFILE="xhs"
TARGET="codex"
UNREGISTER=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --name) NAME="$2"; shift 2 ;;
    --time) TIME_VALUE="$2"; shift 2 ;;
    --profile) PROFILE="$2"; shift 2 ;;
    --target) TARGET="$2"; shift 2 ;;
    --unregister) UNREGISTER="1"; shift ;;
    *) echo "unknown argument: $1" >&2; exit 2 ;;
  esac
done

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RUN_SCRIPT="$ROOT/scripts/run-agentos-daily-scan.sh"
MARKER="# $NAME"
TMP="$(mktemp)"
crontab -l 2>/dev/null | grep -vF "$MARKER" > "$TMP" || true

if [[ -n "$UNREGISTER" ]]; then
  crontab "$TMP"
  rm -f "$TMP"
  echo "unregistered cron entry: $NAME"
  exit 0
fi

HOUR="${TIME_VALUE%%:*}"
MINUTE="${TIME_VALUE##*:}"
printf '%s %s * * * cd "%s" && bash "%s" --profile "%s" --target "%s" %s\n' "$MINUTE" "$HOUR" "$ROOT" "$RUN_SCRIPT" "$PROFILE" "$TARGET" "$MARKER" >> "$TMP"
crontab "$TMP"
rm -f "$TMP"
echo "registered cron entry: $NAME"
echo "time: $TIME_VALUE"
echo "profile: $PROFILE"
echo "target: $TARGET"
echo "logs: $ROOT/.agentworkos/automation-logs"

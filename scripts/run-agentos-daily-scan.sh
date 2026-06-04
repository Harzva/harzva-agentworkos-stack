#!/usr/bin/env bash
set -euo pipefail

PROFILE="xhs"
TARGET="codex"
while [[ $# -gt 0 ]]; do
  case "$1" in
    --profile) PROFILE="$2"; shift 2 ;;
    --target) TARGET="$2"; shift 2 ;;
    *) echo "unknown argument: $1" >&2; exit 2 ;;
  esac
done

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LOG_DIR="$ROOT/.agentworkos/automation-logs"
mkdir -p "$LOG_DIR"
STAMP="$(date +%Y%m%d-%H%M%S)"
LOG_PATH="$LOG_DIR/agentos-daily-scan-$STAMP.log"
echo "writing scan log: $LOG_PATH"
bash "$ROOT/scripts/agentos-daily-scan.sh" --profile "$PROFILE" --target "$TARGET" 2>&1 | tee "$LOG_PATH"

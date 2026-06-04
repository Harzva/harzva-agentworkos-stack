#!/usr/bin/env bash
set -euo pipefail

PROFILE="xhs"
TARGET="codex"
SUITE_ROOT=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --profile) PROFILE="$2"; shift 2 ;;
    --target) TARGET="$2"; shift 2 ;;
    --suite-root) SUITE_ROOT="$2"; shift 2 ;;
    *) echo "unknown argument: $1" >&2; exit 2 ;;
  esac
done

STACK_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MANIFEST="$STACK_ROOT/agentworkos.toml"
if [[ -z "$SUITE_ROOT" ]]; then
  CANDIDATE="$(cd "$STACK_ROOT/.." && pwd)/01-skills/xhs-skill-suite"
  [[ -d "$CANDIDATE" ]] && SUITE_ROOT="$CANDIDATE"
fi

echo "# AgentOS daily scan"
echo "date=$(date -Iseconds)"
echo "stack=$STACK_ROOT"
[[ -n "$SUITE_ROOT" ]] && echo "xhs_suite=$SUITE_ROOT"

echo
echo "## Git status"
git -C "$STACK_ROOT" status --short --branch || true
if [[ -n "$SUITE_ROOT" && -d "$SUITE_ROOT" ]]; then
  git -C "$SUITE_ROOT" status --short --branch || true
fi

echo
echo "## Recent local Codex skills"
CODEX_SKILLS="$HOME/.codex/skills"
if [[ -d "$CODEX_SKILLS" ]]; then
  find "$CODEX_SKILLS" -mindepth 1 -maxdepth 1 -type d -printf '%TY-%Tm-%Td %TH:%TM %f\n' 2>/dev/null | sort -r | head -20 || true
fi

echo
echo "## Stack health"
aw doctor --manifest "$MANIFEST" --profile safe-core || true
aw doctor --manifest "$MANIFEST" --profile creator || true
aw doctor --manifest "$MANIFEST" --profile xhs || true

echo
echo "## XHS dry-run"
aw sync --manifest "$MANIFEST" --target "$TARGET" --profile "$PROFILE" || true

echo
echo "## Suggested one-click apply"
echo "bash ./scripts/sync-xhs-suite.sh --profile $PROFILE --target all --pull --apply"


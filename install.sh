#!/usr/bin/env bash
set -euo pipefail

PROFILE="linux-dev"
TARGET="all"
APPLY="0"
INSTALL_AW="1"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --profile)
      PROFILE="${2:?missing value for --profile}"
      shift 2
      ;;
    --target)
      TARGET="${2:?missing value for --target}"
      shift 2
      ;;
    --apply)
      APPLY="1"
      shift
      ;;
    --skip-aw-install)
      INSTALL_AW="0"
      shift
      ;;
    -h|--help)
      cat <<'HELP'
Usage: ./install.sh [--profile linux-dev] [--target all] [--apply] [--skip-aw-install]

Default behavior is safe dry-run:
  ./install.sh

Apply runtime changes only when explicit:
  ./install.sh --apply

Common profiles:
  windows-desktop, mac-dev, linux-dev, linux-server
HELP
      exit 0
      ;;
    *)
      echo "unknown argument: $1" >&2
      exit 2
      ;;
  esac
done

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT"

if [[ "$INSTALL_AW" == "1" ]]; then
  python3 -m pip install --user --upgrade --force-reinstall git+https://github.com/Harzva/AgentWorkOS.git
fi

export PATH="$HOME/.local/bin:$PATH"

if ! command -v aw >/dev/null 2>&1; then
  echo "aw not found. Try: export PATH=\"\$HOME/.local/bin:\$PATH\"" >&2
  exit 127
fi

echo "== AgentWorkOS =="
command -v aw
aw doctor --help | grep -q -- '--profile' || {
  echo "installed aw does not expose --profile; reinstall AgentWorkOS from Harzva/AgentWorkOS main" >&2
  exit 2
}

echo "== Pull latest stack =="
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  git pull --ff-only || echo "git pull skipped or not fast-forward; continuing with local checkout" >&2
fi

echo "== Doctor: profile=$PROFILE =="
aw doctor --manifest agentworkos.toml --profile "$PROFILE"

echo "== Dry-run sync: target=$TARGET profile=$PROFILE =="
aw sync --manifest agentworkos.toml --target "$TARGET" --profile "$PROFILE"

if [[ "$APPLY" == "1" ]]; then
  echo "== Apply sync =="
  aw sync --manifest agentworkos.toml --target "$TARGET" --profile "$PROFILE" --apply

  echo "== Scan runtime =="
  aw scan \
    --codex-home "$HOME/.codex" \
    --claude-home "$HOME/.claude" \
    --workspace "$HOME"

  echo "== Final doctor =="
  aw doctor --manifest agentworkos.toml --profile "$PROFILE"
else
  echo "dry-run complete; rerun with --apply to write runtime files"
fi
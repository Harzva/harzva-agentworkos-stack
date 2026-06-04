#!/usr/bin/env bash
set -euo pipefail

PROFILE="xhs"
TARGET="all"
APPLY=""
PULL=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --profile) PROFILE="$2"; shift 2 ;;
    --target) TARGET="$2"; shift 2 ;;
    --apply) APPLY="--apply"; shift ;;
    --pull) PULL="1"; shift ;;
    *) echo "unknown argument: $1" >&2; exit 2 ;;
  esac
done

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MANIFEST="$ROOT/agentworkos.toml"

if [[ -n "$PULL" ]]; then
  git -C "$ROOT" pull --ff-only
fi

aw doctor --manifest "$MANIFEST" --profile "$PROFILE"
aw sync --manifest "$MANIFEST" --target "$TARGET" --profile "$PROFILE"

if [[ -n "$APPLY" ]]; then
  aw sync --manifest "$MANIFEST" --target "$TARGET" --profile "$PROFILE" --apply
else
  echo "dry-run only; rerun with --apply to write runtime files."
fi

#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source_dir="$repo_root/skills"
force=0

for arg in "$@"; do
  case "$arg" in
    --force) force=1 ;;
    *)
      echo "Unknown argument: $arg" >&2
      echo "Usage: bash scripts/install.sh [--force]" >&2
      exit 2
      ;;
  esac
done

if [[ ! -d "$source_dir" ]]; then
  echo "Cannot find skills directory: $source_dir" >&2
  exit 1
fi

if [[ -n "${CODEX_HOME:-}" ]]; then
  dest="$CODEX_HOME/skills"
else
  dest="$HOME/.codex/skills"
fi

mkdir -p "$dest"

for skill in "$source_dir"/*; do
  [[ -d "$skill" ]] || continue
  name="$(basename "$skill")"
  if [[ -e "$dest/$name" ]]; then
    if [[ "$force" != "1" ]]; then
      echo "Target already exists: $dest/$name. Re-run with --force to overwrite." >&2
      exit 1
    fi
    rm -rf "$dest/$name"
  fi
  cp -R "$skill" "$dest/$name"
  echo "Installed $name -> $dest/$name"
done

echo
echo "Done. Run ./scripts/preflight.sh to verify Claude/Codex paths."

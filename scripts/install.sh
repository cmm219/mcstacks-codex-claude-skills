#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source_dir="$repo_root"
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

if [[ -n "${CODEX_HOME:-}" ]]; then
  dest="$CODEX_HOME/skills"
else
  dest="$HOME/.codex/skills"
fi

mkdir -p "$dest"

found=0
for skill in "$source_dir"/*; do
  [[ -d "$skill" ]] || continue
  [[ -f "$skill/SKILL.md" ]] || continue
  found=1
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

if [[ "$found" != "1" ]]; then
  echo "No root-level skill directories found in: $source_dir" >&2
  exit 1
fi

json_escape() {
  printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g'
}

source_head="unknown"
if source_head_out="$(git -C "$repo_root" rev-parse HEAD 2>/dev/null)"; then
  source_head="$source_head_out"
fi

source_remote="https://github.com/cmm219/mcstacks-codex-claude-skills.git"
if source_remote_out="$(git -C "$repo_root" remote get-url origin 2>/dev/null)"; then
  [[ -n "$source_remote_out" ]] && source_remote="$source_remote_out"
fi

version="unknown"
if [[ -f "$repo_root/CHANGELOG.md" ]]; then
  version_line="$(grep -E '^##[[:space:]]+[0-9]+\.[0-9]+\.[0-9]+' "$repo_root/CHANGELOG.md" | head -n 1 || true)"
  if [[ "$version_line" =~ ^##[[:space:]]+([0-9]+\.[0-9]+\.[0-9]+) ]]; then
    version="${BASH_REMATCH[1]}"
  fi
fi

manifest_dir="$dest/.mcstacks"
mkdir -p "$manifest_dir"
manifest="$manifest_dir/manifest.json"
{
  printf '{\n'
  printf '  "schemaVersion": 1,\n'
  printf '  "name": "mcstacks",\n'
  printf '  "version": "%s",\n' "$(json_escape "$version")"
  printf '  "installedAtUtc": "%s",\n' "$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
  printf '  "installType": "repo-root",\n'
  printf '  "sourcePath": "%s",\n' "$(json_escape "$repo_root")"
  printf '  "sourceRemote": "%s",\n' "$(json_escape "$source_remote")"
  printf '  "sourceHead": "%s",\n' "$(json_escape "$source_head")"
  printf '  "destination": "%s",\n' "$(json_escape "$dest")"
  printf '  "skills": [\n'
  first=1
  for skill in "$source_dir"/*; do
    [[ -d "$skill" ]] || continue
    [[ -f "$skill/SKILL.md" ]] || continue
    name="$(basename "$skill")"
    if [[ "$first" != "1" ]]; then
      printf ',\n'
    fi
    first=0
    printf '    { "name": "%s", "installedPath": "%s" }' "$(json_escape "$name")" "$(json_escape "$dest/$name")"
  done
  printf '\n  ]\n'
  printf '}\n'
} > "$manifest"

echo
echo "Done. Run ./scripts/preflight.sh to verify Claude/Codex paths."

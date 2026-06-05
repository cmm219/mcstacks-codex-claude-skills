#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

install_args=()
for arg in "$@"; do
  case "$arg" in
    --force)
      install_args+=("--force")
      ;;
    *)
      echo "Unknown argument: $arg" >&2
      echo "Usage: bash setup.sh [--force]" >&2
      exit 2
      ;;
  esac
done

bash "$repo_root/scripts/install.sh" "${install_args[@]}"
bash "$repo_root/scripts/preflight.sh"

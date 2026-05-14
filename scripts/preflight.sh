#!/usr/bin/env bash
set -euo pipefail
errors=0

find_claude() {
  if [[ -n "${CLAUDE_CLI_PATH:-}" && -x "$CLAUDE_CLI_PATH" ]]; then
    printf '%s\n' "$CLAUDE_CLI_PATH"
    return 0
  fi

  if command -v claude >/dev/null 2>&1; then
    command -v claude
    return 0
  fi

  for candidate in "$HOME/.npm-global/bin/claude" "$HOME/.local/bin/claude" "/opt/homebrew/bin/claude" "/usr/local/bin/claude"; do
    if [[ -x "$candidate" ]]; then
      printf '%s\n' "$candidate"
      return 0
    fi
  done

  return 1
}

if [[ -n "${CODEX_HOME:-}" ]]; then
  codex_skills="$CODEX_HOME/skills"
else
  codex_skills="$HOME/.codex/skills"
fi

echo "McStacks preflight"
echo "Platform: $(uname -s)"
echo "Codex skills directory: $codex_skills"

if [[ ! -d "$codex_skills" ]]; then
  echo "WARN: Codex skills directory does not exist. Run ./scripts/install.sh to create it."
fi

if command -v git >/dev/null 2>&1; then
  echo "Git: $(command -v git)"
else
  echo "ERROR: git not found on PATH."
  errors=$((errors + 1))
fi

if command -v codex >/dev/null 2>&1; then
  echo "Codex: $(command -v codex)"
  if codex_version="$(codex --version 2>&1)"; then
    echo "Codex version: $codex_version"
  else
    echo "WARN: Codex version check failed: $(printf '%s' "$codex_version" | head -n 1)"
  fi
else
  echo "WARN: codex not found on PATH. Skills may still work in Codex Desktop if installed."
fi

if claude_path="$(find_claude)"; then
  echo "Claude CLI: $claude_path"
  if claude_version="$("$claude_path" --version 2>&1)"; then
    echo "Claude version: $claude_version"
  else
    echo "WARN: Claude version check failed: $(printf '%s' "$claude_version" | head -n 1)"
  fi
else
  echo "ERROR: Claude CLI not found. Install Claude Code or set CLAUDE_CLI_PATH."
  errors=$((errors + 1))
fi

if [[ -n "${ANTHROPIC_API_KEY:-}" ]]; then
  echo "WARN: ANTHROPIC_API_KEY is set. Claude CLI calls may use API spend."
fi
if [[ -n "${ANTHROPIC_AUTH_TOKEN:-}" ]]; then
  echo "WARN: ANTHROPIC_AUTH_TOKEN is set. Check your Claude CLI auth route."
fi
if [[ -n "${ANTHROPIC_BASE_URL:-}" ]]; then
  echo "WARN: ANTHROPIC_BASE_URL is set. Claude CLI may use an alternate endpoint."
fi

echo "If claude works in your terminal but not from Codex, check shell startup files, nvm/asdf/Volta shims, and set CLAUDE_CLI_PATH explicitly."

validator="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/scripts/validate-skills.mjs"
if command -v node >/dev/null 2>&1 && [[ -f "$validator" ]]; then
  if ! node "$validator"; then
    echo "ERROR: skill validation failed."
    errors=$((errors + 1))
  fi
else
  echo "WARN: Node not found or validator missing; skipped skill validation."
fi

if [[ "$errors" -gt 0 ]]; then
  exit 1
fi

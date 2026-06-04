# Troubleshooting

## Claude works in my terminal but not from Codex

Set `CLAUDE_CLI_PATH` explicitly.

Windows PowerShell:

```powershell
$env:CLAUDE_CLI_PATH = "$env:APPDATA\npm\claude.ps1"
```

macOS / Linux:

```bash
export CLAUDE_CLI_PATH="$(command -v claude)"
```

This helps when shell startup files, nvm, asdf, Volta, Homebrew, or npm shims are not available inside the Codex execution environment.

## PowerShell blocks install.ps1

Run:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\install.ps1
```

## Codex does not see the skills

Run preflight:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\preflight.ps1
```

or:

```bash
./scripts/preflight.sh
```

Confirm the skills were copied to the Codex skills directory used by your Codex installation.

Expected shape:

```text
McStacks preflight
Platform: <platform>
Codex skills directory: <skills path>
Git: <git path>
Codex: <codex path>
Codex version: <version>
Claude CLI: <claude path>
Claude version: <version>
Skill validation passed.
```

Windows PowerShell also prints the current-user execution policy. Exact paths and wording can vary by platform.

Treat missing skills, failed metadata validation, or missing Claude CLI as setup issues to fix before relying on review or shipping loops.

When running the shell script inside WSL, preflight may warn that the Codex version check failed if WSL resolves a Windows Codex shim under `/mnt/c/...`. If the script continues and `Skill validation passed.` appears, the McStacks skills installation is still usable. Set `CODEX_HOME` and your shell `PATH` explicitly if you want WSL to use a Linux-native Codex install.

## Claude asks for permission during read-only review

Prefer stdin context with tools disabled:

```bash
git diff | claude --permission-mode plan --tools "" -p "Review this diff..."
```

If file reads are necessary, use a narrow read-only allowlist:

```bash
claude --permission-mode plan --allowed-tools Read,Grep,Glob -p "Inspect only these scoped files..."
```

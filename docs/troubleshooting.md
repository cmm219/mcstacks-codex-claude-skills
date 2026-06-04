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
Repo: <repo path>
Codex skills dir: <skills path>
OK: found skills
OK: skill metadata validated
OK: Claude CLI found
Done
```

Exact paths and wording can vary by platform. Treat missing skills, failed metadata validation, or missing Claude CLI as setup issues to fix before relying on review or shipping loops.

## Claude asks for permission during read-only review

Prefer stdin context with tools disabled:

```bash
git diff | claude --permission-mode plan --tools "" -p "Review this diff..."
```

If file reads are necessary, use a narrow read-only allowlist:

```bash
claude --permission-mode plan --allowed-tools Read,Grep,Glob -p "Inspect only these scoped files..."
```

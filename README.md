# McStacks: Codex Claude Skills

Codex skills that call Claude Code for review, planning, and design. Codex stays in charge of the repo, QA, and merge.

This repository provides portable Codex skills for local multi-agent development workflows:

- `claude-readonly-review`: ask Claude Code for a second-opinion review or implementation plan without allowing writes.
- `claude-design-html`: use Claude Code as a scoped frontend design partner, then have Codex review, integrate, and verify the result.
- `claude-design-loop`: run the full gated loop: Claude design artifact, Codex review, user approval, app implementation, Codex QA, final user approval.

Use `claude-design-loop` when you want strict pre-implementation artifact approval. Use `claude-design-html` for a lighter single scoped design critique or implementation pass.

These skills target OpenAI Codex / Codex Desktop / Codex CLI skill workflows that load skills from a Codex skills directory such as `$CODEX_HOME/skills` or `~/.codex/skills`.

## Why Codex + Claude?

Codex is good at owning the working tree, applying changes, running checks, and carrying work through to reviewable output. Claude Code can be useful as a specialist reviewer, planner, or frontend design partner. McStacks gives Codex a repeatable way to bring Claude into that loop without manual copy-paste.

The boundary is intentional:

- Codex owns repo state, branch/worktree setup, scope definition, integration, QA, commits, pushes, PRs, and deploys.
- Claude can review or plan in read-only mode.
- Claude can write frontend/design files only when explicitly scoped by `claude-design-html`.
- Claude output is never self-approving. Codex reviews Claude plans, diffs, and rendered UI before accepting them.

## Install

Clone the repo and run the installer from the checkout. Avoid `curl | sh` for tools that affect local agent workflows.

Windows PowerShell:

```powershell
git clone https://github.com/cmm219/mcstacks-codex-claude-skills.git
cd mcstacks-codex-claude-skills
powershell -ExecutionPolicy Bypass -File .\scripts\install.ps1
powershell -ExecutionPolicy Bypass -File .\scripts\preflight.ps1
```

macOS / Linux:

```bash
git clone https://github.com/cmm219/mcstacks-codex-claude-skills.git
cd mcstacks-codex-claude-skills
bash scripts/install.sh
bash scripts/preflight.sh
```

The installer copies `skills/*` into `$CODEX_HOME/skills` when `CODEX_HOME` is set, otherwise into `~/.codex/skills`.

## Claude CLI Discovery

The skills and scripts resolve Claude Code in this order:

1. `CLAUDE_CLI_PATH`, if set.
2. `claude` on `PATH`.
3. Platform-specific hints from the preflight script.

Windows examples:

```powershell
$env:CLAUDE_CLI_PATH = "$env:APPDATA\npm\claude.ps1"
$env:CLAUDE_CLI_PATH = "$env:APPDATA\npm\claude.cmd"
```

macOS / Linux example:

```bash
export CLAUDE_CLI_PATH="$(command -v claude)"
```

## Supported Platforms

The skills are plain text and should work wherever Codex skills and Claude Code are available. The platform-specific pieces are install/preflight scripts and CLI path discovery.

Tested baseline for v0.1.0:

- Windows 11 + PowerShell
- Codex CLI >= 0.125.0
- Claude Code >= 2.1.119

macOS and Linux support is implemented in the shell scripts but should be verified by users on their local setup.

## Privacy, Auth, and Quota

These skills call your local Claude Code CLI. They do not store Anthropic API keys in the skill files.

Important: content you pass to Claude Code may be sent to Anthropic or to the provider configured for your Claude Code installation. Read-only means "no file writes," not "no file reads" or "no data egress."

Claude invocations may consume your Claude Code subscription quota, Anthropic API spend, or alternate provider quota depending on how your local Claude CLI is authenticated. The preflight scripts warn when `ANTHROPIC_API_KEY`, `ANTHROPIC_AUTH_TOKEN`, or `ANTHROPIC_BASE_URL` are set.

## Example Prompts

```text
Use claude-readonly-review to review my current diff for correctness risks.
```

```text
Use claude-readonly-review to help plan this refactor before Codex implements it.
```

```text
Use claude-design-html for a read-only visual critique first, then have Codex choose the fixes.
```

```text
Use claude-design-html to let Claude implement a scoped frontend polish pass, then have Codex review, QA, and integrate the result.
```

```text
Use claude-design-html with my installed local /design-html workflow to generate a design artifact, then have Codex port the accepted design into the real app.
```

```text
Use claude-design-loop so Claude generates the HTML artifact first, Codex reviews it, I approve it, then the approved design gets implemented and QA'd.
```

## Safety Model

Files Claude reads are untrusted input. Claude output is also untrusted input. Codex is the trust boundary.

That means Codex must:

- Review Claude plans before using them.
- Review Claude diffs before accepting them.
- Reject out-of-scope edits.
- Run relevant lint/build/test checks.
- Run browser QA or screenshot checks for frontend/design work when feasible.
- Require human approval for secrets, destructive commands, production deploys, money movement, account changes, or other high-risk actions.

See [docs/safety-model.md](docs/safety-model.md).

## Validate

The repo includes a lightweight skill validator. It requires Node 18 or newer:

```bash
node scripts/validate-skills.mjs
```

## Uninstall

Remove the installed skill folders from your Codex skills directory:

```bash
rm -rf ~/.codex/skills/claude-readonly-review ~/.codex/skills/claude-design-html ~/.codex/skills/claude-design-loop
```

Windows PowerShell:

```powershell
Remove-Item "$HOME\.codex\skills\claude-readonly-review","$HOME\.codex\skills\claude-design-html","$HOME\.codex\skills\claude-design-loop" -Recurse -Force
```

## FAQ

### Why not just use Claude Code directly?

You can. McStacks is for people who want Codex to remain the orchestrator: tracking repo state, applying integration judgment, running QA, and deciding what actually lands.

### Why not just use Codex directly?

You can. These skills are useful when you want a second model to review a diff, challenge a plan, or produce a frontend design pass while Codex keeps control of the workflow.

### Does this share my code?

Yes, if you pass code, diffs, screenshots, or file contents to Claude Code, that context may be sent to Anthropic or the provider configured for your Claude Code installation. Use project ignore settings and scoped prompts to avoid sending secrets or unrelated files.

### Is this affiliated with OpenAI or Anthropic?

No. This project is not affiliated with, endorsed by, or sponsored by OpenAI or Anthropic.

## Non-goals

- Not a Claude SDK.
- Not a hosted service.
- Not a model router.
- Not a vendor or redistribution package for third-party Claude skills.
- Not a replacement for Codex or Claude Code.
- Not an automation system that bypasses human approval for risky actions.

## License

MIT

# McStacks: Codex Claude Skills

Codex skills that call Claude Code for review, planning, and design. Codex stays in charge of the repo, QA, and merge.

This repository provides portable Codex skills for local multi-agent development workflows:

- `claude-readonly-review`: ask Claude Code for a second-opinion review or implementation plan without allowing writes.
- `claude-design-html`: use Claude Code as a scoped frontend design partner, then have Codex review, integrate, and verify the result.
- `claude-design-loop`: run the full gated loop: Claude design artifact, Codex review, user approval, app implementation, Codex QA, final user approval.
- `pr-batching`: decide whether related work should ship as one PR, stacked PRs, or separate PRs.
- `prd-review-loop`: draft, score, review, and iterate PRDs before design or implementation.
- `prd-ship-loop`: execute an approved PRD or task list through implementation, review, PRs, checks, and smoke QA without routine soft-stops.

`prd-ship-loop` is intentionally batch-oriented. A clear ship token such as "ship it", "merge when green", "finish this PRD", or "keep going until deployed" can authorize multiple PRs inside the same approved PRD or task list. It should still stop for secrets/access, destructive out-of-scope operations, unclear product/data risk, failed production smoke, conflicting instructions, or completed scope.

These skills target OpenAI Codex / Codex Desktop / Codex CLI skill workflows that load skills from a Codex skills directory such as `$CODEX_HOME/skills` or `~/.codex/skills`.

## Which Skill Should I Use?

| Need | Use | What Happens |
| --- | --- | --- |
| Second opinion on a diff or plan | `claude-readonly-review` | Codex sends scoped context to Claude, then verifies findings before editing. |
| Frontend critique or scoped design polish | `claude-design-html` | Claude helps with visual/design work while Codex owns integration and QA. |
| Artifact-first UI redesign | `claude-design-loop` | Claude creates a standalone artifact, the user approves it, then app implementation starts. |
| Decide PR shape | `pr-batching` | Codex recommends one PR, stacked PRs, or split PRs based on risk and verification. |
| Turn a rough feature idea into requirements | `prd-review-loop` | Codex drafts/scores a PRD and uses Claude review when useful. |
| Execute an approved PRD/task list | `prd-ship-loop` | Codex implements, verifies, opens/updates PRs, and continues through approved scope. |

Start small. Use `claude-readonly-review` for a review, `claude-design-loop` for high-impact UI work that needs approval before implementation, and `prd-ship-loop` only after the PRD or task list is approved.

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

## Typical Workflows

### Safer Review

1. Ask Codex to use `claude-readonly-review`.
2. Codex sends only the relevant diff, files, logs, or plan.
3. Claude returns findings.
4. Codex verifies them against the repo and applies only valid fixes.
5. Codex runs the relevant checks before reporting back.

### Gated Design

1. Ask for `claude-design-loop`.
2. Claude creates or revises a standalone design artifact.
3. Codex reviews the artifact for data fidelity, layout, mobile behavior, and implementation risk.
4. The user approves the artifact.
5. Codex ports the approved design into the app and runs browser QA.

### PRD to Shipping

1. Use `prd-review-loop` to make the requirements precise enough to build.
2. Use `pr-batching` when the work could be one PR, stacked PRs, or split PRs.
3. Use `prd-ship-loop` only after the scope is approved.
4. Codex keeps moving through routine verification and stops only for real blockers.

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

### Optional Design-Enabled Claude Command

For frontend-heavy workflows, `claude-design-html` and `claude-design-loop` can use `CLAUDE_DESIGN_CLI` when set. This is optional advanced setup for users who maintain a separate Claude wrapper, profile command, or script with design plugins enabled for that session.

Keep the default Claude setup lean. A design-enabled wrapper should not mutate global Claude settings, enable plugins globally, or interfere with unrelated Claude processes. It should accept the same CLI surface as Claude Code for these skills: stdin prompts, `-p`, `--permission-mode`, and `--allowed-tools`.

Windows PowerShell example:

```powershell
$env:CLAUDE_DESIGN_CLI = "C:\path\to\your\claude-design-wrapper.ps1"
```

macOS / Linux example:

```bash
export CLAUDE_DESIGN_CLI="/path/to/your/claude-design-wrapper"
```

The preflight scripts do not validate `CLAUDE_DESIGN_CLI`. Smoke-test your wrapper locally before relying on it in a design loop.

## Supported Platforms

The skills are plain text and should work wherever Codex skills and Claude Code are available. The platform-specific pieces are install/preflight scripts and CLI path discovery.

Tested baseline:

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

```text
Use claude-design-loop with my CLAUDE_DESIGN_CLI wrapper for the artifact and design revisions.
```

```text
Use prd-review-loop to turn this rough feature idea into a scored PRD before implementation.
```

```text
Use pr-batching to decide whether this should be one PR, stacked PRs, or separate PRs.
```

```text
Use prd-ship-loop to execute this approved PRD and keep going through verification until the approved scope is complete.
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
rm -rf ~/.codex/skills/claude-readonly-review ~/.codex/skills/claude-design-html ~/.codex/skills/claude-design-loop ~/.codex/skills/pr-batching ~/.codex/skills/prd-review-loop ~/.codex/skills/prd-ship-loop
```

Windows PowerShell:

```powershell
Remove-Item "$HOME\.codex\skills\claude-readonly-review","$HOME\.codex\skills\claude-design-html","$HOME\.codex\skills\claude-design-loop","$HOME\.codex\skills\pr-batching","$HOME\.codex\skills\prd-review-loop","$HOME\.codex\skills\prd-ship-loop" -Recurse -Force
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

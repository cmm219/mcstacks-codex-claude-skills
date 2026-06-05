# McStacks

McStacks is a public Codex workflow stack for people who want local AI-assisted software work to be reviewable, repeatable, and safe to ship.

Codex owns the repo, working tree, QA, PRs, and shipping decisions. Claude is brought in as review input: read-only reviewer, planning challenger, scoped design partner, or structured handoff author. The result is a practical stack for moving from rough scope to verified PR without letting model output become authority.

## Who This Is For

- Builders using Codex who want a stronger review and shipping loop.
- Small teams that need public-safe project setup, local knowledge routing, and explicit agent boundaries.
- Engineers who want Claude involved without giving it uncontrolled repo authority.
- Projects where correctness, privacy, release notes, and verification matter.

## Quick Start

Clone the repo, install the skills, then run preflight.

Windows PowerShell:

```powershell
git clone https://github.com/cmm219/mcstacks-codex-claude-skills.git
cd mcstacks-codex-claude-skills
powershell -ExecutionPolicy Bypass -File .\setup.ps1
```

macOS / Linux:

```bash
git clone https://github.com/cmm219/mcstacks-codex-claude-skills.git
cd mcstacks-codex-claude-skills
bash setup.sh
```

After install, try these prompts in Codex:

```text
Use claude-readonly-review to review my current diff for correctness risks.
```

```text
Use prd-review-loop to turn this feature idea into a scored PRD before implementation.
```

```text
Use prd-ship-loop to execute this approved task list and keep going through verification until the approved scope is complete.
```

```text
Use codex-handoff-packet to evaluate this Claude handoff and decide whether Codex should implement it.
```

The setup wrappers install each root-level directory that contains a `SKILL.md`, run preflight, and write a local McStacks install manifest under the Codex skills directory. Set `CODEX_HOME` to choose a non-default install root. Re-run with `-Force` on Windows or `--force` on macOS/Linux to overwrite an existing McStacks skill install.

## Who This Is Not For

- People looking for a hosted service or model router.
- Teams that want autonomous deploys or risky actions without human approval.
- Users who want to vendor private notes, secrets, project transcripts, or third-party skill bodies.
- Workflows where Claude should own git, PRs, deploys, or final engineering judgment.

## See It Work

```text
You: Use prd-review-loop to turn this rough feature idea into a scored PRD before implementation.

Codex: drafts requirements, names goals/non-goals, defines verification, and asks Claude for read-only review when useful.

You: Approved. Use pr-batching to decide the PR shape.

Codex: recommends one PR, stacked PRs, or separate PRs based on risk and verification boundaries.

You: Use prd-ship-loop to execute the approved scope and merge when green.

Codex: branches, implements, runs checks, asks Claude to review the final diff and QA evidence, opens the PR, waits for checks, merges when authorized, and reports what shipped.
```

## The McStacks Loop

```text
Scope -> Review -> Implement -> Verify -> Ship -> Capture
```

- Scope: define the approved work, risk boundary, and stop gates.
- Review: use Claude as read-only review or planning input before risky implementation.
- Implement: Codex owns edits, repo state, and integration decisions.
- Verify: run relevant checks, QA, smoke tests, and second-pass review.
- Ship: use the repo's PR, merge, deploy, and smoke workflow when authorized.
- Capture: record public-safe templates, follow-ups, and durable lessons.

## Skills

| Skill | What it does | When to use |
| --- | --- | --- |
| [`claude-readonly-review`](claude-readonly-review/) | Sends scoped plans, diffs, or QA evidence to Claude for read-only review while Codex owns all repo actions. | You want a second model to challenge a plan, diff, or risky change before Codex acts. |
| [`claude-design-html`](claude-design-html/) | Uses Claude as a scoped frontend design partner, then has Codex review, integrate, and verify the result. | You need visual/design polish but want Codex to keep integration control. |
| [`claude-design-loop`](claude-design-loop/) | Runs a gated design artifact loop before app implementation begins. | UI work needs artifact approval before code changes. |
| [`codex-handoff-packet`](codex-handoff-packet/) | Converts a Claude-originated request into a bounded packet Codex can verify before acting. | Claude has proposed work, but Codex must check scope, evidence, and permissions first. |
| [`mcstacks-upgrade`](mcstacks-upgrade/) | Updates installed McStacks skills from a verified source using the install manifest allowlist. | You installed McStacks earlier and want to refresh the local skills safely. |
| [`pr-batching`](pr-batching/) | Decides whether related work should ship as one PR, stacked PRs, or separate PRs. | Review or rollback shape is unclear. |
| [`prd-review-loop`](prd-review-loop/) | Drafts, scores, reviews, and iterates PRDs before design or implementation. | A rough idea needs requirements before build work. |
| [`prd-ship-loop`](prd-ship-loop/) | Executes an approved PRD, task list, issue, or explicit scope through implementation, checks, PRs, and smoke QA. | The scope is approved and Codex should keep moving through routine verification. |

`prd-ship-loop` is intentionally batch-oriented. A clear ship token such as "ship it", "merge when green", "finish this PRD", or "keep going until deployed" can authorize multiple PRs inside the same approved PRD or task list. It should still stop for secrets/access, destructive out-of-scope operations, unclear product/data risk, failed production smoke, conflicting instructions, or completed scope.

## Examples

Start with [`examples/README.md`](examples/README.md), then open the example that matches the workflow:

- [`examples/readonly-review.md`](examples/readonly-review.md)
- [`examples/design-html.md`](examples/design-html.md)
- [`examples/claude-to-codex-handoff.md`](examples/claude-to-codex-handoff.md)
- [`examples/prd-to-ship.md`](examples/prd-to-ship.md)
- [`examples/ship-completed-work.md`](examples/ship-completed-work.md)

## Stack Layout

| Area | Folder | Purpose |
| --- | --- | --- |
| Skills | root-level `*/SKILL.md` folders | Installable Codex skills that activate specific workflows. |
| Brain | [`brain/`](brain/) | Public-safe memory routing patterns, templates, and privacy rules. |
| Workflows | [`workflows/`](workflows/) | Human-readable operating loops that connect skills into repeatable processes. |
| Agents | [`agents/`](agents/) | Role boundaries for Codex, Claude, and shared handoffs. |
| Scripts | [`scripts/`](scripts/) | Install, preflight, validation, and upgrade helpers. |
| Examples | [`examples/`](examples/) | Copy-paste usage examples for common workflows. |
| Docs | [`docs/`](docs/) | Safety model, troubleshooting, and repo structure guidance. |
| Tasks | [`TASKS.md`](TASKS.md) | Public roadmap items and follow-up work. |

These skills target OpenAI Codex / Codex Desktop / Codex CLI skill workflows that load skills from a Codex skills directory such as `$CODEX_HOME/skills` or `~/.codex/skills`.

## Why Codex + Claude?

Codex is good at owning the working tree, applying changes, running checks, and carrying work through to reviewable output. Claude Code can be useful as a specialist reviewer, planner, or frontend design partner. McStacks gives Codex a repeatable way to bring Claude into that loop without manual copy-paste.

The boundary is intentional:

- Codex owns repo state, branch/worktree setup, scope definition, integration, QA, commits, pushes, PRs, and deploys.
- Claude can review or plan in read-only mode.
- Claude can write frontend/design files only when explicitly scoped by `claude-design-html`.
- Claude output is never self-approving. Codex reviews Claude plans, diffs, and rendered UI before accepting them.

The [`brain/`](brain/) folder documents reusable knowledge-routing patterns. It is not a dump of private memory, transcripts, secrets, or project notes.

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
See [docs/folder-structure.md](docs/folder-structure.md) for how the public stack is organized.
See [docs/new-project-setup.md](docs/new-project-setup.md) for the serious-project bootstrap flow.

## Validate

The repo includes a lightweight skill validator. It requires Node 18 or newer:

```bash
node scripts/validate-skills.mjs
```

## Uninstall

Remove the installed skill folders from your Codex skills directory:

```bash
rm -rf ~/.codex/skills/claude-readonly-review ~/.codex/skills/claude-design-html ~/.codex/skills/claude-design-loop ~/.codex/skills/codex-handoff-packet ~/.codex/skills/mcstacks-upgrade ~/.codex/skills/pr-batching ~/.codex/skills/prd-review-loop ~/.codex/skills/prd-ship-loop ~/.codex/skills/.mcstacks
```

Windows PowerShell:

```powershell
Remove-Item "$HOME\.codex\skills\claude-readonly-review","$HOME\.codex\skills\claude-design-html","$HOME\.codex\skills\claude-design-loop","$HOME\.codex\skills\codex-handoff-packet","$HOME\.codex\skills\mcstacks-upgrade","$HOME\.codex\skills\pr-batching","$HOME\.codex\skills\prd-review-loop","$HOME\.codex\skills\prd-ship-loop","$HOME\.codex\skills\.mcstacks" -Recurse -Force
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

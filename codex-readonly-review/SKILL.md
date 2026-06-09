---
name: codex-readonly-review
description: Use when Claude Code (the driver) should call the user's local Codex CLI as a read-only second reviewer, planner, or oracle for repo diffs, scoped files, risk analysis, code review, PRD/design review, or implementation planning; by default, loop plan review until approved before implementation, then loop diff/QA review until approved, while Claude remains the only agent editing, committing, pushing, or deploying. This is the mirror of the Codex-side `claude-readonly-review` skill.
---

# Codex Read-Only Review

## Driver Direction (read this first)

This is a **Claude Code skill**, not a Codex skill. It is the mirror of
`claude-readonly-review`:

- `claude-readonly-review` (Codex skill): **Codex drives, Claude reviews.**
- `codex-readonly-review` (this skill): **Claude drives, Codex reviews.**

Install it into your Claude Code skills directory (for example
`~/.claude/skills/codex-readonly-review/`), not into the Codex skills
directory. The McStacks setup scripts intentionally skip this folder when
installing Codex skills.

## Purpose

Use the local Codex CLI for a second-model review or planning pass while
keeping Claude Code in control of the repository. Codex output is advisory.
Claude must verify claims against the code before acting, and Claude remains
responsible for edits, commands, commits, pushes, deploys, and final QA.

Codex is invoked through the `codex` CLI. If command behavior looks different
from what this skill describes, run `codex --version` and check the CLI's
release notes — flag names and config variants change between versions.

Read-only is requested with the sandbox flag:

```bash
codex exec "<prompt>" -C "<working-dir>" -s read-only < /dev/null
```

`-s read-only` is a sandbox guardrail: it constrains Codex's filesystem writes
and sandboxed command execution. It is a backstop, not the whole enforcement
model — the prompt must STILL instruct Codex not to attempt edits, commits,
pushes, deploys, or other mutating actions, and Claude must never blindly run a
command Codex suggests (inspect it first).

## Control Boundary

1. Claude owns repo state and all file edits.
2. Claude sends Codex diffs, scoped files, logs, design docs, or questions via the prompt.
3. Codex returns text findings or plans.
4. Claude evaluates those findings and decides what to change.
5. Codex does not edit files, run mutating commands, commit, push, deploy, or operate services. `-s read-only` supports the filesystem boundary; the prompt instruction and Claude's inspection of any suggested commands enforce the rest. Do not remove `-s read-only` unless the user explicitly changes the boundary.

This uses the user's signed-in Codex/OpenAI account, not Anthropic tokens.

## stdin Transport Rules

`codex exec` natively reads piped stdin and appends it to the prompt as a
`<stdin>` block. Piping a packet or diff is the preferred transport — it avoids
OS command-line length limits and shell quoting issues:

```bash
git diff | codex exec "Review the diff in the <stdin> block. Do NOT edit files or run mutating commands. Return findings ordered by severity with file/line references, then end with one line: APPROVED / APPROVED WITH CHANGES / CHANGES REQUIRED." -s read-only
```

Two failure modes to avoid:

1. **NEVER combine a pipe with `< /dev/null`** — the redirect wins and discards
   the piped input, so Codex sees only the prompt argument.
2. **ALWAYS close stdin one way or the other in non-TTY shells.** In an
   agent/background shell, `codex exec` with no piped input sees stdin as
   piped-but-open and blocks forever waiting for EOF. This presents as a silent
   multi-minute hang that is easy to misread as a slow review or a queue. Every
   call must either pipe real input or explicitly close stdin: `< /dev/null`
   (bash) or `$null | codex exec ...` (PowerShell). "Just omit the redirection"
   is only safe in an interactive terminal.

On PowerShell, replace `$(cat f)` with `(Get-Content -Raw f)` and pass `-c`
arguments in single quotes (literal in PowerShell), e.g.
`-c 'model_reasoning_effort="medium"'`.

When running from a directory that is not a git repo, add
`--skip-git-repo-check`.

For packet-backed reviews, prefer the clean reviewer flags:

```bash
--disable plugins --disable shell_snapshot --ephemeral
```

`--ephemeral` skips Codex session persistence; use it only when the Markdown
packet plus saved stdout/stderr are the durable record (no `codex exec resume`
for that run).

## Config Gotchas (`service_tier`)

If `codex exec` fails at **config load** (an "unknown variant" error on a key in
`~/.codex/config.toml`), the config file is rejected before any prompt runs and
every codex invocation is blocked.

`service_tier` facts observed with codex-cli 0.125.0:

- The config parser only accepts `"fast"` or `"flex"`. Any other value
  (e.g. `"priority"`, `"default"`) fails config load.
- **`"fast"` works but burns roughly 2x the standard token rate** on the
  default model (more on frontier models). Do not use it as the routine
  unblock — that silently doubles the cost of every review.
- **`"flex"` parses locally but ChatGPT-plan accounts get a server-side
  rejection** (`400 Unsupported service_tier: flex`). Flex (~0.5x rate) is an
  API-key-billing tier.
- **Normal/standard tier = omit the key entirely.** "fast or flex" is only what
  the config parser accepts, not the set of tiers that exists.

Fixes:

- **Permanent:** remove the `service_tier` line from `~/.codex/config.toml`
  (falls back to the account standard tier).
- **Per-call (when the config file cannot be edited yet):** the CLI cannot
  unset a key via `-c`. Point `CODEX_HOME` at a clean copy of the config
  directory — the real `config.toml` minus the `service_tier` line, plus a copy
  of `auth.json` — for that call:

  ```powershell
  $env:CODEX_HOME = "$env:USERPROFILE\.codex-clean"; $null | codex exec "<prompt>" -s read-only -c 'model_reasoning_effort="medium"'
  ```

  Set the env var in the SAME shell invocation as the `codex exec` call if your
  harness does not persist shell state between calls.
- **Do NOT use `--ignore-user-config`** as the unblock — it also drops the
  user's `model=` setting.

Newer codex-cli versions accept arbitrary string tier IDs in config.toml
(legacy `fast` normalizes to `priority`), so upgrading may remove the parse
failure — but server-side tier rejection is independent of CLI version.

## Reasoning-Effort Selection

**Default to `model_reasoning_effort="medium"` for ALL reviews, including
approval gates.** Medium is a strong reviewer and several times faster than
high. If the user's `~/.codex/config.toml` sets `model_reasoning_effort =
"high"`, a plain `codex exec` inherits HIGH — pass medium explicitly on every
call unless you deliberately want high.

**Latency warning:** high effort on a large packet (1,000+ line diff) can take
10-15+ minutes of pure reasoning time. Reserve `high` for the genuinely
exceptional case: a subtle money/data/security boundary where a medium pass
already surfaced something ambiguous, or the user explicitly asks. Run high
reviews in the background and keep the packet small.

### Round-Aware Effort Ladder (re-review rounds are cheap)

The full reasoning spend belongs on **round 1** of a gate, when Codex sees the
plan/diff for the first time. Later rounds of the SAME gate are fix-closure
checks against material it already reviewed — do not pay medium again for them.

- **Round 1 of a gate**: default model, `medium`.
- **Round 2+ of the same gate** (re-review after fixing round-1 findings; the
  packet is the changed hunks + the findings-to-verify list, NOT the full
  diff): drop to `low`. If the delta is small and mechanical (renames, guard
  clauses, copy fixes, test additions), also drop to the mini model.
- **Escalate back to medium** only if a re-review surfaces a genuinely NEW
  finding (not closure commentary on an old one) or a fix touched a
  money/security boundary in a new way.
- **High** stays reserved for the exceptional case above, never for routine
  re-reviews.

The re-review prompt must still demand the one-line verdict and list each prior
finding ID with `FIXED / NOT FIXED / DISPUTED`, so a low-effort pass has a
mechanical checklist instead of an open-ended review task.

## Model Selection

The codex CLI uses the model from the user's config unless `-m <model>` is
passed. Check OpenAI's official Codex models page for current names instead of
hardcoding future model IDs.

- **Default/config model**: approval gates, real diff/plan reviews, anything
  that gates a merge or money path.
- **Mini model** (e.g. the current `-mini` variant; roughly a third of the
  default model's quota burn): sanity checks, log triage, deciding which files
  matter, formatting-level review, second opinions on low-risk diffs, and
  round-2+ mechanical re-reviews per the ladder above.
- **Frontier model**: only when the user explicitly asks for the strongest pass
  on a subtle boundary.

Never silently downgrade an approval-gate review to the mini model. If token
pressure makes a mini-only gate tempting, say so and let the user choose.

## Execution (how to wait without hanging)

`codex exec` is slow and variable — a medium review of a real packet commonly
takes 1-5 minutes with NO incremental output until it finishes. Run it in the
background and let the completion notification wake you; capture stdout/stderr
to files so the run is auditable. Use a generous timeout (300000 ms) for any
blocking call. If a run produces nothing well past its expected time, check
stderr first — an auth/transport error there means it failed fast and is
waiting on nothing.

## Review Packet Convention

Direct `git diff | codex exec ...` is fine for tiny, low-risk reviews. For
approval gates, high-risk work, multi-round loops, or anything with
logs/plans/QA evidence, build a Markdown packet first and pipe it via stdin:

```text
<packet-root>/codex-packets/YYYY-MM-DD-<kebab-slug>/
  prompt.md       # task, approval criteria, exact questions, design/diff content
  manifest.md     # files reviewed + why; branch/base SHA/HEAD when in a git repo
  STATUS.md       # canonical current snapshot (verdict, gate, open findings)
  REVIEW.md       # append-mostly timeline + findings ledger (F-001, F-002...)
  context/        # copied snippets, diffs, logs
  responses/      # numbered Codex responses
  stderr.log      # transport/auth warnings from the latest call
```

`<packet-root>` is `artifacts/` inside a repo, or any scratch directory when
there is no repo. Keep packets free of secrets, `.env` contents, credentials,
tokens, private personal data, and live-money artifacts. Scan and redact logs
and diffs before packetizing — they frequently contain credentials.

For very large reviews, chunk intentionally: review chunks, dedupe findings,
then run a final synthesis approval pass.

## Default Approval Loop

**Verdict contract:** every gated review prompt MUST require Codex to end with
one explicit line — `APPROVED`, `APPROVED WITH CHANGES`, or `CHANGES REQUIRED`
— plus its required-changes list. The loop gates on that line; if Codex omits
it, treat the result as not-yet-approved and re-prompt for the verdict.

When this skill backs implementation work, default to a two-gate loop unless
the user says review-only, plan-only, one-pass, or no-loop:

1. **Plan gate before editing**: send Codex a scoped implementation plan + QA
   plan. If Codex returns required changes or blockers, Claude updates the plan
   and reruns review until APPROVED, or Claude rejects a finding with
   code-backed reasoning. Round 1 at medium; rerun rounds follow the
   round-aware ladder.
2. **Implementation gate**: Claude implements the approved plan. Codex stays
   read-only.
3. **Diff/QA gate after implementation**: Claude runs the planned verification,
   then sends Codex the final diff + command results. Fix in-scope gaps, rerun
   verification, rerun review until approved. The diff gate is a new gate, so
   its round 1 is medium even though the plan gate already approved.

For high-risk work (balances, payments, imports, transactions, schedulers,
money/tax boundaries, production deploys) the loop is mandatory. Use it as a
batch-level gate, not a per-PR ritual.

User interruption overrides the loop. Soft cap: after ~5 non-converging
iterations on one gate, stop and show the user the remaining disagreement.

## Handling Results

Treat Codex output as advisory, not authoritative.

- Verify any concrete claim against the code before editing.
- Ignore suggestions that conflict with repo patterns, user instructions, or task scope.
- Claude owns the final engineering call and may reject a Codex finding with cited code/test/doc/user-constraint evidence — state the rejection plainly and rerun review on the revised rationale rather than silently ignoring it.
- Convert valid findings into Claude-owned edits, then rerun the relevant checks.
- When Claude independently verifies a Codex finding is a real, in-scope defect with a mechanical fix, fix it in the same turn rather than asking permission — but stop and ask first for product, money, data-loss, scope, or public-contract decisions.
- In the final response, mention that Codex was used as a read-only reviewer if its findings materially influenced the work.

## Safety Notes

- Read-only by default (`-s read-only`); never drop it without explicit user direction.
- Pass text into Codex via the prompt; do not grant it write authority over the repo.
- Do not pass secrets, private tokens, `.env` contents, or unrelated personal data.
- Read-only means no writes; it does not mean no data egress. Content passed to the codex CLI may be sent to OpenAI or the provider configured for the user's Codex installation, and may consume their ChatGPT plan quota or purchased credits.
- If Codex output suggests commands, inspect them before deciding whether Claude should run them. Never auto-run a Codex-suggested command.

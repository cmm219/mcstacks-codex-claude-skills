---
name: prd-review-loop
description: Create, review, score, and iterate Product Requirements Documents before design or implementation. Use when Codex is asked to make a PRD, review a PRD, score a PRD, get Claude to review product requirements, prepare requirements for a design loop, or decide whether a PRD is ready to drive engineering or UI work.
---

# PRD Review Loop

## Purpose

Use this skill to produce PRDs that are clear enough to drive design and
implementation without vague flows, fake controls, unsupported backend promises,
or unresolved product contradictions.

Codex owns the PRD and edits. Claude may be used as a read-only reviewer.

## Hard Rules

- Do not treat a first PRD draft as ready.
- Score the PRD before marking it ready.
- Use Claude read-only review when available and the PRD matters enough to guide
  design, engineering, user onboarding, pricing, auth, data, or workflow changes.
- Do not let Claude edit files, run commands, commit, push, deploy, or operate
  services during PRD review.
- Separate product requirements from implementation plans unless the user asks
  for both.
- Call out open questions instead of hiding them in vague acceptance criteria.

## Workflow

### CLI Resolution

Resolve Claude in this order:

1. Use `CLAUDE_CLI_PATH` if set.
2. Use `claude` on `PATH`.
3. If none exists, perform the same review locally and state that Claude review could not be run.

### 1. Gather Context

Read the local source of truth before drafting or reviewing:

- `AGENTS.md`
- `CLAUDE.md`
- `DESIGN.md` when the PRD affects UI
- Existing docs under `docs/`, especially `docs/prd/` and `docs/plans/`
- Current code only where needed to verify current behavior or backend truth

Capture the current state in the PRD. Include what exists today, not only the
desired future.

### 2. Draft Or Normalize The PRD

Use a focused PRD shape:

- Title, status, date, owner, product surface
- Current state
- Problem
- Goals
- Non-goals
- Product vocabulary
- Required flows
- Backend/data/API capabilities and truthfulness constraints when relevant
- UX states: empty, loading, success, error, no-results
- Mobile/responsive requirements when relevant
- Acceptance criteria
- Success metrics when useful
- Open questions

Keep PRDs specific. Prefer decisions over broad option lists. Put unresolved
items in Open Questions.

### 3. Score The PRD

Score before external review and again after revisions.

Score categories:

- Problem clarity
- Goal clarity
- User flows
- Acceptance criteria
- Implementation readiness
- Design-loop readiness
- Backend truthfulness
- Non-technical user friendliness
- Scope discipline
- Overall

Score gate:

- Overall must be at least 9/10 before the PRD is "ready."
- No category should be below 8/10.
- There must be no unsupported or fake product promises.
- Blocking open questions must be resolved or explicitly deferred before the
  PRD drives implementation.

### 4. Claude Read-Only Review

For meaningful PRDs, ask Claude for a second pass. Pipe the PRD text into the
local Claude CLI with strict read-only instructions.

Command shape:

```powershell
$prd = Get-Content -Raw "<path-to-prd.md>"
$claude = if ($env:CLAUDE_CLI_PATH) { $env:CLAUDE_CLI_PATH } else { "claude" }
$prompt = @'
You are reviewing a PRD. Do not edit files. Do not run commands.

Review for product clarity, workflow gaps, implementation ambiguity, UX risks,
backend truthfulness, scope creep, and contradictions.

Return:
1. Findings ordered by severity.
2. A scorecard from 1-10 for: problem clarity, goal clarity, user flows,
   acceptance criteria, implementation readiness, design-loop readiness,
   backend truthfulness, non-technical user friendliness, scope discipline,
   overall.
3. Specific PRD edits you recommend.

PRD:
'@
$prompt + "`n`n" + $prd | & $claude -p
```

If Claude is unavailable, perform the same review locally and state that Claude
review could not be run.

### 5. Revise

Evaluate Claude's findings. Apply only findings that are correct and useful.

Common high-value revisions:

- Add a current-state baseline.
- Pin the primary input contract.
- Enumerate backend capabilities and unsupported controls.
- Resolve preview/demo behavior.
- Define auth or onboarding handoff.
- Pick one location for important actions.
- Replace qualitative acceptance criteria with measurable ones.
- Clarify copy vocabulary for non-technical users.
- Add loading, empty, error, and no-results states.

### 6. Re-Review And Pass/Fail

Run a second review after revisions when the PRD is important or changed
substantially.

Second-pass prompt:

```powershell
$prd = Get-Content -Raw "<path-to-prd.md>"
$claude = if ($env:CLAUDE_CLI_PATH) { $env:CLAUDE_CLI_PATH } else { "claude" }
$prompt = @'
You are re-reviewing a revised PRD. Do not edit files. Do not run commands.

Evaluate whether this PRD is ready to drive design or implementation. Return:
1. Remaining blocking or high-severity findings.
2. The same 1-10 scorecard.
3. Say PASS only if overall >= 9, no category below 8, and no blocking fake,
   unsupported, or contradictory product direction remains.

PRD:
'@
$prompt + "`n`n" + $prd | & $claude -p
```

Mark the PRD ready only if it passes the score gate. If it misses the gate,
either revise again or ask the user to decide on the blocking open questions.

## PRD Score Template

Use this inside the PRD or in the final review note:

```markdown
| Dimension | Score |
|---|---:|
| Problem clarity | x |
| Goal clarity | x |
| User flows | x |
| Acceptance criteria | x |
| Implementation readiness | x |
| Design-loop readiness | x |
| Backend truthfulness | x |
| Non-technical user friendliness | x |
| Scope discipline | x |
| **Overall** | x |
```

## Ready Definition

A PRD is ready when:

- It passes the score gate.
- It states current behavior and desired behavior.
- It defines the primary user flows.
- It names what is out of scope.
- It avoids fake UI/backend promises.
- It has acceptance criteria that can be verified.
- It lists unresolved questions honestly.
- The next skill or agent can use it without inventing product decisions.

## Handoff To Execution

When a PRD is approved for execution, mark the intended implementation as one
batch scope. If the work naturally splits into multiple PRs, say that explicitly
in the PRD or handoff notes.

- Do not imply that each PR needs a fresh user decision when the user has already
  approved the whole PRD/task list.
- Do not require control/session/archive updates after every PR inside the batch.
  Those belong at the end of the approved batch or at a real blocker/handoff.
- Include stop gates for real decisions only: secrets/access, destructive or
  irreversible actions, unclear product/data/money risk, failed production smoke,
  or scope expansion outside the PRD.

# Examples

## Read-only Diff Review

User:

```text
Use claude-readonly-review to review my current diff before I push.
```

Codex:

```bash
git diff | claude --permission-mode plan --tools "" -p "Review this diff..."
```

Claude returns findings. Codex then verifies each finding against the code, implements only valid fixes, and runs checks.

## Frontend Design Critique

User:

```text
Use claude-design-html for a read-only visual critique first.
```

Codex runs the app, captures screenshots when feasible, passes scoped UI context to Claude, reviews the recommendations, and chooses the high-impact fixes.

## Scoped Design Implementation

User:

```text
Use claude-design-html to implement a scoped design polish pass.
```

Codex prepares a branch/worktree or allowed path list, asks Claude to edit only those files, reviews the diff, runs browser QA, and accepts or corrects the work.

## Optional Local Design Skill Artifact

User:

```text
Use claude-design-html with my installed local /design-html workflow to create a design artifact first.
```

Codex asks Claude to use the user's installed local design workflow and write the result to an artifact folder, not directly into production app files. Codex then inspects the artifact, ports the approved design into the app, and QA checks the real app.

This keeps third-party design tooling as a local design-time dependency, similar to Figma or a mockup generator. The shipped app or PR should stand on its own unless the user explicitly wants the artifact committed.

## Optional Design-Enabled Claude Command

User:

```text
Use claude-design-loop with my CLAUDE_DESIGN_CLI wrapper for the artifact and design revisions.
```

Codex resolves `CLAUDE_DESIGN_CLI` for design artifact generation and design revisions, while the default Claude setup remains unchanged. The wrapper is user-maintained and must accept stdin prompts, `-p`, `--permission-mode`, and `--allowed-tools`.

Codex should not edit global Claude settings, enable plugins globally, or interfere with unrelated Claude processes. If the wrapper is missing or fails before a Claude session starts, Codex falls back to the normal Claude resolution path.

## Gated Design Loop

User:

```text
Use claude-design-loop for this dashboard redesign.
```

Expected loop:

1. Claude generates a standalone HTML artifact using an installed local design workflow when available.
2. Codex reviews the artifact and sends focused revisions to Claude until it is reviewable.
3. The user approves the artifact.
4. Claude or Codex implements the approved design in the real app.
5. Codex reviews the diff and runs desktop/mobile browser QA.
6. The user approves shipping.

For data-heavy screens such as tables, dashboards, or queues, Codex should verify the artifact preserves real source links and user-provided data, accounts for default and optional fields, covers expanded and mobile states when relevant, and clearly states that app code has not been implemented before the user approval gate.

## PRD Review Loop

User:

```text
Use prd-review-loop to turn this feature idea into a PRD before we design or implement it.
```

Codex drafts or normalizes the PRD, scores it, uses Claude as a read-only reviewer when useful, applies only valid review findings, and marks it ready only when the score gate passes.

## PR Batching

User:

```text
Use pr-batching to decide whether these changes should be one PR, stacked PRs, or separate PRs.
```

Codex checks whether the work shares one risk surface, one verification story, and one safe revert path. It recommends separate PRs when auth, data, external sends, billing, migrations, deployment, or unrelated refactors would make a combined review unsafe.

## PRD Ship Loop

User:

```text
Use prd-ship-loop to execute this approved PRD. Keep going until the approved scope is complete unless a real stop condition applies.
```

Codex reads the approved scope, plans the execution, implements, verifies, uses Claude review and design gates when required, opens or updates PRs, watches checks, and continues to the next approved item instead of stopping after routine milestones. It stops for real blockers such as missing secrets/access, destructive out-of-scope operations, unclear product/data risk, failed production smoke, or completion.

A current ship token can authorize multiple PRs inside the same approved PRD or task list. Codex should not use it to invent follow-up scope outside that approval.

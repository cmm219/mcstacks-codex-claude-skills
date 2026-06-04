# Setup Modules

Every serious project gets the base setup from [new-project-setup.md](new-project-setup.md). Add modules only when the project needs them.

## Worktree / PR Execution

Use when:

- multiple agents may work concurrently
- the user wants forced PR discipline
- generated files or running services could collide
- risky edits should be isolated from the main checkout

Rules:

- Branch from `origin/<DEFAULT_BRANCH>`, not stale local state.
- Use owner prefixes such as `codex/`, `claude/`, and `human/`.
- Keep task worktrees under `.worktrees/<TASK_SLUG>/`.
- Clean up only after merge is verified.

## High-Risk / Irreversible Operations

Use when the project can affect money, balances, orders, trades, external sends, production data, or other irreversible operations.

Add:

- protected path rules
- read-only investigation before correction
- no live send/write without explicit approval
- append-only audit or ledger rules where relevant
- review packets for correction plans

## External Deploy

Use when the project deploys to a server, cloud service, app host, or device.

Add:

- exact-SHA deploy protocol
- service-specific health checks
- deployed version and SHA verification
- rollback or roll-forward notes

Keep provider names and deployment commands project-specific. Do not make a private deploy target universal.

## Data / DB Safety

Use when the project writes production data, migrations, imports, exports, or correction records.

Add:

- migration plan and rollback notes
- backup/export proof where appropriate
- read-only investigation before data correction
- generated snapshots outside the repo by default unless they are intentional fixtures

## Browser / UI Proof

Use when UI behavior matters.

Add:

- design-system pointer
- browser or Playwright proof requirements
- screenshots or video proof for visual claims
- accessibility and responsive checks when relevant

## Decision Rule

Use the base every time. Add only modules that match the project risk.

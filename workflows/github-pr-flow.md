# GitHub PR Flow

Use this flow for repo work that should be reviewed before landing.

## Branching

- Start from `origin/<DEFAULT_BRANCH>`.
- Use clear branch prefixes:
  - `codex/<TASK_SLUG>`
  - `claude/<TASK_SLUG>`
  - `human/<TASK_SLUG>`
- Do not start from stale local default-branch state.

## PR Lifecycle

```text
branch -> implement -> verify -> commit -> draft PR -> checks -> review -> merge -> cleanup
```

For deployable projects, add exact-SHA deploy verification after merge.

## Batch Mode

When the user approves a broad task list and says to keep going, multiple PRs may belong to one batch. Do not stop after every routine PR if the next approved action is clear.

Stop for secrets/access, destructive operations, unclear product/data/money risk, failed production smoke needing a decision, or completed scope.

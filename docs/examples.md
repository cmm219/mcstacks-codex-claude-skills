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

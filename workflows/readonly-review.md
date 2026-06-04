# Read-only Review Workflow

Use `claude-readonly-review` when Claude should challenge a plan, diff, packet, or QA story while Codex remains the only agent that edits files or operates git.

## Gates

1. Plan gate before implementation.
2. Codex-owned implementation.
3. Verification.
4. Final diff/QA gate.

Claude may return `APPROVED`, `APPROVED WITH CHANGES`, or `BLOCKED`. Codex verifies every concrete claim before editing.

## Packet Pattern

For medium, large, high-risk, or multi-round work, create:

```text
artifacts/claude-packets/YYYY-MM-DD-<slug>/
  manifest.md
  prompt.md
  STATUS.md
  REVIEW.md
  context/
  responses/
```

Do not treat stale packets as approval for a newer diff.

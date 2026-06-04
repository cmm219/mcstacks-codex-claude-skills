# PRD To Ship Workflow

Use this when the user wants a feature or task list carried from requirements through implementation and verification.

## Flow

1. Use `prd-review-loop` to make the scope testable.
2. Use `pr-batching` when review or revert shape is unclear.
3. Use `prd-ship-loop` after the scope is approved.
4. Use `claude-readonly-review` for plan and diff/QA gates when risk justifies it.
5. Keep moving through approved scope until completion or a real stop condition.

## Review Shape

One batch-level plan review can cover multiple PRs when it names the intended slices, risk boundaries, verification, and stop gates. Use focused mid-batch reviews only when a later slice introduces materially new risk.

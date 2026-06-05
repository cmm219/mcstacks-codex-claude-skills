# Auto-Fix Whitelist

Use this whitelist for autonomous fixes during verification or CI.

## Allowed Without Asking

- Formatting, lint, import ordering, unused imports, missing semicolons, obvious syntax errors.
- TypeScript or type errors caused by the current change when the fix is local and behavior-preserving.
- Test selector updates when UI text/labels intentionally changed in the approved scope.
- Snapshot or screenshot expectation updates only when the visual/text change was user-approved and manually inspected.
- Small browser QA script fixes, such as stale selectors or wait conditions.
- Build errors from missing exports/imports introduced by the current change.
- Small review-blocker fixes that stay within the PRD and do not change product direction.
- Project-specific version claim scripts when the repository documents the exact command or process.

## Stop Before Fixing

- Database migrations, schema changes, or backfills.
- Dependency upgrades/downgrades or lockfile churn not already required by the PRD.
- Secret/env var changes, credential setup, payment/billing changes, account permission changes.
- Flaky test suppression, deleting tests, lowering assertions, or disabling CI.
- Broad refactors, architectural rewrites, or moving ownership boundaries.
- Production data mutation outside normal user-visible app workflows.
- Production smoke failures or hotfixes after merge.
- Force-push, hard reset, deleting branches, deleting files/directories recursively unless explicitly requested.

## Iteration Budgets

- CI-fix loop: maximum 3 autonomous fix attempts per PR.
- Claude review-fix loop: maximum 2 autonomous passes per PR.
- Browser QA fix loop: maximum 3 autonomous attempts for the same failing flow.

When a budget is hit, stop and report the current failure, attempted fixes, and recommended next step.

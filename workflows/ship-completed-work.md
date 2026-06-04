# Ship Completed Work

Use this workflow when the implementation already exists as a branch, commit, or local diff and the next job is to verify, review, PR, merge, or smoke test it.

This is not a separate shipping skill. Route the work through `prd-ship-loop` by treating the completed diff as the approved explicit scope.

## Minimal Scope Statement

Before shipping, write or infer a short scope statement:

```markdown
# Completed Work Scope

## Outcome

Ship the existing branch/diff for <feature or fix>.

## In Scope

- Review the current diff.
- Run relevant checks.
- Fix only small issues introduced by this diff.
- Open or update the PR.
- Merge only when the user has authorized shipping and required checks are green.

## Out Of Scope

- New product behavior not already in the diff.
- Dependency upgrades.
- Broad refactors.
- Destructive git commands.
- Secrets, credentials, billing, production data, or deploy changes not declared by the project.

## Verification

- <test/build/lint command>
- <browser or smoke check if relevant>
- Claude read-only review when risk justifies it.
```

## Flow

1. Confirm the branch, base branch, and current diff.
2. Write the minimal scope statement if one does not already exist.
3. Use `prd-ship-loop` with the scope statement and the existing diff.
4. Run the repo's checks and focused QA.
5. Use `claude-readonly-review` for material risk or required second-pass review.
6. Fix only issues caused by the completed work and allowed by the auto-fix boundary.
7. Open or update the PR.
8. Merge only with a current ship token and green required checks.
9. Run deploy/smoke steps only when the project declares exact commands and the user has authorized that target.

## Stop Rules

Stop when the completed work needs new product decisions, broad refactors, dependency changes, secret setup, production data mutation, undeclared deploy commands, destructive git operations, or fixes outside the completed-work scope.

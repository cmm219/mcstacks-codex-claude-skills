# Example Good Run

This example captures the desired shape of a bounded autonomous run.

## Situation

The user approved a PRD for a list-view workflow redesign and said to implement it, keep going, and stop only when actually needed.

## Flow

1. Read project instructions and design system.
2. Confirm PRD tasks and approved design direction.
3. Implement UI/API changes.
4. Run production build.
5. Run browser QA for anonymous, authenticated, and mobile flows.
6. Use Claude read-only review on focused diffs.
7. Fix blocker, high, and medium review findings inside scope.
8. Claim required project version.
9. Commit, push, open PR.
10. Wait for GitHub/Vercel checks.
11. Merge after checks passed because the user gave a current ship token for that PR and scope.
12. Watch production deploy.
13. Run production smoke tests.
14. Stop if production smoke fails, report the failure, and ask whether to revert or roll forward.
15. Create or merge a follow-up PR only after the user re-authorizes that follow-up scope.
16. Final report with PRs, checks, production QA, remaining notes.

## Correct Stops

- Stop for design signoff if design loop requires it.
- Stop if production smoke exposes ambiguous product behavior.
- Stop if production smoke fails, even when the fix appears simple.
- Stop at end-of-scope with a clear report.

## Incorrect Stops

- Asking whether to run build.
- Asking whether to run browser QA.
- Asking whether to address obvious review blockers.
- Stopping after opening PR instead of waiting for checks.
- Stopping after merge instead of verifying deploy and production smoke.

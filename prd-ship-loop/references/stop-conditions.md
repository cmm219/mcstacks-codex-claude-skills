# Stop Conditions

Stop and ask the user only when one of these applies.

## Approval Gates

- A design skill, review skill, PRD, or user instruction explicitly requires user approval.
- UX/design HTML preview needs signoff before implementation.
- The user has not given a current ship token for merging/deploying the approved workflow.
- The user has only activated the skill or approved implementation, but has not explicitly authorized merge/deploy for the approved workflow.
- The work materially changed from the original approved scope, or a follow-up PR is needed that is outside the approved PRD/task list.

## Scope Or Requirements

- The PRD/task list conflicts with current project behavior or newer user instructions.
- Implementation requires a product decision not derivable from the approved scope.
- A necessary requirement is missing, impossible, or materially more expensive/risky than expected.
- The requested work would expand into unrelated refactor, redesign, migration, or architecture changes.

## Safety And Access

- Destructive or irreversible operations are needed.
- Secrets, credentials, billing/payment, account ownership, or production data access is needed and cannot be safely inferred.
- Schema changes, data migrations, data deletion, force-push, branch deletion, or destructive filesystem operations are needed.
- Production writes outside normal app workflow are needed.

## Review And Verification

- Claude read-only review reports a high-severity blocker that is not obviously fixable inside scope.
- Claude and Codex disagree on a material security, privacy, architecture, product, or data-risk decision.
- Required tests/checks fail for a reason outside the auto-fix whitelist.
- CI-fix loop hits the iteration budget.
- Production smoke fails. Always stop, report the failure, and propose revert vs. roll-forward options.
- A required sibling skill such as `claude-readonly-review` or `claude-design-loop` is unavailable when its gate is required.

## Completion

- The approved task list or PRD batch is complete, deployed when requested, smoke tested, and any end-of-batch control/memory updates are filed.
- A blocker prevents safe progress. Report what is done, what is blocked, and the next decision needed.

## Not Stop Conditions

- Need to run tests, build, typecheck, lint, or browser QA.
- Need to inspect files, logs, PR checks, deployment status, or production smoke output.
- Need to fix formatting, imports, obvious type errors, selector mismatches, or small review blockers inside scope.
- Need to commit, push, open/update a draft PR, or wait for checks.
- Need to mark a PR ready, merge, or deploy when shipping was explicitly authorized for the approved workflow scope.
- Need to start the next branch/PR inside the approved PRD/task list after the previous PR merged.
- Need to defer control/session/archive updates until the full approved batch is done.

# McStacks Workflows

Workflows explain how McStacks skills compose into repeatable loops.

## Core Loops

| Workflow | Primary Skill | When To Use |
| --- | --- | --- |
| Read-only review | `claude-readonly-review` | A second model should challenge a plan or diff before Codex acts. |
| Design artifact loop | `claude-design-loop` | UI work needs a separate artifact approval before app implementation. |
| PRD review | `prd-review-loop` | A feature idea needs requirements before implementation. |
| PR batching | `pr-batching` | Work may need one PR, stacked PRs, or split PRs. |
| PRD ship loop | `prd-ship-loop` | An approved PRD or task list should be implemented through verification. |
| New project bootstrap | [`new-project-bootstrap.md`](new-project-bootstrap.md) | A serious project needs startup files, control pointers, and setup modules. |
| GitHub PR flow | [`github-pr-flow.md`](github-pr-flow.md) | Repo work should branch from origin, verify, PR, merge, and clean up deliberately. |
| Worktree PR module | [`worktree-pr-module.md`](worktree-pr-module.md) | Concurrent or risky repo work needs isolated execution. |

## Default Sequence

1. Define the approved scope.
2. Pick the workflow skill.
3. Use `brain/` routing only for relevant prior knowledge or public-safe templates.
4. Run Claude read-only gates when the workflow calls for second-model review.
5. Codex implements, verifies, and owns final judgment.
6. Stop only for real blockers, risky approvals, or completed scope.

## Batch Autonomy

When the user approves a broad scope and says to keep going, the batch covers the whole approved list. Do not stop after each routine branch, PR, review, or smoke test just to ask what next.

Stop for secrets, access, destructive out-of-scope operations, unclear product/data/money impact, conflicting instructions, failed production smoke that needs a rollback choice, or completion.

# McStacks Workflows

Workflows explain how McStacks skills compose into repeatable loops.

## McStacks Loop

McStacks follows a small loop instead of a large command catalog:

```text
Scope -> Review -> Implement -> Verify -> Ship -> Capture
```

- Scope: define the approved work, risk boundary, and stop gates.
- Review: use Claude as read-only review or planning input before risky implementation.
- Implement: Codex owns edits, repo state, and integration decisions.
- Verify: run the relevant checks, QA, smoke tests, and second-pass review.
- Ship: use the repo's PR, merge, deploy, and smoke workflow when authorized.
- Capture: record only public-safe templates, follow-ups, and durable lessons.

## Core Loops

| Workflow | Primary Skill | When To Use |
| --- | --- | --- |
| Read-only review | `claude-readonly-review` | A second model should challenge a plan or diff before Codex acts. |
| Design artifact loop | `claude-design-loop` | UI work needs a separate artifact approval before app implementation. |
| Claude-to-Codex handoff | [`codex-handoff-packet`](claude-to-codex-handoff.md) | Claude has a proposed task, but Codex must verify it before repo work. |
| PRD review | `prd-review-loop` | A feature idea needs requirements before implementation. |
| PR batching | `pr-batching` | Work may need one PR, stacked PRs, or split PRs. |
| PRD ship loop | `prd-ship-loop` | An approved PRD or task list should be implemented through verification. |
| Ship completed work | [`ship-completed-work.md`](ship-completed-work.md) | A branch or diff already exists and needs scoped verification, PR, and merge flow. |
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

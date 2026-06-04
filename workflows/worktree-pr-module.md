# Worktree PR Module

Worktrees are execution isolation. They are not project memory.

Use this module when concurrent agents, risky edits, generated files, or running services could collide.

## Shape

```text
<REPO_ROOT>/
  .worktrees/
    <TASK_SLUG>/
```

## Rules

- Main checkout stays on `<DEFAULT_BRANCH>`.
- Task worktrees branch from `origin/<DEFAULT_BRANCH>`.
- One task per worktree.
- One branch owner prefix per agent.
- Cleanup happens only after the PR is merged and the worktree is clean.
- Protected worktrees must be configured, not hardcoded.

## Script Roles

If a project adopts helper scripts, they should cover:

- start task worktree
- list worktrees
- check worktree hygiene
- open draft PR from explicit files
- finish task worktree after merge
- sync main after merge

McStacks documents the roles here. Script bodies should be added only after separate public-safety review.

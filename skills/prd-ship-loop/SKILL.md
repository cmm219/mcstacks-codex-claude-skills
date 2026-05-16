---
name: prd-ship-loop
description: Execute an approved PRD or task list through bounded implementation, review, PR, deployment checks, and smoke QA without stopping for routine soft questions. Use when the user says to run the PRD loop, ship an approved PRD, execute an approved task list, keep going through routine verification, merge when green, or deploy this approved work. Coordinates Claude read-only review and design approval gates while Codex remains responsible for edits, tests, git, PRs, deploy verification, and final reporting.
---

# PRD Ship Loop

## Purpose

Use this skill to turn an approved PRD or task list into a shipped result with bounded autonomy. Keep working through routine execution steps; stop only for real approval gates, unresolved ambiguity, safety risk, or completed scope.

This skill does not override project instructions, `CLAUDE.md`, `AGENTS.md`, repo guardrails, user safety requirements, or other active skills. When a project rule conflicts with this skill, follow the stricter rule.

## Required Inputs

Before entering the loop, identify:

- Approved PRD, task list, issue, or explicit user scope.
- Current repository/project instructions.
- Verification expectations: build/tests, browser QA, smoke checklist, deploy target.
- Review expectations: whether `claude-readonly-review` is required, and whether UX/design requires `claude-design-loop`.
- Ship token for the approved workflow if merge/deploy is expected. Skill activation is not a ship token. Acceptable ship tokens must explicitly authorize shipping, such as "ship it", "merge when green", "deploy this", "keep going until deployed", "finish the PRD", "do it all", "don't stop unless you need me", or equivalent current-turn approval.

A ship token is valid for the current approved scope, which may include multiple branches/PRs when the PRD/task list naturally decomposes that way. Do not stop after each PR just because a branch merged. Scope changes outside the approved PRD/task list, material rework that changes product/data risk, or a production-smoke failure requiring rollback vs. roll-forward choice require a fresh user decision.

If there is no smoke checklist, create a minimal one from the PRD and affected surfaces before implementation. If the checklist requires product judgment that is not inferable, stop and ask.

## Core Loop

Load `references/good-run.md` when you need a concrete example of the intended run shape.

1. Read the PRD/task list and relevant project instructions.
2. Make a concise execution plan with explicit stop gates.
3. Implement approved tasks without pausing for routine choices.
4. Run required verification: unit/type/build checks, browser QA for UI/workflows, and project-specific checks.
5. Fix failures that are within scope and covered by the auto-fix whitelist.
6. Use `claude-readonly-review` for required second-pass review or material risk checks.
7. If UX/design is involved, use `claude-design-loop` and stop at its user approval gates.
8. Address blocker, high, and medium review findings that stay inside scope; log low-severity or out-of-scope items as follow-ups.
9. Commit, push, open/update PR, and wait for checks when shipping is approved for this workflow.
10. Fix CI only within iteration limits and whitelist rules.
11. Merge only with a current ship token and green required checks.
12. Watch deployment and run production smoke checks.
13. If the approved PRD/task list still has more items, continue to the next item instead of stopping after the PR/deploy.
14. Stop with a final report only when the approved batch scope is complete or a real stop condition is reached.

## Do Not Soft-Stop For

Continue without asking when the action is a normal part of the approved workflow:

- Running tests, build, typecheck, lint, or formatting.
- Starting local dev server for QA.
- Running browser QA after frontend/workflow changes.
- Applying small fixes for obvious build/test failures.
- Addressing actionable Claude review blockers that stay in scope.
- Claiming a project version when required by repo policy.
- Committing, pushing, opening a PR, and waiting for checks.
- Re-running failed checks after an in-scope fix.
- Watching deployment and smoke testing production.
- Merging one PR and continuing to the next PR/task inside the approved PRD or task list.
- Deferring control/session/archive updates until the full approved batch is complete.

## Mandatory Stop Conditions

Load `references/stop-conditions.md` when deciding whether to stop. If any stop condition applies, pause and report the exact blocker plus the smallest set of choices needed from the user.

## Auto-Fix Boundaries

Load `references/auto-fix-whitelist.md` before fixing CI/test failures autonomously. Stay inside the whitelist and iteration limits.

## Review And Design Gates

- Use `claude-readonly-review` as an advisory reviewer. Codex owns edits, verification, commits, pushes, deploys, and final decisions.
- Use `claude-design-loop` for UI/UX design work that needs design artifacts, HTML previews, scoring loops, or user signoff.
- Do not let a Claude review expand scope. Fix blocker, high, and medium findings that stay inside the PRD; record low-severity, non-blocking, or out-of-scope suggestions as follow-ups unless they are trivial and clearly inside the PRD.
- If Claude and Codex disagree on a material product, security, data, or architecture decision, stop and present the disagreement.

## Git And Shipping Rules

- Never use destructive git commands unless the user explicitly requests them.
- Preserve unrelated user changes.
- Use a branch unless the project already has a current working branch for this task.
- Open PRs as draft until implementation, required verification, and required review gates are complete.
- Merge when there is a current ship token for the approved workflow, required checks are green, and no stop condition remains.
- After merge, verify deployment status and run the smoke checklist.
- After merge, continue opening/merging follow-up PRs that are still inside the approved PRD or task list scope. Do not open or merge follow-up PRs outside that approved scope without a fresh user decision.

## Status Updates

Give short progress updates at major phase transitions: implementation start, verification start, review requested, PR opened, checks green/failing, merge, deploy, smoke results. Do not convert these updates into permission requests unless a stop condition applies.

## Final Report

Include:

- What shipped or what blocked.
- PR/deploy links when available.
- Verification performed.
- Claude/design reviews used and material outcomes.
- Production smoke result.
- Remaining follow-ups or risks.

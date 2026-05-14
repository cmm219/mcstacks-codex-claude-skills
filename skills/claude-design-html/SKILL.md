---
name: claude-design-html
description: Use the user's local Claude Code CLI as a bounded frontend design partner for visual critique, design-html mockups, React/Tailwind UI polish, dashboards, landing pages, portfolio/demo polish, and implementation passes where Claude may write scoped design files while Codex remains responsible for plan review, diff review, integration, browser QA, tests, commits, pushes, and deployments.
---

# Claude Design HTML

## Purpose

Use Claude Code for frontend design critique or implementation while keeping Codex as the repository owner and QA gate.

Default collaboration model: Claude is the preferred builder for frontend visual/design work after Codex approves the plan. Codex handles repo setup, non-design implementation, integration, QA, and final shipping. Claude's plan and diff are drafts until Codex reviews and accepts them.

## CLI Resolution

Resolve Claude in this order:

1. Use `CLAUDE_CLI_PATH` if set.
2. Use `claude` on `PATH`.
3. If neither exists, tell the user to install Claude Code or set `CLAUDE_CLI_PATH`.

## Modes

- **Critique mode**: Claude reviews UI/UX/design read-only.
- **Design implementation mode**: Claude writes only explicitly scoped frontend/design files.
- **Hybrid mode**: Codex implements non-design behavior, data, plumbing, tests, and repo mechanics; Claude implements the visual/frontend layer; Codex then reviews, integrates, and verifies the result.

If the request is ambiguous, default to critique mode and ask before granting write scope.

## Control Boundary

Codex owns:

- Repo state, branch/worktree setup, and dirty-worktree inspection.
- Scope definition and the prompt sent to Claude.
- Review and approval of Claude's design plan before implementation starts.
- Diff review after Claude writes.
- Browser QA, screenshots, tests, commits, pushes, PRs, and deployments.

Claude may:

- Produce visual critiques, design plans, and copy suggestions.
- Create static HTML/CSS design artifacts in an explicitly named folder such as `design-html/`.
- Edit explicitly scoped frontend files when Codex has prepared a branch/worktree or sandbox and the user asked for Claude to implement.

Claude must not:

- Commit, push, deploy, open PRs, or rewrite git history.
- Touch secrets, `.env*`, credentials, deployment config, backend business logic, migrations, package files, lockfiles, or unrelated files unless Codex explicitly includes them in scope.
- Run destructive commands.

The path restrictions in Claude prompts are prompt-level instructions. The actual filesystem boundary is whatever directory and `--add-dir` access Claude Code has. Prefer running Claude from a dedicated worktree or generated artifact folder, then have Codex reject any out-of-scope diff.

## Workflow

1. Read project instructions first, especially `AGENTS.md`, design docs, Tailwind theme files, shadcn/component config, and existing UI patterns.
2. Inspect the current UI or relevant files. For visual work, run the app and capture screenshots when feasible.
3. Ask Claude for a design plan when the design direction is non-trivial.
4. Review Claude's plan as Codex. Reject generic, risky, off-brand, over-scoped, or behavior-changing ideas.
5. Prepare mechanical scoping: a dedicated worktree/branch, a `design-html/` artifact folder, or an explicit allowed path list.
6. If the task includes non-design work, Codex implements or prepares that first.
7. Run Claude for the frontend/design implementation pass with the approved scope.
8. Inspect `git diff` and reject unrelated or risky changes.
9. Review the rendered UI as Codex. Fix or reject changes that introduce regressions, poor responsiveness, visual clutter, accessibility problems, or mismatch with the approved plan.
10. Run relevant checks: lint/build/tests plus browser QA or screenshot comparison when feasible.
11. Summarize what Claude proposed, what Claude changed, and what Codex accepted, corrected, or rejected.

## Critique Prompt

```powershell
claude --permission-mode plan --allowed-tools Read,Grep,Glob -p "You are reviewing this frontend as a portfolio/demo product. Do not edit files. Do not run mutating commands. Focus on first impression, visual hierarchy, spacing, typography, color, responsive behavior, demo readiness, accessibility, and amateur-looking rough edges. Return the top actionable issues ordered by impact, exact fixes, and what is good enough to leave alone."
```

## Design Implementation Prompt

Before running implementation mode, make sure Claude's write scope is explicit. Include only the Codex-approved parts of Claude's plan.

```powershell
claude --permission-mode acceptEdits -p "Codex has approved a scoped frontend design pass. You may edit files only in these paths: <allowed paths>. Do not commit, push, deploy, install dependencies, edit secrets, edit lockfiles, change backend/business logic, or touch unrelated files. Improve the visual design and UX while preserving behavior. Focus on professional portfolio/demo quality, layout, spacing, typography, color, responsive behavior, component polish, and screenshot/video readiness. After editing, summarize changed files and assumptions."
```

## Hybrid Prompt Pattern

```powershell
claude --permission-mode acceptEdits -p "Codex has prepared the non-design implementation and is handing you only the frontend design layer. You may edit files only in these paths: <allowed paths>. Do not change business logic, data contracts, backend code, tests unrelated to visual output, package files, lockfiles, secrets, git state, or deployment config. Improve the visual design and UX of the existing implementation while preserving behavior. After editing, summarize changed files and any assumptions."
```

## Acceptance Criteria

Accept Claude's design work only if:

- The diff stays inside scope.
- Existing app behavior remains intact.
- The UI looks better in actual browser screenshots, not just in code.
- Responsive layouts avoid overlap, clipped text, and unreadable controls.
- The work matches the app's domain and current design system.
- Verification commands pass or any failures are understood and reported.

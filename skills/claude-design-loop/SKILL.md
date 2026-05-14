---
name: claude-design-loop
description: Orchestrate a gated design-to-implementation loop using Claude Code and an optional installed local design artifact workflow such as /design-html. Use when the user wants Claude to plan and generate a standalone HTML design artifact, Codex to review it, the user to approve it, Claude or Codex to implement the approved design in the app, Codex to QA the implementation, and the user to approve shipping.
---

# Claude Design Loop

## Purpose

Use this skill when the user wants a strict approval loop for design-heavy frontend work:

1. Claude creates a design plan and standalone HTML artifact.
2. Codex reviews the plan and artifact.
3. The user approves the artifact or requests changes.
4. Claude implements the approved design in the app, or Codex ports it if safer.
5. Codex reviews the implementation and runs QA.
6. The user gives final approval before shipping.

Codex remains the coordinator and quality gate. Claude may generate designs and code, but Codex decides what is accepted, what needs revision, and what gets tested.

## CLI Resolution

Resolve Claude in this order:

1. Use `CLAUDE_CLI_PATH` if set.
2. Use `claude` on `PATH`.
3. If neither exists, tell the user to install Claude Code or set `CLAUDE_CLI_PATH`.

If the workflow references `/design-html`, that slash command must already exist in the user's local Claude Code environment. This skill does not bundle or redistribute third-party design skills.

## Hard Rules

- Do not implement app code until the user explicitly approves the standalone HTML artifact.
- Do not skip standalone HTML signoff for design-heavy changes.
- Do not let Claude commit, push, deploy, merge, rewrite git history, or mutate production systems.
- Treat Claude output as advisory until Codex verifies it against the repo and rendered app.
- Preserve existing repo design rules, especially `AGENTS.md`, `CLAUDE.md`, and `DESIGN.md` when present.
- Validate rendered UI after implementation with browser automation when feasible.
- Require final user approval before commit, push, deploy, or release unless the user explicitly already requested that shipping action.

These rules are enforced by Codex workflow, scoped worktrees/folders, restricted Claude tools where possible, and post-run diff review. Prompt text alone is not a sandbox.

## Workflow

### 1. Gather Context

Read project instructions first:

- `AGENTS.md`
- `CLAUDE.md`
- `DESIGN.md`
- Current screen/component files
- User-provided screenshots, notes, or target examples

Capture current rendered screenshots before asking Claude when practical. Use the app's local dev server and safe test account if needed.

### 2. Ask Claude For A Plan And HTML Artifact

Prefer a non-app-mutating first pass. Claude may use an installed local design workflow such as `/design-html`, but it must write a standalone artifact only.

Prompt shape when the user has an installed `/design-html` workflow:

```text
/design-html

You are designing <screen name> for <project>.

Goal:
<plain-language user goal>

Current problems:
<bulleted list from user/Codex review>

Design constraints:
- Follow the repo's AGENTS.md, CLAUDE.md, DESIGN.md, and existing design system where present.
- Produce a standalone HTML artifact for review first.
- Do not modify application code yet.
- Optimize for workflow clarity and professional product quality.
- Include desktop and mobile states or responsive behavior notes.

Output expectations:
- Brief plan.
- Standalone HTML artifact path.
- Notes on the intended app implementation approach after approval.
```

Fallback prompt shape when no local `/design-html` workflow is installed:

```text
Create a standalone HTML design artifact for <screen name> in <project>.

Goal:
<plain-language user goal>

Current problems:
<bulleted list from user/Codex review>

Design constraints:
- Follow the repo's AGENTS.md, CLAUDE.md, DESIGN.md, and existing design system where present.
- Produce a standalone HTML artifact for review first.
- Do not modify application code yet.
- Optimize for workflow clarity and professional product quality.
- Include desktop and mobile states or responsive behavior notes.

Output expectations:
- Brief plan.
- Standalone HTML artifact path.
- Notes on the intended app implementation approach after approval.
```

Command shape, PowerShell:

```powershell
$prompt | claude --permission-mode acceptEdits --allowed-tools Read,Write,Edit,Grep,Glob -p
```

Command shape, macOS/Linux:

```bash
cat <<'PROMPT' | claude --permission-mode acceptEdits --allowed-tools Read,Write,Edit,Grep,Glob -p
<prompt text>
PROMPT
```

If slash commands do not work through non-interactive Claude CLI, tell the user to run Claude interactively in the repo and paste the same prompt:

```bash
claude
```

### 3. Codex Reviews The HTML Before User Signoff

Find the generated artifact path from Claude's output. Open or render the HTML locally.

Review:

- Does it explain the workflow before showing controls?
- Is the primary action obvious?
- Is the page still an app workflow, not a marketing page?
- Does it match repo design tokens and tone?
- Does mobile work without clipping or awkward ordering?
- Are there misleading promises, fake functionality, or dead controls?
- Is the design feasible to port into the actual app without changing unrelated behavior?

If the artifact is not good enough, send a concise review back to Claude for revision:

```text
Review of your design artifact:

Keep:
- ...

Fix:
- ...

Reasoning:
- ...

Please revise only these issues. Preserve the approved direction unless a fix requires a small layout adjustment.
```

Repeat until Codex believes the artifact is ready for user review.

### 4. Get User Approval

Show the user:

- The HTML artifact path or local preview URL.
- Screenshots if available.
- A short Codex judgment: approve, approve with notes, or reject.

Ask for explicit approval before app implementation.

Accept phrases like:

- "approved"
- "implement this"
- "looks good, build it"

If the user asks for changes, send the notes back to Claude and repeat artifact review.

### 5. Implement The Approved Design

After approval, implementation can happen in either lane:

- **Claude implementation lane**: Claude edits only the necessary app files under a scoped branch/worktree/path list.
- **Codex implementation lane**: Codex ports the HTML artifact into the app when that is safer, simpler, or better aligned with repo patterns.

Claude implementation prompt:

```text
Implement the approved design in this repo.

Approved HTML artifact:
<absolute or repo-relative path to artifact>

Target app surface:
<route/component>

Rules:
- Follow AGENTS.md, CLAUDE.md, DESIGN.md, and existing app patterns.
- Edit only the necessary app files.
- Do not commit, push, deploy, rewrite git history, or change unrelated files.
- Do not edit secrets, package files, lockfiles, backend logic, migrations, or deployment config unless explicitly included in scope.
- Preserve existing data/API behavior unless explicitly required by the approved design.
- Return changed file paths and risks.
```

Command shape, PowerShell:

```powershell
$prompt | claude --permission-mode acceptEdits --allowed-tools Read,Write,Edit,Grep,Glob -p
```

Command shape, macOS/Linux:

```bash
cat <<'PROMPT' | claude --permission-mode acceptEdits --allowed-tools Read,Write,Edit,Grep,Glob -p
<prompt text>
PROMPT
```

The path restrictions are prompt-level instructions, not a hard sandbox. The examples restrict Claude tools to avoid Bash-based commit/push/deploy commands, but Codex must still prefer a dedicated branch/worktree and reject out-of-scope diffs afterward.

### 6. Codex Review And QA

Codex reviews before finalizing:

- Inspect `git diff`.
- Check for unrelated changes.
- Verify copy is truthful.
- Verify accessibility basics: labels, heading order, keyboard controls, contrast where feasible.
- Run the repo's build/test/lint commands.
- Run browser QA for desktop and mobile when feasible.

If issues are found, Codex may fix small issues directly or send focused review notes back to Claude for revision.

### 7. Final User Review

Show:

- What changed.
- Build/test status.
- Screenshots of the implemented app when feasible.
- Remaining risks.

Ask for final approval before commit, push, deploy, or release unless the user already explicitly requested that shipping action.

## What Good Looks Like

For workflow screens, a good result:

- Starts with what will happen, not just form controls.
- Uses one obvious primary action.
- Makes defaults visible and understandable.
- Separates required inputs from optional advanced filters.
- States where results go.
- Sets honest expectations for runtime and incomplete results.
- Works for non-technical users without unnecessary startup/software jargon.

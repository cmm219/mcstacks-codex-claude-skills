# New Project Setup

Use this guide to bootstrap a serious project with McStacks-style control, review, and release discipline.

The goal is not to add ceremony. The goal is to make future agent sessions fast, safe, and easy to resume.

## Base Setup

Every serious project should start with:

- Repo `AGENTS.md`.
- Repo `CLAUDE.md` when Claude Code will be used.
- Public or private project memory folder.
- `control/STATE.md`.
- `control/TASKS.md`.
- `control/CODEX_GUARDRAILS.md`.
- `sessions/`.
- `tasks/backlog.md`.
- `tasks/audits/`.
- `tasks/archive/`.
- `reference-version-history.md`.
- `VERSION` and `CHANGELOG.md` when the repo ships PRs or releases.
- Short startup files that point to detail instead of carrying history.

## Bootstrap Flow

1. Create the repo.
2. Choose `<DEFAULT_BRANCH>`.
3. Create project memory/control files.
4. Add startup files with the smallest useful routing brief.
5. Decide which setup modules apply.
6. Add version/changelog discipline if the repo ships PRs.
7. Add PR/worktree isolation only when concurrent or risky work requires it.
8. Run the scaffold checks available for the project.

For shared repo adoption, see [`team-mode.md`](team-mode.md).
For projects that need local audit scripts, runtime registries, and release
version checks, see [`project-control-scripts.md`](project-control-scripts.md).

## Copy The Public Templates

Use the files in [`../brain/templates/`](../brain/templates/) as the public-safe skeleton. Copy the shape, then replace placeholders with the new project's values.

Suggested mapping:

| Source Template | Target |
| --- | --- |
| [`brain/templates/state.md`](../brain/templates/state.md) | `control/STATE.md` |
| [`brain/templates/tasks.md`](../brain/templates/tasks.md) | `control/TASKS.md` |
| [`brain/templates/guardrails.md`](../brain/templates/guardrails.md) | `control/CODEX_GUARDRAILS.md` |
| [`brain/templates/session-note.md`](../brain/templates/session-note.md) | `sessions/YYYY-MM-DD-topic.md` |
| [`brain/templates/backlog.md`](../brain/templates/backlog.md) | `tasks/backlog.md` |
| [`brain/templates/review-packet.md`](../brain/templates/review-packet.md) | `tasks/audits/<topic>-review.md` |
| [`brain/templates/project-memory.md`](../brain/templates/project-memory.md) | project memory starter |

Optional control-and-release scripts live in
[`brain/templates/project-control/`](../brain/templates/project-control/). Use
them when a project needs repeatable local session logging, runtime registry
checks, version claiming, and scaffold hygiene checks.

Minimal startup pointer for repo `AGENTS.md`:

```markdown
# AGENTS.md

Before answering project-memory, resume, planning, or prior-decision questions, read:

- `control/STATE.md`
- `control/TASKS.md`
- `control/CODEX_GUARDRAILS.md`

Use live repo search for implementation truth. Keep startup context small. Do not publish secrets, credentials, private notes, transcripts, or local absolute paths.
```

## Agent-Assisted Handoff Prompt

```text
Set up this project using the McStacks serious-project standard.

Project values:
- Project name: <PROJECT_NAME>
- Default branch: <DEFAULT_BRANCH>
- Repo root: <REPO_ROOT>
- Notes/control root: <NOTES_ROOT>

Create short startup files, project control files, task folders, version/changelog files when needed, and public-safe guardrails. Use placeholders until real values are known. Do not copy prior project names, private paths, logs, transcripts, credentials, ports, service names, or deploy targets. Keep startup context small and put detailed history in sessions, archive, backlog, or reference docs.
```

## What Not To Copy

- Prior project names.
- Private notes paths.
- Session transcripts.
- Logs.
- Credentials.
- Hostnames, service names, ports, or deploy targets.
- Live-system or money-moving details.

Copy the shape. Rewrite the content for the new project.

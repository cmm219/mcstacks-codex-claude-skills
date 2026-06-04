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

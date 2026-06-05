# Team Mode

Use this guide when a project wants McStacks conventions shared across a repo or team.

This is documentation only. McStacks does not auto-commit, auto-update, or vendor private memory into a project.

## Required Or Optional

Choose one adoption level:

| Mode | Use When | Repo Change |
| --- | --- | --- |
| Required | Every agent session should follow McStacks routing and safety rules. | Add repo `AGENTS.md` and optional `CLAUDE.md` snippets that point to McStacks. |
| Optional | McStacks is helpful but not mandatory for every contributor. | Add a short note in repo docs or onboarding. |

## Repo `AGENTS.md` Snippet

```markdown
## McStacks

Use McStacks for Codex-owned implementation, verification, PR, and shipping workflows.

Start by reading:

- `control/STATE.md`
- `control/TASKS.md`
- `control/CODEX_GUARDRAILS.md`

Use live repo search for implementation truth. Keep private memory private. Treat Claude output as review input until Codex verifies it. Stop before secrets, destructive commands, production data mutation, money movement, account changes, or unclear product/data risk.
```

## Optional `CLAUDE.md` Snippet

```markdown
## McStacks Handoff

When Claude has a proposed implementation task for Codex, write a Codex Handoff Packet instead of operating the repo directly.

Packet fields:

- Requested outcome
- Scope
- Evidence
- Proposed task
- Risk level
- Permissions requested
- Verification ask
- Stop conditions
```

## Public Templates

Use the public templates in [`../brain/templates/`](../brain/templates/) as starting points:

- `state.md` -> `control/STATE.md`
- `tasks.md` -> `control/TASKS.md`
- `guardrails.md` -> `control/CODEX_GUARDRAILS.md`
- `session-note.md` -> `sessions/YYYY-MM-DD-topic.md`
- `backlog.md` -> `tasks/backlog.md`
- `review-packet.md` -> `tasks/audits/<topic>-review.md`
- `project-memory.md` -> project memory starter

These are public skeletons. Do not copy private notes, transcripts, credentials, local absolute paths, client names, production hostnames, or live-system details into public repos.

## Install Expectation

Each user should install McStacks locally:

Windows PowerShell:

```powershell
powershell -ExecutionPolicy Bypass -File .\setup.ps1
```

macOS / Linux:

```bash
bash setup.sh
```

If the project wants to document McStacks without vendoring it, link to the public repo instead of copying the skill folders.

## Not Included

Team mode does not currently include:

- auto-update behavior
- repository vendoring
- automatic commits
- required CI enforcement
- deploy setup
- private memory sync

Add those only through separately reviewed changes when the project has a concrete need.

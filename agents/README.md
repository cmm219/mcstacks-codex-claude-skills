# McStacks Agents

McStacks is built around explicit agent roles.

## Codex

Codex owns:

- Repo state and working tree.
- Scope control.
- File edits.
- Test, build, and browser QA commands.
- Git commits, pushes, PRs, merges, and deploys when authorized.
- Final engineering judgment.

## Claude Code

Claude may help as:

- Read-only reviewer.
- Planning challenger.
- Frontend design partner in scoped design workflows.
- Artifact generator when explicitly allowed.
- Handoff packet author when Claude has a proposed task for Codex.

Claude output is untrusted input until Codex verifies it.

## User

The user owns:

- Product intent.
- Approval for risky or irreversible actions.
- Secrets and account access.
- Public/private boundary decisions.
- Final taste calls when design direction matters.

## Shared Contract

- Keep private memory private.
- Pass the smallest useful context.
- Treat model output as review input, not authority.
- Verify before shipping.

## Porting Guard

When adapting private project setup, notes, or skills into McStacks:

- Copy the structure, not the private content.
- Replace local paths with placeholders.
- Strip private project names, service names, ports, transcripts, logs, and deploy targets.
- Stop if a useful private detail cannot be safely generalized.

# Guardrails Template

Use this for durable checks an agent should remember every session.

## Always

- Read `control/STATE.md` and `control/TASKS.md` before project-memory answers.
- Use live repo search for implementation truth.
- Keep startup context small.
- Verify before claiming done.
- Preserve user changes.

## Never

- Publish secrets, credentials, private notes, transcripts, or local absolute paths.
- Run destructive commands without explicit approval.
- Touch another agent's branch, worktree, or PR.
- Copy prior project names into a new project.

## Project-Specific Checks

- Check:
- Check:
- Check:

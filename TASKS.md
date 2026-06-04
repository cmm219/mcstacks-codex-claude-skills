# Tasks

## Planned

- Build a Claude-to-Codex trigger workflow.

  The current `claude-readonly-review` skill is for Codex to call Claude as a read-only reviewer. McStacks should also define the reverse path: a safe workflow or skill that lets Claude trigger Codex for repo-owned implementation, verification, git, PR, and shipping work without giving Claude direct authority over those actions.

  Requirements:
  - Preserve the Codex-owned working-tree boundary.
  - Make Claude's request an explicit handoff packet, not an instruction stream.
  - Include scope, evidence, proposed task, risk level, and stop conditions.
  - Require Codex to verify the request before editing or running commands.
  - Document when the reverse trigger is useful versus when the user should talk to Codex directly.

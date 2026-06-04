# Tasks

## Planned

- Update the public `claude-readonly-review` skill from the latest exported full version.

  Source reference:
  `C:/Users/Cmcna/Documents/Codex/2026-06-04/read-only-dual-review-of-today/outputs/claude-readonly-review-skill-full.md`

  Destination:
  - `skills/claude-readonly-review/SKILL.md`

  Requirements:
  - Treat the source file as read/copy reference only.
  - Do not delete, move, edit, or rewrite the source file.
  - Adapt only as needed for the public McStacks repo: public-safe wording, no private paths, no local-only assumptions.
  - Preserve the new `skills/` folder placement and validation behavior.
  - Run skill validation, privacy scan, and Claude read-only review before publishing.

- Port the public-safe parts of the local "A New Project Setup" notes into McStacks.

  Local source:
  `C:\Users\Cmcna\Dev\notes\projects\A New Project Setup`

  Likely destinations:
  - `workflows/`: new-project setup flow, GitHub PR flow, concurrent worktree guidance, handoff prompts.
  - `brain/templates/`: project control templates such as `STATE.md`, `TASKS.md`, startup files, and guardrails.
  - `docs/`: folder map, versioning, setup tiers, and public-safe explanation docs.

  Requirements:
  - Do not copy the private folder verbatim.
  - Strip private project names, local paths, transcripts, client details, and live-bot specifics.
  - Convert private examples into generic public templates.
  - Preserve the fast/minimal-context startup pattern.
  - Run privacy scans and Claude read-only review before publishing.

- Build a Claude-to-Codex trigger workflow.

  The current `claude-readonly-review` skill is for Codex to call Claude as a read-only reviewer. McStacks should also define the reverse path: a safe workflow or skill that lets Claude trigger Codex for repo-owned implementation, verification, git, PR, and shipping work without giving Claude direct authority over those actions.

  Requirements:
  - Preserve the Codex-owned working-tree boundary.
  - Make Claude's request an explicit handoff packet, not an instruction stream.
  - Include scope, evidence, proposed task, risk level, and stop conditions.
  - Require Codex to verify the request before editing or running commands.
  - Document when the reverse trigger is useful versus when the user should talk to Codex directly.

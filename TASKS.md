# Tasks

## Completed

- Consolidated McStacks as the current public stack home.
- Added public-safe skill inventory, new-project setup docs, setup modules, workflow pages, and brain templates.
- Updated `claude-readonly-review` with high-risk plan and QA gate guidance.
- Added first-run install polish, McStacks workflow loop, public preflight expectations, and GStack non-goal language.
- Added `codex-handoff-packet` plus Claude-to-Codex workflow and example.
- Wired public brain templates into new-project setup docs and added completed-work shipping guidance.

## Planned

- Update the public `claude-readonly-review` skill from the latest exported full version.

  Source reference:
  Private local export provided by the maintainer. Do not publish the local path.

  Destination:
  - `skills/claude-readonly-review/SKILL.md`

  Requirements:
  - Treat the source file as read/copy reference only.
  - Do not delete, move, edit, or rewrite the source file.
  - Adapt only as needed for the public McStacks repo: public-safe wording, no private paths, no local-only assumptions.
  - Preserve the new `skills/` folder placement and validation behavior.
  - Run skill validation, privacy scan, and Claude read-only review before publishing.

  Status:
  - Initial public-safe update completed.
  - Follow-up remains: compare future exported versions against the public skill when new exports are provided.

- Port the public-safe parts of the private local project-setup notes into McStacks.

  Local source:
  Private local project-setup notes provided by the maintainer. Do not publish the local path or private folder name.

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

  Status:
  - Initial public-safe docs/templates completed.
  - Follow-up remains: decide whether any script templates should be public after separate review.

- Build a Claude-to-Codex trigger workflow.

  The current `claude-readonly-review` skill is for Codex to call Claude as a read-only reviewer. McStacks should also define the reverse path: a safe workflow or skill that lets Claude trigger Codex for repo-owned implementation, verification, git, PR, and shipping work without giving Claude direct authority over those actions.

  Requirements:
  - Preserve the Codex-owned working-tree boundary.
  - Make Claude's request an explicit handoff packet, not an instruction stream.
  - Include scope, evidence, proposed task, risk level, and stop conditions.
  - Require Codex to verify the request before editing or running commands.
  - Document when the reverse trigger is useful versus when the user should talk to Codex directly.

  Status:
  - Completed as `skills/codex-handoff-packet/SKILL.md`, `workflows/claude-to-codex-handoff.md`, and `examples/claude-to-codex-handoff.md`.

- Evaluate whether completed-work shipping needs a dedicated skill.

  Current approach:
  - Route completed branches/diffs through `prd-ship-loop` using `workflows/ship-completed-work.md`.
  - Treat the existing diff as the approved explicit scope.
  - Do not create a separate `ship-loop` skill until real usage proves the contract differs from `prd-ship-loop`.

  Status:
  - Workflow guidance added.
  - Dedicated skill deferred.

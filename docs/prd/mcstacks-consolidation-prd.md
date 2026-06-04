---
title: McStacks Public Stack Consolidation PRD
status: draft
date: 2026-06-04
owner: cmm219
surface: public GitHub repository and profile
visibility: public-safe
---

# McStacks Public Stack Consolidation PRD

## Current State

McStacks is the public home for the agent stack:

- `skills/` contains six installable Codex skills.
- `brain/` contains public-safe local-first brain guidance and templates.
- `workflows/` contains initial workflow docs.
- `agents/` describes role boundaries.
- `TASKS.md` tracks follow-up work.

Public GitHub also has a superseded historical playbook repo. The profile now presents McStacks as the selected public stack project, but the public ecosystem still needs a cleaner single-source story.

Local private Codex skills include more workflow skills than the six currently public in McStacks. Some are general and useful. Others are project-specific, production-specific, money-touching, or private and must not be published verbatim.

The maintainer also provided private local source references for:

- the latest full `claude-readonly-review` skill export
- the new-project setup playbook and templates

Those sources are private references only. Public docs must not publish their local paths, private folder names, transcripts, logs, project names, or operational details.

## Problem

The public stack is useful but incomplete:

- McStacks does not yet show the whole public-safe stack in a polished way.
- Some reusable setup and workflow concepts still live in private local notes or superseded public material.
- The latest `claude-readonly-review` improvement has not been fully reconciled into the public `skills/` folder.
- There is no public inventory explaining which local skills are publishable, private, or candidates for generic public templates.
- Duplicate public repo presence can make the project story less clear.

## Goals

1. Make McStacks the single polished public home for the public-safe agent stack.
2. Create a public-safe skill inventory with classification and rationale.
3. Update the public `claude-readonly-review` skill from the latest private source reference, adapting it safely for McStacks.
4. Port public-safe new-project setup material into McStacks as docs, workflows, and templates.
5. Ensure the profile README links to McStacks as the primary public stack project and does not surface superseded stack repos above it.
6. Preserve privacy, correctness, and trust boundaries.

## Non-Goals

- Do not publish private project skills verbatim.
- Do not publish live-money bot details, private paths, credentials, client data, transcripts, or local notes.
- Do not archive, privatize, or delete public repos without explicit user approval.
- Do not port script bodies from private setup notes in this PRD.
- Do not turn McStacks into a hosted service or model router.

## Product Vocabulary

- **McStacks:** the public agent stack repo.
- **Public-safe skill:** a skill that can be shared without private project details, secrets, private paths, or risky operational assumptions.
- **Generic workflow pattern:** a public rewrite of a private workflow skill that keeps the reusable structure but removes private context.
- **Private skill:** a local skill that should remain private indefinitely because it is project-specific, live-system-specific, credential-sensitive, or operationally risky.
- **Follow-up skill:** a skill that is not publishable in this PRD but may become public after a named blocker is resolved.
- **Stack inventory:** a public-safe table of local skills and disposition decisions.
- **Source reference:** a private local file read only to adapt structure; it is not modified or published verbatim.
- **Codex-owned boundary:** Codex owns repo edits, verification, git, PRs, merges, deploys, and final engineering judgment; Claude or other models may review, propose, or generate scoped artifacts only when Codex verifies them.

## Workstream Sequence

Workstreams run in this order. Later workstreams should not start until the earlier workstream reaches its exit criteria unless the later work is clearly independent and low-risk.

1. Profile and public repo cleanup.
2. Skill inventory.
3. Latest `claude-readonly-review` update.
4. New-project setup port.
5. Final public polish.

## Required Flows

### Flow 1: Public Repo And Profile Cleanup

1. Verify public repos and descriptions.
2. Confirm McStacks is the selected public stack home.
3. Keep superseded repos clearly marked if they remain public.
4. Remove duplicate profile links when McStacks is the better public destination.
5. Stop before archiving or privatizing any repo.

Done when:

- Profile README presents McStacks as the public stack project.
- Superseded public repos are not presented as active homes for the same stack.
- No repo visibility changes were made without explicit approval.

### Flow 2: Skill Inventory

Create `docs/skill-inventory.md`.

Inventory columns:

- skill name
- McStacks counterpart
- disposition: `publish`, `generic-pattern`, `private`, or `follow-up`
- reason
- follow-up trigger, required only when disposition is `follow-up`

Matching rule:

- Match local skills to public McStacks skills by skill directory name, case-insensitive.
- Do not publish local absolute paths in the inventory.
- Do not copy private skill bodies into the inventory.

Classification rules:

- `publish`: broadly reusable and public-safe after normal review.
- `generic-pattern`: useful idea, but must be rewritten so it is not a thin disguise of private work. It must contain no private project context, no internal names, and no copied private prose beyond short generic phrases.
- `private`: remains private indefinitely.
- `follow-up`: maybe public later, with a named blocker or prerequisite.

Done when:

- Every local non-system skill is accounted for by either an exact public-safe row or a redacted category/group row.
- Every row has a disposition and reason.
- Private and follow-up items do not leak private content.

### Flow 3: Latest `claude-readonly-review` Update

1. Read the private exported source file as reference.
2. Copy/adapt the relevant content into `skills/claude-readonly-review/SKILL.md`.
3. Remove or generalize private paths and local-only assumptions.
4. Preserve public CLI resolution:
   - `CLAUDE_CLI_PATH`
   - `claude` on `PATH`
   - install/configure Claude Code if neither exists
5. Preserve approval loops, session reuse, packet conventions, retention guidance, and Codex-owned boundaries.
6. Update examples and changelog if behavior changes.

Validated means:

- `node scripts/validate-skills.mjs` passes.
- The public skill contains no private local path or private-source reference.
- Public CLI examples use portable resolution.
- The updated public skill is manually compared against the private source reference for missing public-safe behavior.
- Claude read-only review checks the diff against previous public version.

Done when:

- Public skill is updated and validated.
- Public examples still match the skill behavior.
- Claude approves the skill diff or all objections are resolved with evidence.

### Flow 4: New Project Setup Port

1. Use the approved setup-porting plan as the implementation source of truth.
2. Create public docs and workflow pages under McStacks.
3. Add public templates under `brain/templates/`.
4. Use placeholders instead of private values.
5. Do not publish local notes paths, private folder names, transcripts, or private project names.
6. Do not port script bodies in this PRD.

Done when:

- McStacks has a coherent public new-project setup flow.
- Brain templates support fast/minimal-context startup and project memory.
- Workflows explain setup, PR, worktree, and review-gate concepts clearly.

### Flow 5: Final Public Polish

1. Update README navigation so users can understand the stack quickly.
2. Update `docs/folder-structure.md`, `workflows/README.md`, `brain/README.md`, and `agents/README.md`.
3. Update `TASKS.md` to distinguish complete work from follow-ups.
4. Update `CHANGELOG.md` using the existing newest-entry-first format.
5. Ensure profile README still points to McStacks cleanly.

Done when:

- New pages are discoverable from README or folder indexes.
- No duplicated guidance conflicts with existing skills/workflows.
- Follow-up work is tracked without blocking the shipped public stack.

## Backend / Data / API Truthfulness

McStacks is a static public repository. There is no backend or hosted service.

The only external integrations are local developer tools used during maintenance:

- `git`
- `gh`
- Claude Code CLI for read-only review
- Node/PowerShell validation scripts

No doc should imply McStacks automatically installs private memory, syncs secrets, runs bots, deploys services, or operates live systems.

## Acceptance Criteria

1. McStacks contains a public-safe stack inventory with classifications and reasons.
2. The public `claude-readonly-review` skill is updated from the latest private source reference and validated.
3. Public-safe new-project setup material is represented in McStacks docs/workflows/templates.
4. README and navigation make McStacks look like the coherent public home for the stack.
5. The profile README links to McStacks as the primary public stack project.
6. Superseded public repos are de-emphasized only; archiving/privatizing remains a separate explicit decision.
7. No private source details leak.
8. Automated verification passes:
   - `node scripts/validate-skills.mjs`
   - `powershell -ExecutionPolicy Bypass -File .\scripts\preflight.ps1`
   - `git diff --check`
   - link/path sanity check
   - public-safety scan
9. Manual verification passes:
   - Claude read-only final diff/QA review.
10. Merge decision:
   - merge to `main` only if all acceptance criteria pass cleanly with no public-safety findings.
   - otherwise open or leave a draft PR with findings logged.

## Public-Safety Scan Requirements

Scan for categories, not only exact strings:

- absolute user paths
- private notes vault paths
- private source folder names
- private project names and bot names
- `.env` references that imply contents rather than warnings
- API keys, tokens, passwords, and private key headers
- concrete ports, hostnames, service names, deploy targets, live-system names, ledger paths, and generated data folders
- transcripts, logs, model responses, and review packets

## Abort Conditions

Stop mid-flow if:

- a public-safety scan finds private content that cannot be safely generalized
- the skill update regresses public CLI resolution or Codex-owned boundaries
- a local source detail seems valuable but cannot be safely rewritten
- the work would archive, privatize, or delete a public repo
- the implementation starts requiring script bodies or operational assumptions outside this PRD

## Open Questions

1. Should the superseded playbook repo be archived or made private after McStacks is fully consolidated?
2. Which local private skills should eventually become generic public patterns?
3. Should generic script templates be added later, or should McStacks stay docs/skills-first for now?

These do not block the first implementation batch.

## Scorecard

| Dimension | Score |
|---|---:|
| Problem clarity | 9 |
| Goal clarity | 9 |
| User flows | 9 |
| Acceptance criteria | 9 |
| Implementation readiness | 9 |
| Design-loop readiness | 8 |
| Backend truthfulness | 10 |
| Non-technical user friendliness | 9 |
| Scope discipline | 9 |
| **Overall** | 9 |

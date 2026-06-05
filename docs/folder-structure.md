# Folder Structure

McStacks is organized as a public agent stack.

```text
mcstacks/
  claude-readonly-review/
  claude-design-html/
  claude-design-loop/
  codex-handoff-packet/
  pr-batching/
  prd-review-loop/
  prd-ship-loop/
  brain/
  workflows/
  agents/
  scripts/
  examples/
  docs/
```

## Root-Level Skill Folders

Installable Codex skills live as root-level directories with a `SKILL.md` file inside each folder.

This mirrors how users browse skill-heavy repos on GitHub: the actual skills are visible immediately in the first file list instead of being hidden under a package directory.

## `brain/`

Public-safe memory routing patterns and templates. This folder should teach how to route knowledge without publishing private memory.

The brain hot path is local-first: use narrow search plus a few source reads before escalating to heavier retrieval or synthesis systems.

## `workflows/`

Human-readable loops that compose skills into repeatable processes.

## `agents/`

Role boundaries and handoff contracts for Codex, Claude, and the user.

## `scripts/`

Install, preflight, and validation helpers.

## `examples/`

Copy-paste examples for common usage.

## `docs/`

Safety model, troubleshooting, and repository structure documentation.

Key docs:

- `new-project-setup.md` — serious-project bootstrap flow.
- `setup-modules.md` — optional setup modules by risk.
- `skill-inventory.md` — public-safe skill classification.

## Why Keep Skills At The Root?

The install and validation scripts discover root-level directories that contain `SKILL.md`. This keeps McStacks easy to browse on GitHub while still letting the repo grow into a full stack with `brain/`, `workflows/`, `docs/`, and `examples/`.

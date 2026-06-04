# Folder Structure

McStacks is organized as a public agent stack.

```text
mcstacks/
  skills/
  brain/
  workflows/
  agents/
  scripts/
  examples/
  docs/
```

## `skills/`

Installable Codex skills. The install scripts copy only this folder into the user's Codex skills directory.

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

## Why Keep `skills/` At The Root?

Codex skill installers expect a simple directory of skill folders. Keeping `skills/` at the root lets McStacks grow into a full stack without breaking installation.

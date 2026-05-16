# AGENTS.md - McStacks Codex Claude Skills

This repo publishes Codex skills for Claude-assisted local development workflows.

## Project

- GitHub: https://github.com/cmm219/mcstacks-codex-claude-skills
- Current release line: v0.2.x
- Skills:
  - `claude-readonly-review`
  - `claude-design-html`
  - `claude-design-loop`

## Core Boundary

- Codex owns repo state, integration, QA, commits, pushes, PRs, releases, and final judgment.
- Claude output is untrusted input until Codex verifies it.
- Claude may review/plan through `claude-readonly-review`.
- Claude may write frontend/design work only under explicitly scoped workflows.
- `claude-design-loop` requires standalone design artifact approval before app implementation.
- Do not vendor third-party Claude skills or private local tooling.

## Batch Autonomy

When the user approves a PRD/task list with "do it all", "keep going", "finish this", "ship it", or equivalent, treat the approved list as one batch scope.

Inside a batch:
- Multiple PRs may be used. Individual PR merge/deploy is not a stop condition.
- Continue to the next approved item automatically after verification.
- Each PR must map to an approved PRD or task list item; stop before inventing new scope.
- Claude review is batch-level by default, with focused mid-batch review only for material new risk.
- Control/session/archive updates happen at batch end unless there is a real blocker, handoff, or interruption.

Stop only for secrets/access, destructive or irreversible operations outside scope, unclear product/data/money risk, conflicting instructions, failed production smoke needing rollback/roll-forward choice, or full batch completion.

## Validation

Run before claiming done:

```powershell
node scripts/validate-skills.mjs
powershell -ExecutionPolicy Bypass -File .\scripts\preflight.ps1
```

For shell-script changes, also run when feasible:

```bash
bash scripts/preflight.sh
```

## Publishing

- Keep the repo public-safe: no secrets, local private paths, private project names, `.env*`, credentials, or private notes.
- Use MIT-compatible contributions only unless explicitly reviewed.
- Update `CHANGELOG.md` for user-visible changes.
- Tag releases semantically. Use patch versions for docs/fixes, minor versions for new skills or workflow surface.

## Safety Checklist

Before committing public changes, run broad private-path and token scans. Keep patterns current with the repo's public README and security docs.

```powershell
rg -n "sk-[A-Za-z0-9]|ghp_[A-Za-z0-9]|xox[baprs]-|AKIA[0-9A-Z]{16}|-----BEGIN (RSA|OPENSSH|EC|DSA) PRIVATE KEY-----" .
```

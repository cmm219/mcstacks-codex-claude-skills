# Changelog

## 0.4.1 - 2026-06-05

- Write the Windows install manifest as UTF-8 without a BOM so Node-based upgrade parsing works after `setup.ps1`.
- Make `setup.ps1 -Destination` run preflight against the same target Codex home used for installation.
- Allow preflight to respect `CODEX_SKILLS_DIR` when verifying a direct skills-directory install target.

## 0.4.0 - 2026-06-05

- Rework the README into a product-first McStacks surface with audience, quick start, workflow loop, skill table, and see-it-work example.
- Add `examples/README.md` for first-use prompts and example routing.
- Add root setup wrappers for Windows and macOS/Linux.
- Write a local `.mcstacks/manifest.json` during install so future upgrades can use an allowlist instead of guessing ownership.
- Add `mcstacks-upgrade` and `scripts/mcstacks-upgrade.mjs` for manifest-based upgrade, backup, preflight, and changelog summary.
- Add team/project setup documentation for public-safe adoption in other repos.

## 0.3.2 - 2026-06-04

- Add McStacks consolidation PRD, skill inventory, serious-project setup docs, setup modules, workflow pages, and brain templates.
- Strengthen `claude-readonly-review` with high-risk plan and QA gates from the latest private source reference.
- Reframe the repository as the broader McStacks public agent stack, with top-level `brain/`, `workflows/`, and `agents/` areas.
- Add local-first brain guidance for fast, minimal-context knowledge routing.
- Add `TASKS.md` with a planned Claude-to-Codex trigger workflow.
- Strengthen `claude-readonly-review` with the default plan-approval and final diff/QA approval loops.
- Add model routing guidance for `opus`, `sonnet`, and chunked large-context review packets without pinning future model IDs.
- Document same-session review reuse with `--output-format json` session capture and `--resume`.
- Add Markdown review packet conventions, freshness checks, finding IDs, status tags, timeout handling, and opt-in raw-response retention guidance.
- Update the read-only review example and README workflow to reflect the improved loop.

## 0.3.1 - 2026-05-16

- Expand README guidance on when to use each skill.
- Add typical workflow sections for review, gated design, and PRD-to-shipping flows.

## 0.3.0 - 2026-05-16

- Add `pr-batching` for choosing one PR, stacked PRs, or split PRs based on risk and verification boundaries.
- Add `prd-review-loop` for drafting, scoring, reviewing, and iterating PRDs before design or implementation.
- Add `prd-ship-loop` for bounded execution of approved PRDs or task lists through implementation, review, PRs, checks, and smoke QA.
- Strengthen `claude-readonly-review` with batch-level plan review guidance for approved multi-PR scopes.
- Update README and examples for the expanded workflow skill set.

## 0.2.2 - 2026-05-16

- Add Batch Autonomy project instructions for approved multi-step task scopes.
- Document optional `CLAUDE_DESIGN_CLI` support for design-enabled Claude wrappers or profiles.
- Strengthen `claude-design-loop` artifact approval, timeout handling, and mechanical-vs-design edit boundaries.

## 0.2.1 - 2026-05-14

- Add `AGENTS.md` with local project instructions for future Codex sessions.

## 0.2.0 - 2026-05-14

- Add `claude-design-loop` for strict design artifact approval loops.
- Document the full flow: Claude artifact, Codex review, user approval, app implementation, Codex QA, final user approval.
- Position local `/design-html` workflows as optional user-installed design providers.

## 0.1.1 - 2026-05-14

- Document optional local design-skill workflows for `claude-design-html`.
- Clarify that third-party design skills should remain local design-time tools and should not be vendored into app repos.
- Add example prompt for artifact-first design workflows.

## 0.1.0 - 2026-05-14

- Initial public release.
- Add `claude-readonly-review`.
- Add `claude-design-html`.
- Add Windows/macOS/Linux install and preflight scripts.
- Add safety, examples, troubleshooting, and contribution docs.

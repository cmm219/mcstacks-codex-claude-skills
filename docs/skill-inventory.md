# Skill Inventory

This inventory tracks which local workflow skills are suitable for McStacks.

McStacks does not publish private project names, private local paths, live-system details, or private skill bodies. Private and project-specific local skills are grouped by category when naming them would expose private context.

## Dispositions

| Disposition | Meaning |
| --- | --- |
| `publish` | Broadly reusable and public-safe as an installable skill. |
| `generic-pattern` | Useful workflow pattern, but must be rewritten generically before publishing. |
| `private` | Stays private indefinitely. Not a McStacks publishing candidate. |
| `follow-up` | Maybe publish later after a named blocker is resolved. |

## Public Skills In McStacks

| Skill | McStacks counterpart | Disposition | Reason | Follow-up trigger |
| --- | --- | --- | --- | --- |
| `claude-readonly-review` | `skills/claude-readonly-review` | `publish` | Core review gate for Codex-to-Claude second opinions. | Keep current with public-safe exported updates. |
| `claude-design-html` | `skills/claude-design-html` | `publish` | Reusable design partner workflow with Codex review boundary. | Continue validating public-safe examples. |
| `claude-design-loop` | `skills/claude-design-loop` | `publish` | Reusable gated design artifact workflow. | Continue validating public-safe examples. |
| `codex-handoff-packet` | `skills/codex-handoff-packet` | `publish` | Reverse handoff pattern for Claude-originated requests while preserving Codex-owned repo authority. | Validate against real handoff usage. |
| `pr-batching` | `skills/pr-batching` | `publish` | General PR-scope decision framework. | None. |
| `prd-review-loop` | `skills/prd-review-loop` | `publish` | General PRD creation/review workflow. | None. |
| `prd-ship-loop` | `skills/prd-ship-loop` | `publish` | General approved-scope shipping workflow. | None. |

## Public Candidates

| Skill or pattern | McStacks counterpart | Disposition | Reason | Follow-up trigger |
| --- | --- | --- | --- | --- |
| `read-only-guard` | TBD | `publish` | General safety mode for audits, reviews, and inspect-only work. | Public-safe rewrite and validation. |
| `playwright` | TBD | `publish` | General browser QA workflow useful across projects. | Ensure it does not duplicate plugin docs and stays tool-agnostic enough. |
| `gstack-investigate` | TBD | `generic-pattern` | Strong root-cause workflow, but should be renamed and generalized for McStacks. | Rewrite without dependency on private/local naming. |
| `project-dashboard-maintainer` | TBD | `generic-pattern` | Useful end-of-session/status dashboard pattern. | Rewrite around public project dashboards and privacy rules. |
| `nice-job` | TBD | `generic-pattern` | Useful client/CEO handoff pattern. | Rewrite as a generic handoff-summary skill. |
| `end-session-wiki-inbox` | TBD | `generic-pattern` | Durable learning capture is useful, but private wiki paths must not be published. | Convert to McStacks brain-inbox pattern with placeholders. |
| `obsidian-control` | TBD | `generic-pattern` | Project-control workflow is useful, but private vault behavior must be generalized. | Convert to public `brain/` and `control/` template guidance. |
| `skill-creator` and `skill-installer` equivalents | System-provided today | `follow-up` | Useful to document, but system skills are not owned by this repo. | Add public docs only if they help users install or author McStacks skills. |

## Private Or Project-Specific Skills

| Skill group | McStacks counterpart | Disposition | Reason | Follow-up trigger |
| --- | --- | --- | --- | --- |
| Private deployment workflows | None | `private` | Project-specific infrastructure, hosts, release controls, and operational assumptions. | May become generic deploy checklist docs only. |
| Private QA workflows | None | `private` | Project-specific routes, products, production surfaces, and safety boundaries. | May become generic QA checklist docs only. |
| Private money/trading/bot workflows | None | `private` | Live-money, trading, ledger, and operational details must remain private. | May become generic high-risk automation guardrails only. |
| Private spreadsheet/data artifact workflows | None | `private` | Project-specific data sources and artifact contracts. | May become generic data-workbook guidance only. |
| Private app release workflows | None | `private` | Product-specific build, packaging, deployment, and shortcut behavior. | May become generic release checklist docs only. |
| Generated pet/image workflows | None | `follow-up` | Fun/useful but not core to McStacks public agent-stack positioning. | Revisit if McStacks expands into media/output skills. |

## Inventory Rules

- Do not publish local absolute paths.
- Do not publish private skill bodies.
- Do not publish private project names when a category label is enough.
- A `generic-pattern` rewrite must be understandable without private context.
- A `private` item stays private unless the maintainer explicitly approves a new public rewrite.

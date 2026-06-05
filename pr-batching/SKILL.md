---
name: pr-batching
description: Decide whether related work should be shipped as one pull request, stacked pull requests, or split pull requests. Use when Codex is planning PR scope, reducing review overhead, sequencing implementation slices, deciding whether to batch docs/tests/UI changes, or choosing when risk boundaries require separate PRs.
---

# PR Batching

## Purpose

Use this skill to choose a reviewable PR shape that moves quickly without hiding risk. The goal is not to make PRs as large as possible; it is to group work only when one reviewer can understand, test, and revert the whole change as one coherent unit.

Project-specific risk rules still come from the repository's instructions, control notes, QA skill, or maintainers. This skill provides global slicing heuristics.

## Decision Rule

Prefer one PR when all of these are true:

- The changes share one product or technical risk surface.
- One reviewer can validate the whole change with one clear review pass.
- One verification story covers the whole change.
- One rollback or revert safely removes the whole change.
- The PR has no drive-by refactors, renames, formatting, or cleanup outside the stated purpose.

Prefer stacked PRs when:

- A foundational docs/contract/fixture change should be reviewed before dependent implementation.
- A base refactor or test harness change makes the follow-up PR easier to review.
- Each PR can pass tests independently.
- Each PR has a clear base branch and can be merged or abandoned without confusing ownership.

Prefer separate PRs when:

- The changes introduce different risk boundaries.
- The work needs different reviewers or approval gates.
- The verification stories differ materially.
- Reverting one part without the other is likely.
- The batch would force a reviewer to approve live behavior they are not ready to approve.

If you cannot write one revert command that safely undoes the whole PR, split it.

## Good Batching Candidates

Batch when the work is related and low-risk:

- Docs-only PRDs, plans, or decision records for the same feature area.
- Static checks, lint rules, or test-only assertions covering the same boundary.
- A self-contained UI surface plus its fixtures and tests, where the surface ships behind a flag or has no live consumers yet.
- Small follow-up edits required by the same review finding.
- Changelog/version/metadata updates required by the same shipped change.

## Usually Split

Keep separate PRs for new or live behavior boundaries:

- Authentication or authorization.
- Database schema, migrations, or data backfills.
- External integrations, credentials, tokens, or secret handling.
- Payments, billing, invoices, or financial behavior.
- Messaging, notifications, webhooks, or external sends.
- Production data, customer data, privacy, or compliance changes.
- File uploads, imports, source ingestion, or parser behavior.
- Background workers, scheduled jobs, queues, retries, or idempotency behavior.
- Deployment, runtime configuration, infrastructure, or environment changes.
- Feature flag flips that change live user behavior.

Project rules may require even stricter splitting. Follow the stricter rule.

## Stacking Pattern

When stacking PRs:

1. Make the base PR independently useful and mergeable.
2. Keep each follow-up PR focused on the next risk boundary.
3. State the stack order in every dependent PR.
4. Rebase dependent PRs after the base merges.
5. Avoid mixing unrelated cleanup into any stack layer.

Good stack example:

- PR A: docs/contract/plan approved.
- PR B: fixtures and static tests.
- PR C: contained UI using those fixtures.
- PR D: backend behavior behind a reviewed implementation plan.

Bad stack example:

- PR A: schema change, UI rewrite, external integration, unrelated cleanup, and docs edits.

## PR Body Guidance

A batched or stacked PR should say:

- why this scope belongs together,
- what is intentionally not included,
- what risk boundary is being reviewed,
- how it was tested,
- how to revert it,
- whether it depends on another PR.

If batching was a close call, say so explicitly and name the reason it is still reviewable.

## Claude Or External Review

When using a read-only reviewer, ask it to review the batching decision directly:

```text
Review this proposed PR scope. Do not edit files. Is this safe to batch, should it be stacked, or should it be split? Consider reviewability, risk boundaries, verification, rollback, and hidden live behavior. Return APPROVED only if the PR shape is coherent.
```

Treat the review as advisory unless the project requires an explicit approval gate.

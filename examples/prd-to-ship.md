# Example: PRD To Ship

Prompt in Codex:

```text
Use prd-review-loop to turn this feature into a scored PRD. Once the PRD is approved, use pr-batching to decide PR shape, then use prd-ship-loop to implement the approved scope and keep going through verification.
```

Approved scope prompt:

```text
Use prd-ship-loop to execute this approved PRD. Branch from the default branch, implement only the approved scope, run the required checks, use claude-readonly-review for the final diff/QA gate, open a PR, and keep going until the approved scope is complete.

Ship token: merge when green.
```

Minimal PRD sections:

```markdown
# PRD

## Problem

## Goals

## Non-goals

## User-visible Behavior

## Implementation Scope

## Verification

## Stop Conditions

## Release Notes
```

Use `pr-batching` before implementation when the PRD naturally splits into multiple risk boundaries, such as docs plus code, UI plus backend, or setup plus deploy.

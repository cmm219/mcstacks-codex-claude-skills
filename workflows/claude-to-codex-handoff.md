# Claude To Codex Handoff

Use this workflow when Claude has a proposed task for Codex but should not operate the repo directly.

## Flow

1. Claude writes a `Codex Handoff Packet`.
2. Codex checks the packet against current user intent, repo instructions, and live repo state.
3. Codex accepts, narrows, rejects, or asks for missing information.
4. Codex routes accepted work to the right workflow:
   - review only: `claude-readonly-review` or direct Codex review
   - requirements: `prd-review-loop`
   - implementation: normal repo workflow
   - approved task shipping: `prd-ship-loop`
   - UI artifact work: `claude-design-loop`
5. Codex runs the relevant verification and reports the outcome.

## Packet Shape

```markdown
# Codex Handoff Packet

## Requested Outcome

## Scope

## Evidence

## Proposed Task

## Risk Level

## Permissions Requested

## Verification Ask

## Stop Conditions
```

## Acceptance Rules

Codex can accept the packet only when:

- the requested outcome matches the user's current intent
- scope and out-of-scope boundaries are explicit
- evidence is tied to files, tests, logs, screenshots, issues, PRs, or user messages
- requested permissions are necessary and safe
- verification is concrete enough to run or adapt
- no private paths, secrets, transcripts, or unrelated project context are being published

## Stop Rules

Stop before acting when the packet asks for secrets, destructive commands, production data mutation, deploys without a declared workflow, vague product changes, or anything that conflicts with repo guardrails or newer user instructions.

## Done When

- Codex has accepted, rejected, or blocked the packet with reasons.
- Accepted work is routed to the right workflow.
- Verification has been run or the missing verification is reported.

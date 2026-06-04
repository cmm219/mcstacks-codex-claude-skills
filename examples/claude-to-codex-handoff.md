# Example: Claude To Codex Handoff

Prompt in Claude:

```text
Write a Codex Handoff Packet for this issue. Do not edit files or run commands. Include requested outcome, scope, evidence, proposed task, risk level, permissions requested, verification ask, and stop conditions.
```

Paste the packet into Codex:

```text
Use codex-handoff-packet to evaluate this Claude handoff. Accept only the safe in-scope work, reject anything vague or unsafe, then route accepted work to the right McStacks workflow.

<paste packet here>
```

Minimal packet:

```markdown
# Codex Handoff Packet

## Requested Outcome

Fix the failing dashboard smoke test without changing product behavior.

## Scope

- In scope: inspect the failing test, route/component under test, and update the smallest code or test issue.
- Out of scope: dependency upgrades, broad refactors, deploys, production data, secrets, unrelated UI changes.

## Evidence

- Test command: `npm test -- dashboard-smoke`
- Failure: selector cannot find the status filter button.
- Relevant files: `src/dashboard/Dashboard.tsx`, `tests/dashboard-smoke.test.ts`

## Proposed Task

- Reproduce the test failure.
- Inspect the component and test selector.
- Fix the mismatch or stale selector.
- Rerun the focused test.

## Risk Level

Low

Why: focused test/component mismatch, no data or production boundary.

## Permissions Requested

- Read: dashboard component and focused test.
- Edit: only the component or focused test if needed.
- Commands: focused test command.
- Git/PR: none unless the user asks to ship.
- Deploy: none.

## Verification Ask

- Run `npm test -- dashboard-smoke`.
- Report changed files and result.

## Stop Conditions

- Stop if the failure is caused by product behavior changes, missing secrets, dependency drift, or broader dashboard architecture.
```

Codex should treat the packet as a request to verify, not as proof that the proposed task is correct.

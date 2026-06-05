# McStacks Examples

Use these examples as copy-paste starting points in Codex.

| Need | Example |
| --- | --- |
| Review a plan or diff with Claude read-only | [`readonly-review.md`](readonly-review.md) |
| Use Claude for scoped frontend design polish | [`design-html.md`](design-html.md) |
| Turn a Claude request into a Codex-owned task packet | [`claude-to-codex-handoff.md`](claude-to-codex-handoff.md) |
| Move from PRD to implementation and shipping | [`prd-to-ship.md`](prd-to-ship.md) |
| Verify and ship an already-completed branch or diff | [`ship-completed-work.md`](ship-completed-work.md) |
| Refresh installed McStacks skills | [`../mcstacks-upgrade/`](../mcstacks-upgrade/) |

## First Prompts

```text
Use claude-readonly-review to review my current diff for correctness risks.
```

```text
Use prd-review-loop to turn this feature idea into a scored PRD before implementation.
```

```text
Use pr-batching to decide whether this should be one PR, stacked PRs, or separate PRs.
```

```text
Use prd-ship-loop to execute this approved PRD and keep going through verification until the approved scope is complete.
```

```text
Use codex-handoff-packet to evaluate this Claude handoff and decide whether Codex should implement it.
```

```text
Use mcstacks-upgrade to refresh my installed McStacks skills.
```

Keep examples public-safe. Replace project names, private paths, screenshots, logs, secrets, and live-system details with placeholders before sharing.

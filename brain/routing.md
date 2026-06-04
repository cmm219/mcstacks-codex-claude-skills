# Brain Routing

McStacks separates live code truth, project state, and durable knowledge.

## Route By Question

| Question Type | First Place To Look | Notes |
| --- | --- | --- |
| Current implementation, routes, schemas, tests | Repo search and source files | Live code wins over memory. |
| Current project status or next tasks | Project control files, if present | Keep control files small and current. |
| Reusable process, gotchas, or decisions | Public-safe brain docs or private local wiki | Publish only scrubbed patterns. |
| External API behavior or current product docs | Official docs | Use current docs for time-sensitive behavior. |
| User's private prior decisions | Local notes, not public repo content | Cite local paths only in private work, never in public docs. |

## Agent Startup Pattern

1. Inspect the current repo state.
2. Read only the smallest relevant project state file or brain note.
3. Use live source search for exact implementation details.
4. Use web or official docs only for external facts that may have changed.
5. In public docs, cite repo-relative paths and public sources only.

## Escalation Rule

Start local and cheap:

1. Try repo files, `brain/`, `workflows/`, and project control files first.
2. Use narrow lexical search plus 1-3 source reads.
3. Escalate to a database-backed brain, MCP retrieval, or web search only when the question needs cross-corpus synthesis, graph relationships, or current external facts.

This keeps the common path fast and auditable while still allowing heavier tools when they earn their cost.

## Public Brain Hygiene

- Prefer templates over copied private notes.
- Replace private project names with generic examples.
- Remove local absolute paths.
- Remove timestamps that reveal private operations unless they are release dates.
- Remove provider tokens, session IDs, auth URLs, and account identifiers.
- Keep examples short enough that users can adapt them.

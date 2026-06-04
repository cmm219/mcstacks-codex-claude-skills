# McStacks Brain

`brain/` is the public-safe memory layer for McStacks. It documents how an agent should find, route, and preserve reusable knowledge without publishing private notes, transcripts, credentials, client data, or local-only project context.

This folder is for:

- Knowledge-routing rules.
- Memory templates.
- Public examples of project state and task tracking.
- Privacy checks for deciding what can be shared.

This folder is not for:

- Private vault exports.
- Real credentials, tokens, `.env*`, or session IDs.
- Client, employer, or production incident details.
- Personal notes copied from a local knowledge base.
- Full transcripts unless they are scrubbed and intentionally published.

## Brain Routing

Use [`routing.md`](routing.md) when an agent needs to decide whether to inspect live repo code, public docs, project control files, or durable knowledge notes.

Use [`local-first.md`](local-first.md) to explain why McStacks brain routing starts with plain files and tiny context before escalating to heavier search or synthesis systems.

Use [`privacy.md`](privacy.md) before turning private lessons into public examples.

Use [`templates/project-memory.md`](templates/project-memory.md) as a starting point for public project memory files.

## Default Rule

Public McStacks brain content should teach the pattern, not expose the private source. Convert specifics into reusable, source-safe examples before publishing.

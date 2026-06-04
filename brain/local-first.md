# Local-first Brain

McStacks brain starts with plain files because the fastest useful memory is usually the source file the agent can already read.

## Why It Is Fast

- **Retrieval is a file read.** No query planner, server process, auth handshake, daemon, or database round trip is required for the common case.
- **No extra synthesis call.** Raw search can find candidate files, then the model reads the source directly. A separate synthesized answer costs another model call and can hide the source shape.
- **Small context stays stable.** A tiny routing brief in `AGENTS.md` plus a few cited source reads keeps startup context predictable and cache-friendly.
- **Nothing has to be online.** Local markdown still works without a running service or synced index.
- **The audit is simple.** The agent can say `Knowledge check: read brain/routing.md`, and reviewers can verify the cited file.

## What It Is Good For

Local-first brain works best for project-sized memory:

- Project rules.
- Current state and task pointers.
- Reusable workflow decisions.
- Gotchas and runbooks.
- Public-safe examples and templates.

## When To Escalate

Escalate beyond local files when the question needs:

- Large cross-corpus synthesis.
- Relationship or graph queries.
- Team-wide multi-tenant memory.
- Semantic search over a very large archive.
- Current external facts from official docs or the web.

The rule is not "never use a bigger brain." The rule is: use local files for the hot path, then escalate only when the question needs more than a few cited source reads.

## Minimal Context Pattern

1. Keep the always-loaded routing brief short.
2. Search narrowly by project, topic, or file name.
3. Read 1-3 relevant files.
4. Cite the paths used.
5. Avoid dumping whole folders or transcripts into context.

## Public Boundary

Public brain docs teach the method. They should not include private transcripts, local vault dumps, credentials, personal project paths, or unsanitized logs.

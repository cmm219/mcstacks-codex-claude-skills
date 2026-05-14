# Examples

## Read-only Diff Review

User:

```text
Use claude-readonly-review to review my current diff before I push.
```

Codex:

```bash
git diff | claude --permission-mode plan --tools "" -p "Review this diff..."
```

Claude returns findings. Codex then verifies each finding against the code, implements only valid fixes, and runs checks.

## Frontend Design Critique

User:

```text
Use claude-design-html for a read-only visual critique first.
```

Codex runs the app, captures screenshots when feasible, passes scoped UI context to Claude, reviews the recommendations, and chooses the high-impact fixes.

## Scoped Design Implementation

User:

```text
Use claude-design-html to implement a scoped design polish pass.
```

Codex prepares a branch/worktree or allowed path list, asks Claude to edit only those files, reviews the diff, runs browser QA, and accepts or corrects the work.

## Optional Local Design Skill Artifact

User:

```text
Use claude-design-html with my installed local /design-html workflow to create a design artifact first.
```

Codex asks Claude to use the user's installed local design workflow and write the result to an artifact folder, not directly into production app files. Codex then inspects the artifact, ports the approved design into the app, and QA checks the real app.

This keeps third-party design tooling as a local design-time dependency, similar to Figma or a mockup generator. The shipped app or PR should stand on its own unless the user explicitly wants the artifact committed.

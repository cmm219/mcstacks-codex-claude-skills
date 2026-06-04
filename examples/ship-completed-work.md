# Example: Ship Completed Work

Prompt in Codex:

```text
Use prd-ship-loop to ship the current completed branch. Treat the existing diff as the approved scope. Review it, run checks, fix only issues introduced by this diff, use claude-readonly-review for final diff/QA review, open a PR, and merge when green.
```

Completed-work scope:

```markdown
# Completed Work Scope

## Outcome

Ship the current branch that updates the project README and workflow docs.

## In Scope

- Review the current diff.
- Run Markdown/link/skill validation.
- Fix typos, broken links, validator failures, or missing references introduced by this diff.
- Open a PR and merge when green.

## Out Of Scope

- New skills not already in the diff.
- Repo rename, archive, or visibility changes.
- Private notes, secrets, local absolute paths, or production deploy behavior.

## Verification

- `node scripts/validate-skills.mjs`
- preflight script for the current platform
- `git diff --check`
- Claude read-only final diff review

## Stop Conditions

- Stop if validation requires a new product decision, private source material, destructive git action, or deploy behavior.
```

This keeps completed-work shipping concrete without creating a second shipping skill that overlaps `prd-ship-loop`.

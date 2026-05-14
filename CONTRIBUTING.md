# Contributing

Contributions are welcome when they preserve the safety model.

## Skill Rules

Each skill must have:

- A `SKILL.md` file.
- YAML frontmatter with `name` and `description`.
- A clear trigger description.
- A clear control boundary.
- No secrets, personal paths, local project names, or private data.

## Review Bar

New or changed skills must not:

- Auto-execute Claude output.
- Grant broad write access without a mechanical scope.
- Encourage dependency, lockfile, secret, deploy, or git-history changes without explicit approval.
- Hide data-sharing behavior from users.

## Local Checks

Run:

```bash
node scripts/validate-skills.mjs
```

Also run the platform preflight script for your OS.

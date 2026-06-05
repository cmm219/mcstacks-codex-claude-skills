# GStack Presentation Reference

Use Garry Tan's GStack repository as the public GitHub presentation reference for McStacks:

- GStack repo: <https://github.com/garrytan/gstack>
- GStack README/setup flow: <https://github.com/garrytan/gstack#install--30-seconds>

## What To Study

GStack is strong because the repository makes the product visible immediately:

- Skill folders are root-level directories with `SKILL.md` inside.
- The README opens with a clear story, audience, quick start, install command, and "see it work" example.
- The install flow is direct and copy-pasteable.
- The repo exposes real command/skill code first, with docs supporting the skills rather than hiding them.
- Setup, team-mode, browser/QA, deploy, and brain workflows are presented as a coherent stack.

## McStacks Adaptation

McStacks should adapt the presentation pattern without cloning GStack's content or brand.

Keep these McStacks-specific differences:

- Codex owns the repo, working tree, git, QA, PRs, and shipping.
- Claude is used for read-only review, planning, design, and handoff packets unless a workflow explicitly scopes more.
- Public `brain/` content is template/routing guidance, not private memory.
- Do not vendor, wrap, or redistribute GStack skills.

## Future Polish Rule

When improving McStacks' public GitHub presence, compare the change against GStack's repo shape:

1. Can a first-time visitor see the useful skill code from the GitHub root?
2. Can they install and try it quickly?
3. Does the README show the actual workflow, not just describe folders?
4. Are examples close enough to copy into Codex?
5. Are docs supporting the stack instead of burying the product?

Use Claude read-only review or another second model when making larger public-presentation changes, and ask it specifically to compare McStacks against this reference.

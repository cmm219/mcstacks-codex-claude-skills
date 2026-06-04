# New Project Bootstrap Workflow

Use this workflow when starting a serious project.

## Flow

1. Define `<PROJECT_NAME>`, `<DEFAULT_BRANCH>`, `<REPO_ROOT>`, and `<NOTES_ROOT>`.
2. Create repo startup files.
3. Create project control files.
4. Add task and session folders.
5. Add version/changelog discipline when the repo will ship PRs.
6. Choose setup modules from [setup-modules.md](../docs/setup-modules.md).
7. Run scaffold checks and record the result.

## Startup Files

Startup files should be short:

- what the project is
- where authoritative state lives
- which files to read first
- safety rules
- verification commands

Do not put full history, session logs, or backlog detail in startup files.

## Done When

- A new agent can open the repo and know where to look first.
- Control files are short pointers, not journals.
- Risk modules are installed only where needed.
- Private source material did not leak into the new project.

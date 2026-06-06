# Project Control Script Pack

The project-control script pack is an optional McStacks module for projects that
need repeatable local control notes, release notes, runtime audit entries, and
handoff checks.

It is designed for private or team-local project notes. Do not publish generated
session notes, private control files, logs, tokens, `.env` files, hostnames, or
absolute local paths.

## What It Adds

Copy the templates from
[`brain/templates/project-control/`](../brain/templates/project-control/) into a
new project when the project needs stronger handoff and release discipline.

Suggested mapping:

| Source Template | Target |
| --- | --- |
| `bots.json.template` | `bots.json` |
| `BOTS.md.template` | `BOTS.md` |
| `update_control.ps1.template` | `scripts/update_control.ps1` |
| `record_project_version.ps1.template` | `scripts/record_project_version.ps1` |
| `check_control_hygiene.ps1.template` | `scripts/check_control_hygiene.ps1` |
| `check_project_scaffold.ps1.template` | `scripts/check_project_scaffold.ps1` |
| `claim_version.ps1.template` | `scripts/claim_version.ps1` |
| `check_version_unique.ps1.template` | `scripts/check_version_unique.ps1` |
| `version_helpers.ps1.template` | `scripts/version_helpers.ps1` |
| `version-check.yml.template` | `.github/workflows/version-check.yml` |
| `VERSION.template` | `VERSION` |
| `CHANGELOG.md.template` | `CHANGELOG.md` |

## Runtime Registry

`bots.json` is a runtime registry. The name comes from bot-heavy projects, but
the pattern also works for desktop apps, workers, scripts, dashboards, services,
and other runnable entrypoints.

Before first use, replace:

- `<PROJECT_NAME>`
- `<NOTES_VAULT_PATH>`
- `<RUNTIME_ID>`
- `<HUMAN_RUNTIME_NAME>`
- `<RELATIVE_ENTRYPOINT_OR_APP_PATH>`
- `<PROJECT_SPECIFIC_ARTIFACT_GLOB>`
- `<DEFAULT_BRANCH>`

Use `rg "<[A-Z_][A-Z0-9_]+>" .` after copying templates so half-replaced
placeholders do not slip through. `<DEFAULT_BRANCH>` appears in the version
helper scripts and the GitHub Actions workflow.

## Main Commands

Record a local control note:

```powershell
.\scripts\update_control.ps1 -Runtime <RUNTIME_ID> -Event note -Summary "Finished setup pass" -RuntimeState not-launched -Verification "docs reviewed"
```

Record a runtime start:

```powershell
.\scripts\update_control.ps1 -Runtime <RUNTIME_ID> -Event start -Summary "Started local smoke test" -RuntimeState local -Command "python app.py" -RunCwd "<REPO_ROOT>" -Verification "manual launch"
```

Record a runtime stop:

```powershell
.\scripts\update_control.ps1 -Runtime <RUNTIME_ID> -Event end -Summary "Stopped local smoke test" -RuntimeState local -StopReason "test complete" -Verification "process closed"
```

Run control hygiene:

```powershell
.\scripts\check_control_hygiene.ps1 -NotesRoot "<NOTES_ROOT>"
```

Run scaffold checks:

```powershell
.\scripts\check_project_scaffold.ps1 -NotesRoot "<NOTES_ROOT>"
```

For a project that does not use PR version claiming, skip the version uniqueness
check:

```powershell
.\scripts\check_project_scaffold.ps1 -NotesRoot "<NOTES_ROOT>" -SkipVersionUnique
```

Record a notes-side version history entry:

```powershell
.\scripts\record_project_version.ps1 -Slug "release-name" -Details "Shipped focused change." -Verification "Tests passed." -NotesPath "<NOTES_ROOT>\reference-version-history.md"
```

The GitHub Actions workflow template uses the standard repository-scoped
`${{ secrets.GITHUB_TOKEN }}` and requests read-only `contents` and
`pull-requests` permissions for version-collision checks.

## Public Safety Rules

- Keep generated session notes and control files in a private notes folder unless
  the project intentionally publishes sanitized examples.
- Keep public repos product-first: source, docs, screenshots, releases, and
  install instructions should be easier to find than private workflow machinery.
- Replace placeholders before use.
- Never copy old project names, private paths, transcripts, credentials, ports,
  service names, deploy targets, live trading details, or customer data into a
  public repo.
- Run a path and secret scan before pushing public setup changes.

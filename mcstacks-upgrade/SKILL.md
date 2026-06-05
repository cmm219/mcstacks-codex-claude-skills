---
name: mcstacks-upgrade
description: Safely refresh installed McStacks skills from a verified McStacks checkout using the local install manifest allowlist, with backup, restore, preflight, and changelog summary.
---

# McStacks Upgrade

## Purpose

Use this skill when the user wants to update an existing local McStacks install.

The first version is intentionally conservative:

- It uses the McStacks install manifest instead of guessing which folders belong to McStacks.
- It updates only McStacks skill folders.
- It backs up installed McStacks skills before overwrite.
- It restores the backup if the upgrade fails.
- It runs validation/preflight after copying.
- It shows the latest changelog section when available.

## Command

From a McStacks checkout:

```powershell
node scripts/mcstacks-upgrade.mjs --yes
```

macOS / Linux:

```bash
node scripts/mcstacks-upgrade.mjs --yes
```

Omit `--yes` when running interactively and the script will ask before changing installed skills.

## Options

- `--source <path>`: use a specific McStacks checkout as the upgrade source.
- `--codex-home <path>`: use a specific Codex home instead of `$CODEX_HOME` or `~/.codex`.
- `--yes`: skip the confirmation prompt.
- `--allow-dirty`: allow upgrading from a dirty source checkout.

## Safety Rules

- Do not delete unrelated folders from the user's Codex skills directory.
- Do not upgrade from a dirty source checkout unless the user explicitly passes `--allow-dirty`.
- Do not continue if the install manifest is missing and no source checkout can be verified.
- Do not hide preflight failures.
- Do not add auto-upgrade, telemetry, snooze state, migrations, or team-mode cleanup without a separate reviewed change.

## Expected Flow

1. Resolve the Codex skills directory.
2. Read `.mcstacks/manifest.json` from that directory.
3. Resolve and validate the source checkout.
4. Compare source version/head to the manifest.
5. Ask for confirmation unless `--yes` is present.
6. Back up manifest-listed McStacks skill folders.
7. Copy current source skill folders into the Codex skills directory.
8. Remove only previously manifest-listed McStacks skills that no longer exist in the source.
9. Write a fresh manifest.
10. Run preflight.
11. Show the latest changelog entry.

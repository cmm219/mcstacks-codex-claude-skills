# Security Policy

## Reporting

Please open a GitHub security advisory or private report if you find a vulnerability involving secret exposure, unsafe execution, or misleading safety boundaries.

## Scope

This project contains Codex skills and local install scripts. It does not host a service and does not store credentials.

## Data Handling

Claude Code invocations may send prompt context, diffs, file contents, or screenshots to Anthropic or to the provider configured in the user's Claude Code installation. Users are responsible for deciding what context to pass.

Do not pass secrets, `.env*`, credential files, private notes, or unrelated personal data to Claude.

# Example: Read-only Review

Prompt in Codex:

```text
Use claude-readonly-review to review my current diff for correctness risks.
```

Typical Codex command:

```bash
git diff | claude --permission-mode plan --tools "" -p "You are reviewing a Git diff for a Codex workflow. Do not edit files. Do not run commands. Return only actionable findings ordered by severity. Include file/line references where possible. Focus on correctness risks, behavioral regressions, security/privacy issues, missing tests, and maintainability concerns."
```

Expected loop:

1. Claude returns findings.
2. Codex verifies each finding against the repo.
3. Codex implements accepted fixes.
4. Codex runs the relevant checks.
5. Codex reports what was accepted, rejected, and verified.

Claude output is not automatically trusted.

# Example: Read-only Review

Prompt in Codex:

```text
Use claude-readonly-review to plan this change, implement approved fixes, and review the final diff.
```

Default loop:

1. Codex sends Claude a scoped plan and QA plan.
2. Claude returns `APPROVED` or required changes.
3. Codex revises the plan until approved, unless Codex rejects a finding with evidence.
4. Codex implements the approved plan.
5. Codex runs the planned checks.
6. Codex sends Claude the final diff plus QA results.
7. Codex fixes in-scope review findings and repeats the diff/QA review until approved.

Use the skill's five-iteration soft cap for non-converging loops. The cap does not make Claude automatically right; Codex can reject a finding with evidence.

Small diff command:

```bash
git diff | claude --permission-mode plan --tools "" --model opus -p "You are reviewing a Git diff for a Codex workflow. Do not edit files. Do not run commands. Return only actionable findings ordered by severity. Include file/line references where possible. Focus on correctness risks, behavioral regressions, security/privacy issues, missing tests, and maintainability concerns."
```

`--model opus` is used when Claude is acting as an approval gate. Use `sonnet` only for low-risk advisory checks where approval does not depend on Claude.

Plan gate prompt:

```markdown
You are reviewing a Codex implementation plan. Do not edit files. Do not run commands.

Return one verdict:
- APPROVED: plan and QA are sufficient.
- APPROVED WITH CHANGES: plan is acceptable only if the listed changes are made before implementation.
- BLOCKED: plan has a blocker, missing requirement, or unsafe ambiguity.

Review the implementation scope, risk boundaries, stop gates, and QA plan. If not APPROVED, list exact required changes only.
```

For medium, large, high-risk, or multi-round work, create a project-local packet:

```text
artifacts/claude-packets/YYYY-MM-DD-<slug>/
  manifest.md
  prompt.md
  STATUS.md
  REVIEW.md
  context/
    plan.md
    diff.patch
    tests.md
  responses/
    01-plan-review.md
    02-plan-approval.md
    03-diff-review.md
```

Example packet prompt:

```markdown
# Claude review request

You are reviewing a Codex implementation plan. Do not edit files. Do not run commands.

Return `APPROVED` only if the plan and QA coverage are sufficient. If blocked, list exact required changes.

Review:
- `manifest.md` for branch, commit, and freshness.
- `context/plan.md` for implementation scope.
- `context/tests.md` for planned verification.
```

Session reuse pattern:

```powershell
$claude = if ($env:CLAUDE_CLI_PATH) { $env:CLAUDE_CLI_PATH } else { "claude" }
$review = Get-Content -Raw .\artifacts\claude-packets\YYYY-MM-DD-<slug>\prompt.md |
  & $claude --permission-mode plan --tools "" --model opus --output-format json -p |
  ConvertFrom-Json
$claudeSessionId = $review.session_id
if (-not $claudeSessionId) { throw "Claude JSON response did not include session_id; rerun without resume or update Claude Code." }

Get-Content -Raw .\artifacts\claude-packets\YYYY-MM-DD-<slug>\next-prompt.md |
  & $claude --resume $claudeSessionId --permission-mode plan --tools "" --model opus -p
```

If `session_id` is absent, expired, or invalid, rerun that gate without `--resume` after checking `claude --version`.

Packet retention gitignore:

```gitignore
artifacts/claude-packets/**/*
!artifacts/claude-packets/**/
!artifacts/claude-packets/**/manifest.md
!artifacts/claude-packets/**/STATUS.md
!artifacts/claude-packets/**/REVIEW.md
!artifacts/claude-packets/**/responses/.retain
```

Raw responses remain ignored by default. `.retain` is only a review marker; gitignore cannot conditionally re-include `responses/*.md` when `.retain` exists. If a project intentionally retains responses, `responses/.retain` and `STATUS.md` should explain why, retained responses must be scanned for secrets, and the files should be staged explicitly with `git add -f`.

Claude output is not automatically trusted.

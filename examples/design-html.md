# Example: Design HTML

Prompt in Codex:

```text
Use claude-design-html for a read-only visual critique first, then let Codex decide which fixes to implement.
```

Implementation prompt after Codex approves scope:

```bash
claude --permission-mode acceptEdits -p "Codex has approved a scoped frontend design pass. You may edit files only in these paths: src/App.tsx src/index.css. Do not commit, push, deploy, install dependencies, edit secrets, edit lockfiles, change backend/business logic, or touch unrelated files. Improve the visual design and UX while preserving behavior. Focus on professional portfolio/demo quality, layout, spacing, typography, color, responsive behavior, component polish, and screenshot/video readiness. After editing, summarize changed files and assumptions."
```

Expected loop:

1. Codex reviews Claude's design plan.
2. Claude edits only scoped files.
3. Codex rejects out-of-scope changes.
4. Codex runs lint/build/tests.
5. Codex opens the app and checks the rendered UI.

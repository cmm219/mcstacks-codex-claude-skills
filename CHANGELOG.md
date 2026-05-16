# Changelog

## 0.2.2 - 2026-05-16

- Add Batch Autonomy project instructions for approved multi-step task scopes.
- Document optional `CLAUDE_DESIGN_CLI` support for design-enabled Claude wrappers or profiles.
- Strengthen `claude-design-loop` artifact approval, timeout handling, and mechanical-vs-design edit boundaries.

## 0.2.1 - 2026-05-14

- Add `AGENTS.md` with local project instructions for future Codex sessions.

## 0.2.0 - 2026-05-14

- Add `claude-design-loop` for strict design artifact approval loops.
- Document the full flow: Claude artifact, Codex review, user approval, app implementation, Codex QA, final user approval.
- Position local `/design-html` workflows as optional user-installed design providers.

## 0.1.1 - 2026-05-14

- Document optional local design-skill workflows for `claude-design-html`.
- Clarify that third-party design skills should remain local design-time tools and should not be vendored into app repos.
- Add example prompt for artifact-first design workflows.

## 0.1.0 - 2026-05-14

- Initial public release.
- Add `claude-readonly-review`.
- Add `claude-design-html`.
- Add Windows/macOS/Linux install and preflight scripts.
- Add safety, examples, troubleshooting, and contribution docs.

## Summary

## Safety checklist

- [ ] No secrets, tokens, private paths, or local project names.
- [ ] Claude output remains untrusted input.
- [ ] Codex remains responsible for integration and QA.
- [ ] Any write scope is explicit and bounded.
- [ ] Documentation explains data-sharing behavior where relevant.

## Verification

```bash
node scripts/validate-skills.mjs
```

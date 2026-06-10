---
name: git
description: "Enforce conventional git commit messages for claude-gitizens plugin. Single-line format <type>: <description>. Types: feat, fix, docs, chore, system. No Co-Authored-By. No trailers."
---

# Git Commit Convention

> **Goal**: Every commit must have a short, single-line message in the format `<type>: <description>`. The description should be lowercase, imperative, and under 72 characters. No multi-line bodies unless the change genuinely cannot be understood without one.

## Format

```
<type>: <short description>
```

- **type**: one of the allowed prefixes (see below)
- **description**: imperative mood, lowercase, no period at end
- **length**: aim for under 50 chars, hard limit 72 chars

## Allowed Types

| Type | When to use |
|---|---|
| `feat` | Adding a new skill, command, or capability |
| `fix` | Fixing a bug or broken behavior in a skill |
| `docs` | Changes to README or skill documentation only |
| `chore` | Maintenance tasks, config changes, cleanup |
| `system` | Plugin infrastructure: hooks, setup scripts, settings |

## Rules

1. One commit per logical change — do not bundle unrelated changes
2. Single line only — no body, no footer unless strictly necessary
3. Lowercase description — `feat: add propose skill` not `feat: Add Propose Skill`
4. Imperative mood — `fix: handle missing world state` not `fixed` or `fixes`
5. No vague messages — `chore: update` is bad, `chore: update check-access script` is good
6. **No `Co-Authored-By`** — never add this trailer
7. **No `--amend`** on pushed commits

## When a Body IS Acceptable

Only when the "why" cannot be inferred from the type + description alone.

```
fix: fall back to python3 base64 decode on Windows

base64 -d is not available in Git Bash on Windows; python3
decode is cross-platform and already required by the plugin.
```

## Examples

See `examples/` for good and bad examples per type:
- examples/feat.md
- examples/fix.md
- examples/docs.md
- examples/chore.md
- examples/system.md

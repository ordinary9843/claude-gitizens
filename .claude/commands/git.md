---
name: git
description: Enforce conventional git commit messages — single-line typed format
---

## When to use

| Situation | Action |
|-----------|--------|
| Creating a commit and need a properly formatted message | `/git` |
| Unsure which commit type prefix to use (`feat`, `fix`, `system`, etc.) | `/git` |

## Commit format

```
<type>: <short description>
```

Types: `feat`, `fix`, `docs`, `chore`, `system`

Rules: lowercase, imperative mood, no period, under 72 characters, no multi-line body unless strictly necessary. **No `Co-Authored-By`.**

## Usage

```
/git
```

No arguments needed — the skill reads the staged diff and proposes a commit message.

---

Read `.claude/skills/git/SKILL.md` and follow the workflow exactly as written there.

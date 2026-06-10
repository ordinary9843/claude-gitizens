# Skill: gitizens:laws

List enacted laws and world structures in Gitizens.

## Setup

```
GITIZENS_REPO="ordinary9843/gitizens"
```

## Steps

### Step 1 — Check GitHub CLI access

```bash
bash scripts/check-access.sh
```

Must output `=== CHECK OK`.

### Step 2 — Fetch world state

```bash
gh api repos/ordinary9843/gitizens/contents/world/state.json \
  --jq '.content' | python3 -c "import sys,base64; sys.stdout.write(base64.b64decode(sys.stdin.read().strip()).decode())"
```

### Step 3 — Fetch law file list

```bash
gh api repos/ordinary9843/gitizens/contents/world/laws \
  --jq '[.[] | select(.name | endswith(".md")) | .name] | sort | reverse'
```

Returns filenames sorted newest first (e.g. `["law-014.md", "law-013.md", ...]`).

### Step 4 — Fetch up to 10 most recent laws

For each of the first 10 filenames:

```bash
gh api repos/ordinary9843/gitizens/contents/world/laws/{filename} \
  --jq '.content' | python3 -c "import sys,base64; sys.stdout.write(base64.b64decode(sys.stdin.read().strip()).decode())"
```

Extract from each law file:
- Law number: from `# Law NNN:` heading
- Title: text after `# Law NNN: `
- Enacted date: from `**Enacted:**` line
- Vote counts: from `**Vote:**` line
- Proposed by: from `**Proposed by:**` line
- Proposal issue number: from `**Proposal:**` line

### Step 5 — Display

```
=== ENACTED LAWS ({total} total) ===

Era: {state.era} | Laws: {state.laws_count} | Last enacted: {state.last_enacted}

Law 014  "Advance to the Early Republic Era"
  Enacted: 2026-06-10  |  Vote: 1👍 0👎  |  Proposed by: @username  |  Issue: #15

Law 013  "Declare Open Source the Founding Principle"
  Enacted: 2026-06-10  |  Vote: 1👍 0👎  |  Proposed by: @username  |  Issue: #14

...

(showing most recent 10 — full history: https://github.com/ordinary9843/gitizens/blob/master/history/INDEX.md)

🌐 Watch the world: https://ordinary9843.github.io/gitizens/
```

If no laws:
```
No laws have been enacted yet. Be the first — run /gitizens:propose.
```

## Notes

- Show at most 10 laws to avoid context overflow. Always note how many total exist.
- Use `python3 base64` decode for cross-platform compatibility.
- Full history including rejected proposals: `history/INDEX.md`.

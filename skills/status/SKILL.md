# Skill: gitizens:status

Show the current state of the Gitizens nation and all open proposals.

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

Parse the JSON. Store as `STATE`.

### Step 3 — Fetch entity counts

For each category (institutions, districts, buildings, sectors), run:

```bash
gh api repos/ordinary9843/gitizens/contents/world/entities/{category}/_index.json \
  --jq '.content' | python3 -c "import sys,base64; sys.stdout.write(base64.b64decode(sys.stdin.read().strip()).decode())"
```

Extract the `count` field from each.

### Step 4 — Fetch active event (if any)

```bash
gh api repos/ordinary9843/gitizens/contents/world/active_event.json \
  --jq '.content' | python3 -c "import sys,base64; sys.stdout.write(base64.b64decode(sys.stdin.read().strip()).decode())"
```

If the result has a non-empty `title`, an event is active. Extract `title`, `fired_at`, `duration_hours`, `response_hint`.

### Step 5 — Fetch open proposals

```bash
gh issue list \
  --repo "ordinary9843/gitizens" \
  --label "proposal" \
  --state "open" \
  --json "number,title,createdAt,reactions" \
  --limit 20
```

### Step 6 — Display

Output in this format:

```
=== GITIZENS WORLD STATE ===

Era:            {state.era}
Laws enacted:   {state.laws_count}
Treasury:       {state.treasury} Git Coins
Population:     {state.population}
Stability:      {state.stability}/100
Pollution:      {state.pollution}/100

Policy metrics:
  Education:    {state.education}/100
  Industry:     {state.industry}/100
  Welfare:      {state.welfare}/100
  Green Policy: {state.green_policy}/100
  Defense:      {state.defense}/100

Structures:  {institutions} institutions | {buildings} buildings | {districts} districts | {sectors} sectors

World summary: {state.world_summary}

🌐 Live city: https://ordinary9843.github.io/gitizens/

⚡ ACTIVE EVENT: {title}                   ← only if event active
   Respond by passing any law within 4h of {fired_at}
   Hint: {response_hint}

=== OPEN PROPOSALS ({count}) ===

#{number}  {title}
  Opened: {createdAt}  |  Votes: {+1}👍 {-1}👎
  Closes in: {hours_left}h  |  https://github.com/ordinary9843/gitizens/issues/{number}

No open proposals.  (if none)
```

### Step 7 — Time remaining

For each open proposal, calculate hours remaining:
`hours_left = 24 - (now - createdAt).total_seconds() / 3600`

If `hours_left <= 0`, mark as "Tallying soon".

## Notes

- Reactions: use `reactions["+1"]` and `reactions["-1"]` from the JSON.
- Use python3 base64 decode instead of `base64 -d` for cross-platform compatibility.
- The world ticks every 4 hours automatically — treasury, population, stability all change.

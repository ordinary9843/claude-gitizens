# Skill: gitizens:propose

Submit a law proposal to the Gitizens civilization.

## Setup

```
GITIZENS_REPO="ordinary9843/gitizens"
```

## Steps

### Step 1 — Check GitHub CLI access

```bash
bash scripts/check-access.sh
```

Must output `=== CHECK OK`. If it fails, tell the user to run `gh auth login`.

### Step 2 — Show current world state

Fetch and display the world state:

```bash
gh api repos/ordinary9843/gitizens/contents/world/state.json \
  --jq '.content' | python3 -c "import sys,base64; sys.stdout.write(base64.b64decode(sys.stdin.read().strip()).decode())"
```

Show the user:
- Era, laws enacted, treasury balance
- Policy metrics: education / industry / welfare / green_policy / defense (all /100)
- Dynamic metrics: population, pollution, stability
- World summary sentence

Also fetch and check for an active event:

```bash
gh api repos/ordinary9843/gitizens/contents/world/active_event.json \
  --jq '.content' | python3 -c "import sys,base64; sys.stdout.write(base64.b64decode(sys.stdin.read().strip()).decode())"
```

If `title` field is non-empty, tell the user:
> ⚡ **Active event:** {title} — passing any law within 4 hours triggers the response outcome instead of the default consequence.

### Step 3 — Get proposal title

Ask the user:
> What do you want to propose? Give it a short title (the part after [PROPOSAL]).

Wait for their answer. Store as `PROPOSAL_TITLE`.

### Step 4 — Get description

Ask the user:
> Describe your proposal in detail. What should it do or change? Why should citizens vote for it?

Wait for their answer. Store as `PROPOSAL_DESC`.

The description must be at least 30 characters and clearly state the voting intent. If too vague, ask for more detail.

### Step 5 — Choose effect type

Ask the user:
> What kind of effect does this proposal have?
>
> - `policy` — change one or more policy metrics (education / industry / welfare / green_policy / defense). **This is the primary type.** Costs 100 Git Coins.
> - `declaration` — text-only law, no world effect. Free.
> - `evolve` — rename or annotate an existing auto-generated entity.
> - `state_patch` — directly override a world state field (treasury, era, etc.). Use sparingly.
>
> Press Enter for `declaration`.

### Step 6 — Collect effect details

**If `policy`:**

Show the current policy metric values from Step 2.
Ask: "Which metrics do you want to change, and by how much? (e.g. education +20, welfare +15)"

Rules:
- Valid metrics: education, industry, welfare, green_policy, defense
- Each change must be an integer (positive or negative)
- Max ±50 per metric per proposal
- The world engine will auto-generate or remove structures based on the resulting values

Build the YAML:
```yaml
type: policy
changes:
  {metric}: {delta}
  {metric}: {delta}
```

**If `evolve`:**

Fetch current entities:
```bash
gh api repos/ordinary9843/gitizens/contents/world/WORLD.md \
  --jq '.content' | python3 -c "import sys,base64; sys.stdout.write(base64.b64decode(sys.stdin.read().strip()).decode())"
```
Ask: "Which entity ID? (e.g. bld-001)"
Ask: "What fields do you want to change? (e.g. rename it, add a description)"
Build the YAML:
```yaml
type: evolve
id: {id}
changes:
  {field}: {value}
```

**If `state_patch`:**

Ask: "What world state fields do you want to update?"
Build the YAML:
```yaml
type: state_patch
patch:
  {field}: {value}
```

**If `declaration`:**

No YAML needed. Optionally ask if this is a constitutional law:
> Should this carry a constitutional tag? (e.g. constitution/founding-charter) — press Enter to skip.

If yes, add:
```yaml
type: declaration
tag: "constitution/{slug}"
```

### Step 7 — Compose and confirm

Show the user the full issue body:

```
Title: [PROPOSAL] {PROPOSAL_TITLE}

## Description

{PROPOSAL_DESC}

## Effect        ← omit entirely if declaration with no tag

```yaml
{EFFECT_YAML}
```
```

Ask: "Submit this proposal? (yes/no)"

If no: stop.

### Step 8 — Submit

Write the body to a temp file, then submit:

```python
# Use the Write tool:
path: skills/propose/_tmp_body.txt
content: {full body text}
```

```powershell
gh issue create `
  --repo "ordinary9843/gitizens" `
  --title "[PROPOSAL] {PROPOSAL_TITLE}" `
  --body-file skills/propose/_tmp_body.txt
```

Delete the temp file after submission:
```powershell
Remove-Item skills/propose/_tmp_body.txt -ErrorAction SilentlyContinue
```

### Step 9 — Confirm

Show the user the Issue URL returned by `gh issue create`.
Tell them:
> Your proposal is live. Voting closes in 24 hours. Watch the city: https://ordinary9843.github.io/gitizens/

## World engine reference

Buildings, districts, institutions, and sectors are **auto-generated** by the world engine
based on policy metric thresholds. Players do not place them directly.

| Metric | Threshold | Entity created |
|--------|-----------|----------------|
| education | 25 | Public School |
| education | 55 | National University |
| education | 80 | Academy of Sciences |
| industry | 25 | Manufacturing District |
| industry | 55 | Industrial Complex |
| industry | 80 | Heavy Industry Zone |
| welfare | 30 | Community Center |
| welfare | 60 | Social Housing District |
| green_policy | 35 | City Park |
| green_policy | 65 | Nature Reserve |
| green_policy | 85 | Eco-Research Center |
| defense | 30 | Military Barracks |
| defense | 65 | Defense Ministry |
| pollution | 60 | Smog Zone *(negative)* |

## Era progression

| Era | Condition |
|-----|-----------|
| Founding Era | default |
| Industrial Era | industry > 60 AND education > 50 |
| Modern Era | all policy metrics > 65 |
| Golden Age | all policy metrics > 80 AND stability > 80 |
| Crisis Age | pollution > 75 OR stability < 25 |

## Notes

- `policy` is the main gameplay type. Most proposals should use it.
- The world ticks every 4 hours: population grows, pollution drifts, stability shifts, treasury earns idle income.
- Random events fire at 15% chance per tick — if one is active, any law passed within 4h = response.
- The validator checks format and metric names within minutes of submission.

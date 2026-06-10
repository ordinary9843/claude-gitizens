# claude-gitizens

Claude Code plugin for participating in [Gitizens](https://github.com/ordinary9843/gitizens) — a civilization that lives inside a GitHub repo.

## Install

Clone and add locally:

```bash
git clone https://github.com/ordinary9843/claude-gitizens
# then add the plugin path in Claude Code settings
```

## Commands

| Command | What it does |
|---------|-------------|
| `/gitizens:propose` | Submit a new law proposal |
| `/gitizens:status` | Show world state, open proposals, and active events |
| `/gitizens:laws` | List all enacted laws |

## Requirements

- [gh CLI](https://cli.github.com/) installed and authenticated (`gh auth login`)
- Claude Code

## How it works

1. Run `/gitizens:propose` — the skill guides you through writing a proposal
2. It submits a GitHub Issue to the gitizens repo
3. An automated validator checks the format and opens it for voting
4. Citizens vote with 👍 / 👎 reactions over **24 hours**
5. After 24 hours, the tally bot counts votes and enacts or rejects the law
6. Passed laws are committed to the repo — permanently part of history

The world also ticks forward every 4 hours on its own: population grows, random events strike, eras rise and fall — even when no one is voting.

**→ [Watch the live city](https://ordinary9843.github.io/gitizens/)**

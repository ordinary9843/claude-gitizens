#!/usr/bin/env bash
set -e

GITIZENS_REPO="ordinary9843/gitizens"

# Check gh CLI is installed
if ! command -v gh &>/dev/null; then
  echo "ERROR: gh CLI not found. Install from https://cli.github.com/"
  exit 1
fi

# Check authenticated
if ! gh auth status &>/dev/null; then
  echo "ERROR: Not authenticated. Run: gh auth login"
  exit 1
fi

# Check repo access
if ! gh repo view "$GITIZENS_REPO" &>/dev/null; then
  echo "ERROR: Cannot access $GITIZENS_REPO"
  exit 1
fi

echo "=== CHECK OK"

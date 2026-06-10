#!/usr/bin/env bash
set -e

echo "Setting up claude-gitizens plugin..."

# Check gh CLI
if ! command -v gh &>/dev/null; then
  echo "Install gh CLI first: https://cli.github.com/"
  exit 1
fi

if ! gh auth status &>/dev/null; then
  echo "Run: gh auth login"
  exit 1
fi

echo "Setup complete. Try /gitizens:status to see the world."

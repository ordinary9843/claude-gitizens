#!/usr/bin/env bash
# Inject current world state as context at session start.

GITIZENS_REPO="ordinary9843/gitizens"

if ! command -v gh &>/dev/null || ! gh auth status &>/dev/null 2>&1; then
  exit 0
fi

decode_b64() {
  python -c "import sys,base64; sys.stdout.write(base64.b64decode(sys.stdin.read().strip()).decode())" 2>/dev/null \
    || python3 -c "import sys,base64; sys.stdout.write(base64.b64decode(sys.stdin.read().strip()).decode())"
}

STATE=$(gh api "repos/$GITIZENS_REPO/contents/world/state.json" \
  --jq '.content' 2>/dev/null | decode_b64 2>/dev/null) || exit 0

parse_field() {
  echo "$STATE" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get('$1','$2'))" 2>/dev/null || python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('$1','$2'))" 2>/dev/null
}

ERA=$(parse_field era "?")
LAWS=$(parse_field laws_count 0)
TREASURY=$(parse_field treasury 0)
POP=$(parse_field population 0)
STABILITY=$(parse_field stability 0)
POLLUTION=$(parse_field pollution 0)
SUMMARY=$(parse_field world_summary "")

# Check for active event
ACTIVE_EVENT=$(gh api "repos/$GITIZENS_REPO/contents/world/active_event.json" \
  --jq '.content' 2>/dev/null | decode_b64 2>/dev/null) || ACTIVE_EVENT="{}"

EVENT_TITLE=$(echo "$ACTIVE_EVENT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('title',''))" 2>/dev/null)

cat <<EOF
=== GITIZENS WORLD ===
Era: $ERA  |  Laws: $LAWS  |  Treasury: ${TREASURY} GC
Population: $POP  |  Stability: $STABILITY/100  |  Pollution: $POLLUTION/100
$SUMMARY
EOF

if [ -n "$EVENT_TITLE" ]; then
  cat <<EOF
⚡ ACTIVE EVENT: $EVENT_TITLE — pass a law within 4h to respond!
EOF
fi

echo "====================="
EOF

#!/usr/bin/env bash
# Inject current world state as context at session start.

GITIZENS_REPO="ordinary9843/gitizens"

if ! command -v gh &>/dev/null || ! gh auth status &>/dev/null 2>&1; then
  exit 0
fi

# Resolve python binary — prefers python3, falls back to python (Windows)
_python() {
  if command -v python3 &>/dev/null; then
    python3 "$@"
  elif command -v python &>/dev/null; then
    python "$@"
  else
    return 1
  fi
}

decode_b64() {
  _python -c "import sys,base64; sys.stdout.write(base64.b64decode(sys.stdin.read().strip()).decode())"
}

parse_json() {
  _python -c "import sys,json; d=json.load(sys.stdin); print(d.get('$1','$2'))" 2>/dev/null
}

STATE=$(gh api "repos/$GITIZENS_REPO/contents/world/state.json" \
  --jq '.content' 2>/dev/null | decode_b64 2>/dev/null) || exit 0

ERA=$(echo "$STATE"     | parse_json era "?")
LAWS=$(echo "$STATE"    | parse_json laws_count 0)
TREASURY=$(echo "$STATE"| parse_json treasury 0)
POP=$(echo "$STATE"     | parse_json population 0)
STABILITY=$(echo "$STATE" | parse_json stability 0)
POLLUTION=$(echo "$STATE" | parse_json pollution 0)
SUMMARY=$(echo "$STATE" | parse_json world_summary "")

ACTIVE_EVENT=$(gh api "repos/$GITIZENS_REPO/contents/world/active_event.json" \
  --jq '.content' 2>/dev/null | decode_b64 2>/dev/null) || ACTIVE_EVENT="{}"
EVENT_TITLE=$(echo "$ACTIVE_EVENT" | parse_json title "")

echo "=== GITIZENS WORLD ==="
echo "Era: $ERA  |  Laws: $LAWS  |  Treasury: ${TREASURY} GC"
echo "Population: $POP  |  Stability: $STABILITY/100  |  Pollution: $POLLUTION/100"
[ -n "$SUMMARY" ] && echo "$SUMMARY"
[ -n "$EVENT_TITLE" ] && echo "ACTIVE EVENT: $EVENT_TITLE -- pass a law within 4h to respond!"
echo "======================"

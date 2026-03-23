#!/bin/bash
# Injects vault status into every Claude session started from the claudia project.
# Uses direct file access (Obsidian may not be open at Claude startup).

VAULT="/Users/iain.maitland/Documents/Obsidian Vault"
TODAY=$(date +%Y-%m-%d)
YEAR=$(date +%Y)
MONTH=$(date +%m)
DAY_FILE="$VAULT/Daily Notes/$YEAR/$MONTH/$TODAY.md"

TODAY_NOTES=$(find "$VAULT/Notes" -name "$TODAY-*.md" 2>/dev/null | wc -l | tr -d ' ')
NOTE_STATUS=$([ -f "$DAY_FILE" ] && echo "exists" || echo "not created yet")

cat <<EOF
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "PKB: Today is $TODAY. Daily note: $NOTE_STATUS. Notes created today: $TODAY_NOTES. Use /daily for full briefing."
  }
}
EOF

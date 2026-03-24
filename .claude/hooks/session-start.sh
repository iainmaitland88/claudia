#!/bin/bash
# Injects vault status into every Claude session started from the claudia project.
# Uses direct file access (Obsidian may not be open at Claude startup).

VAULT="/Users/iain.maitland/Documents/Obsidian Vault"
TODAY=$(date +%Y-%m-%d)
YEAR=$(date +%Y)
MONTH=$(date +%m)
DAY_FILE="$VAULT/$YEAR/$MONTH/$TODAY.md"
TASKS_FILE="$VAULT/Atlas/Tasks.md"
WORK_FILE="$VAULT/Atlas/Work.md"

TODAY_NOTES=$(find "$VAULT/Notes" -name "$TODAY-*.md" 2>/dev/null | wc -l | tr -d ' ')
NOTE_STATUS=$([ -f "$DAY_FILE" ] && echo "exists" || echo "not created yet")

# Count open tasks
OPEN_TASKS=0
OVERDUE_TASKS=0
if [ -f "$TASKS_FILE" ]; then
  OPEN_TASKS=$(grep -c '^\- \[ \]' "$TASKS_FILE" 2>/dev/null || echo 0)
  # Count overdue tasks (lines with Due: YYYY-MM-DD where date < today)
  while IFS= read -r line; do
    due=$(echo "$line" | grep -oE 'Due: [0-9]{4}-[0-9]{2}-[0-9]{2}' | cut -d' ' -f2)
    if [ -n "$due" ] && [[ "$due" < "$TODAY" ]]; then
      OVERDUE_TASKS=$((OVERDUE_TASKS + 1))
    fi
  done < <(grep '^\- \[ \]' "$TASKS_FILE" 2>/dev/null)
fi

# Days since last weekly review
LAST_WEEKLY=$(find "$VAULT/Notes" -name "weekly-*.md" -print 2>/dev/null | sort -r | head -1)
if [ -n "$LAST_WEEKLY" ]; then
  WEEKLY_DATE=$(basename "$LAST_WEEKLY" | grep -oE '[0-9]{4}-W[0-9]{2}')
  DAYS_SINCE_WEEKLY="(last: $WEEKLY_DATE)"
else
  DAYS_SINCE_WEEKLY="(none found)"
fi

# Last work log date
LAST_WORK=""
if [ -f "$WORK_FILE" ]; then
  LAST_WORK=$(grep -oE '[0-9]{4}-[0-9]{2}-[0-9]{2}' "$WORK_FILE" | sort -r | head -1)
fi
WORK_STATUS=""
if [ -n "$LAST_WORK" ]; then
  WORK_STATUS="Last work log: $LAST_WORK."
else
  WORK_STATUS="No work logs yet."
fi

# Build status line
STATUS="PKB: Today is $TODAY. Daily note: $NOTE_STATUS. Notes created today: $TODAY_NOTES."
STATUS="$STATUS Open tasks: $OPEN_TASKS."
[ "$OVERDUE_TASKS" -gt 0 ] && STATUS="$STATUS OVERDUE: $OVERDUE_TASKS."
STATUS="$STATUS $WORK_STATUS Weekly review $DAYS_SINCE_WEEKLY."
STATUS="$STATUS Use /daily for full briefing."

cat <<EOF
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "$STATUS"
  }
}
EOF

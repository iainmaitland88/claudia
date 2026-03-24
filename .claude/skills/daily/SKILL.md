---
name: daily
description: Morning planning session - reads recent vault activity, flags urgent items, plans the day
argument-hint: [optional focus area for today]
---

Run a morning planning session. Today's date: !`date +%Y-%m-%d`.

## Steps

1. **Read yesterday's daily note** (if it exists):
   ```bash
   obsidian read path="$(date -v-1d +%Y/%m/%Y-%m-%d).md"
   ```

2. **Read today's daily note** (if it exists):
   ```bash
   obsidian daily:read
   ```

3. **Check Tasks** for due dates and overdue items:
   ```bash
   obsidian read file="Atlas/Tasks"
   ```
   Parse all unchecked (`- [ ]`) lines. Flag anything with `Due:` date on or before today as OVERDUE. Flag anything due within 7 days as "Coming up".

4. **Check unrefined ideas** for stale items:
   ```bash
   obsidian read file="Atlas/Ideas"
   ```
   Find all lines under `## Unrefined`. Compare the `Added:` date to today — flag anything older than 7 days.

5. **Check Work atlas** for last entry date:
   ```bash
   obsidian read file="Atlas/Work"
   ```
   Note the most recent entry date. Flag if it's been more than 3 working days.

6. **Check for recent weekly review**:
   ```bash
   obsidian search query="type:weekly-review" --output json
   ```
   If none found in the last 10 days, flag it.

7. **Check for stale active projects**:
   ```bash
   obsidian search query="tag:status/refined" --output paths
   ```
   Read each project note. Check the `## Work entries` section — find the most recent date listed. If no work entry has been linked in 14+ days, flag the project as stalling.

## Output Format

```
## Morning Briefing — [date]

**Urgent**
[OVERDUE tasks and tasks due today/tomorrow — or "Nothing urgent"]

**Coming up** (due within 7 days)
[List or "None"]

**Yesterday's loose ends**
[Unchecked tasks from yesterday's daily note, or "None found"]

**Idea signals**
- Ideas: [N] unrefined, [N] stale (>7d)
- Last work note: [date] ([ok / FLAG: X days ago])
- Last weekly review: [date] ([ok / FLAG: overdue])

**Stalling projects**
[Projects with no work entry in 14+ days — or "None"]

**Suggested focus**
[1-3 bullets based on the above signals — specific, not generic]
```

If $ARGUMENTS was provided, incorporate it as today's stated focus area.

After showing the briefing, ask: "Want me to create today's daily note with this context pre-filled?"

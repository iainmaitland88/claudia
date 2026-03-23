---
name: review-goals
description: Review long-term goals by persona — analyses trend data and suggests adjustments
argument-hint: [health|sleep|fitness|diet|all]
---

Review goals. Today: !`date +%Y-%m-%d`.
Persona requested: $ARGUMENTS (default: all if blank)

## Steps

For each goal to review (one or all four):

1. Read the goal note:
   ```bash
   obsidian read file="Notes/goal-[persona]"
   ```

2. Extract from the **Data Log** table:
   - All date/value pairs
   - Calculate total entries, trend direction, rate of change
   - Compare rate to target rate (derive from goal frontmatter: `target` and `metric`)
   - Days since last log entry
   - Consistency: how many of the last 14 days have an entry (if daily metric)

3. Read the **Current Approach** and **Recent Adjustments** sections for context.

4. Read the **Commitments This Week** checkboxes.

## Output Per Persona

```
### [Persona] — [goal summary from note]

**Target**: [target value] by [date] — [N weeks remaining]
**Progress**: [start] → [latest value] ([+/- total change])
**Rate**: [actual rate, e.g. -0.4kg/week] vs [needed rate, e.g. -0.5kg/week]
**On pace**: Yes / Behind — [projected completion date at current rate]
**Consistency**: [N/14 days logged] — [consistent / gaps / sporadic]

**Assessment**: [1-3 honest sentences based on the data — no fluff]

**This week's commitments**:
[List the checkboxes from the note]

**Suggested adjustment** *(only shown if trend is flat or worsening for 2+ weeks)*:
[One specific, evidence-based suggestion grounded in the note's context]
```

## After Output

Ask:
1. "Want to log a new data point?" — if yes, append a row to the Data Log table
2. "Want to adjust the current approach?" — if yes, edit the Current Approach and add a row to Recent Adjustments
3. "Want me to log today's review in the Review History?" — if yes:
   ```bash
   obsidian append file="Notes/goal-[persona]" content="| [date] | [trend summary] | [one-line assessment] |"
   ```
   Then update the `last-reviewed` frontmatter:
   ```bash
   obsidian properties:set file="Notes/goal-[persona]" key="last-reviewed" value="[date]"
   ```

---

**Rules:**
- Suggestions only when data supports them (flat/worsening 2+ weeks)
- No lectures, no motivational language
- If no data log entries exist or last entry > 30 days ago, flag prominently: "No recent data — can't assess trend. Want to log something now?"

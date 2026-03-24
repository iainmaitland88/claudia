---
name: weekly
description: Weekly review - flags forgotten ideas/tasks, summarises the week
---

Run a weekly review. Today: !`date +%Y-%m-%d`. Current week: !`date +%Y-W%V`.

## Steps

1. **Read daily notes from the past 7 days**:
   ```bash
   obsidian search query="type:daily after:[7 days ago]" --output paths
   ```
   Read each one found.

2. **Read the Work atlas** for entries added this week:
   ```bash
   obsidian read file="Atlas/Work"
   ```

3. **Read Tasks** for overdue and upcoming items:
   ```bash
   obsidian read file="Atlas/Tasks"
   ```
   Parse all open items. Flag overdue (past due date) and due within 7 days.

4. **Find stale unrefined ideas** (> 7 days old):
   ```bash
   obsidian read file="Atlas/Ideas"
   ```
   Check the `## Unrefined` section. For each linked note, read it and check its `date:` frontmatter.

5. **Check last weekly review**:
   ```bash
   obsidian search query="type:weekly-review" --output json
   ```

## Output Format

```
## Weekly Review — [week]

### What Got Done This Week
[Real achievements from work notes and daily notes — specific, not vague]

### Tasks
**Overdue:** [list with days past due, or "None"]
**Due this week:** [list or "None"]

### Unrefined Ideas (> 7 days old)
For each stale idea:
- [[note-name]] — added [N] days ago — Keep & act / Archive?

### Flags
[Anything else that needs attention — no weekly review in 10+ days, work log gap, etc.]
```

## After Showing

1. For each stale idea, ask: "Keep and assign a next task, or archive?"
   - If keeping: update the note's tag from `#status/unrefined` to `#status/refined` using:
     ```bash
     obsidian properties:set file="[note]" key="tags" value="..."
     ```
   - If archiving: move to Archive/ and update Atlas/Ideas.md

2. Ask: "Save this as a weekly review note?"
   If yes, create:
   ```bash
   obsidian create name="weekly-[YYYY-WNN]" path="Notes/" content="[full review output]"
   ```
   Set `type: weekly-review` in frontmatter.

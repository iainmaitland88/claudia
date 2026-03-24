---
name: checkin
description: End-of-day check-in — pulls GitHub activity, compares to existing logs, and creates missing entries
argument-hint: [optional: additional things you did today]
---

End-of-day check-in. Today: !`date +%Y-%m-%d`.

## Steps

1. **Pull GitHub activity** for today and yesterday:
   ```bash
   gh search prs --author @me --merged --merged-at ">=!`date -v-1d +%Y-%m-%d`" --json title,url,repository,updatedAt --limit 50
   ```

2. **Pull open PRs** you're waiting on:
   ```bash
   gh search prs --author @me --state open --json title,url,repository,updatedAt --limit 20
   ```

3. **Read existing work logs** to avoid duplicates:
   ```bash
   obsidian search query="tag:status/done" --output paths
   ```
   Read any notes dated today or yesterday. Compare PR titles/URLs against existing logs to identify what's already been captured.

4. **Show a summary table**:
   ```
   ## Check-in — [date]

   **Merged PRs (last 24h)**
   | PR | Repo | Logged? |
   |---|---|---|
   | [title] | [repo] | Yes / No |

   **Open PRs** (waiting on review/merge)
   | PR | Repo | Status |
   |---|---|---|
   | [title] | [repo] | [draft/review requested/approved] |
   ```

5. **Ask**: "Anything else to log that isn't on GitHub? (meetings, conversations, decisions)"
   Incorporate $ARGUMENTS here if provided.

6. **For each unlogged PR or additional item**, run the /log flow:
   - Parse what/impact/tag (infer impact from PR title and context)
   - Use the PR's merge date as the log date, not today's date
   - Create the note via `obsidian create`
   - Check for related projects and link them
   - Append to Work atlas

7. **Update today's daily note** with a check-in summary:
   ```bash
   obsidian daily:append content="
   ## End-of-day check-in
   - [N] PRs merged
   - [N] new work entries logged
   - [N] PRs still open
   "
   ```

8. **Confirm**: "Check-in done. [N] new entries logged, [N] PRs still open."

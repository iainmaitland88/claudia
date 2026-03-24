---
name: checkin
description: End-of-day check-in — pulls GitHub activity, compares to existing logs, and creates missing entries
argument-hint: [optional: additional things you did today]
---

End-of-day check-in. Today: !`date +%Y-%m-%d`.

This is an interactive, conversational skill. Wait for the user's response at each prompt before continuing.

## Steps

### Phase 1 — GitHub scan

1. **Pull merged PRs** authored by or contributed to by the user in the last 24h:
   ```bash
   gh search prs --author @me --merged --merged-at ">=!`date -v-1d +%Y-%m-%d`" --json title,url,repository,updatedAt --limit 50
   ```

2. **Read existing work logs** to identify what's already been captured:
   ```bash
   obsidian search query="tag:status/done" --output paths
   ```
   Read any notes dated today or yesterday. Compare PR titles/URLs against existing logs.

3. **Show the PR list** with numbers, filtering out already-logged PRs:
   ```
   ## Check-in — [date]

   **Merged PRs (last 24h)**
   1. [title] — [repo]
   2. [title] — [repo]
   3. [title] — [repo]

   [N] already logged, not shown.
   ```

   If there are no unlogged PRs, say "No new merged PRs found" and skip to Phase 2.

4. **Ask**: "Which PRs do you want to log? (e.g. 1,3 / all / none)"

   Wait for the user's response. Accept:
   - Comma-separated numbers: "1,3" → log PRs 1 and 3
   - "all" → log all listed PRs
   - "none" → skip PR logging

5. **For each selected PR**, run the /log flow:
   - Parse what/impact/tag (infer impact from PR title and context)
   - Use the PR's merge date as the log date, not today's date
   - Create the note via `obsidian create`
   - Check for related projects and link them
   - Append to Work atlas

### Phase 2 — Manual additions

6. **Ask**: "Anything else to log? (meetings, conversations, decisions, anything not on GitHub)"

   If $ARGUMENTS was provided and hasn't been incorporated yet, mention it: "You mentioned: [ARGUMENTS] — want me to log that?"

   Wait for the user's response.

7. **If the user describes something to log**, run the /log flow for it, then ask: "Anything else?"

   **Repeat step 7** until the user says no, they're done, or similar.

### Phase 3 — Project review

8. **Load active projects**:
   ```bash
   obsidian search query="tag:status/refined" --output paths
   ```
   Read each project note.

9. **For each active project**, show the project name and its current steps checklist, then ask:
   "Any updates to **[[project-name]]**? (e.g. mark steps done, add/edit/remove steps, or skip)"

   Wait for the user's response. For each project:
   - If steps need marking done: update `- [ ]` to `- [x]` in the project note
   - If steps need adding/editing/removing: edit the project note accordingly
   - If all steps are now complete: ask "All steps are done — is this project finished?" If yes, change the tag from `status/refined` to `status/done` and move it from "Active" to "Archived" in `Atlas/Ideas.md`
   - If the user says skip: move to the next project

   If there are no active projects, say "No active projects" and skip to Phase 4.

### Phase 4 — Tasks

10. **Ask**: "Any tasks to capture or reminders to set? (e.g. 'Reply to Dave's email by Friday', 'Review the CI plan next week')"

    Wait for the user's response.

11. **If the user describes a task**, run the /task flow for it, then ask: "Any other tasks?"

    **Repeat step 11** until the user says no, they're done, or similar.

### Phase 5 — Wrap up

12. **Update today's daily note** with a check-in summary:
    ```bash
    obsidian daily:append content="
    ## End-of-day check-in
    - [N] new work entries logged
    - [N] projects reviewed
    - [N] tasks captured
    "
    ```

13. **Confirm**: "Check-in done. Have a good evening."

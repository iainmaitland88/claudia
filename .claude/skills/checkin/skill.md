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
   gh search prs --author @me --merged --merged-at ">=!`date -v-1d +%Y-%m-%d`" --json title,url,repository,updatedAt,headRefName --limit 50
   ```

   Also **pull open PRs** authored by the user:
   ```bash
   gh search prs --author @me --state open --json title,url,repository,createdAt,headRefName --limit 20
   ```

   Also **pull PRs reviewed** by the user in the last 24h:
   ```bash
   gh search prs --reviewed-by @me --merged --merged-at ">=!`date -v-1d +%Y-%m-%d`" --json title,url,repository --limit 20
   ```
   Filter out any PRs that are also in the authored list (don't double-count).

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

   **Open PRs**
   - [title] — [repo] — opened [N] days ago [⚠️ if >3 days]

   **PRs you reviewed**
   - [title] — [repo]
   ```

   Open PRs are shown for awareness only — they are not logged.
   For reviewed PRs, ask: "Want to log any reviews as work? (e.g. 'review-1' for work/led)"

   If there are no unlogged merged PRs, say "No new merged PRs found" and skip to Phase 2.

4. **Ask**: "Which PRs do you want to log? You can group related PRs into a single entry. (e.g. 1,3 / all / 1+2 as one, 3 / none)"

   Wait for the user's response. Accept:
   - Comma-separated numbers: "1,3" → log PRs 1 and 3 as separate entries
   - Groups: "1+2 as one, 3" → log PRs 1 and 2 as a single entry, PR 3 as another
   - "all" → log all listed PRs (suggest groupings if PRs look related — same feature across repos, version bumps paired with the change they support, etc.)
   - "none" → skip PR logging

   When suggesting groupings for "all", look for signals like:
   - PRs in different repos that reference the same feature/ticket
   - A library bump PR paired with the PR that uses the new version
   - Multiple PRs that are sequential steps in the same piece of work

5. **For each entry** (single PR or grouped PRs), run the /log flow:
   - Parse what/impact/tag — for grouped PRs, write a single unified description covering the whole piece of work
   - Use the earliest PR's merge date as the log date
   - Include all PR links as a bullet list under the **PRs** field
   - **Jira ticket extraction**: check the PR branch name (`headRefName`) for a ticket-like prefix (e.g. `ef-123/some-feature` → ticket is `EF-123`). Also check the PR description for ticket references. If found, ask the user to confirm: "Jira ticket EF-123?" If confirmed, add `ticket: EF-123` to the note's YAML frontmatter.
   - Create the note via `obsidian create`
   - Check for related projects and link them
   - Insert into the correct quarter in the Work atlas (follow the same quarter-routing logic as `/log` step 6)

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

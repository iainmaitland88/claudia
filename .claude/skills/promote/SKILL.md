---
name: promote
description: Promote an inbox idea to an active project with a checklist of steps
argument-hint: <idea name or partial title>
---

Promote an idea to an active project. Today: !`date +%Y-%m-%d`.

Input: $ARGUMENTS

## Steps

1. Find the idea note:
   ```bash
   obsidian search query="type:idea tag:#status/inbox" --output paths
   ```
   If $ARGUMENTS is provided, filter results by name matching $ARGUMENTS.
   If multiple matches or no $ARGUMENTS, list them and ask: "Which idea do you want to promote?"

2. Read the matching note:
   ```bash
   obsidian read file="[note-name]"
   ```
   Show the current note content and confirm: "Is this the idea you want to promote?"

3. Ask: "What are the steps to complete this? List them one per line."

4. Update the note — change `type: idea` → `type: project`, `#status/inbox` → `#status/active`, and add sections:
   ```bash
   obsidian properties:set file="[note-name]" key="type" value="project"
   ```
   Then append the steps and work entries sections:
   ```bash
   obsidian append file="[note-name]" content="
   ## Steps
   - [ ] [step 1]
   - [ ] [step 2]
   ...

   ## Work entries
   "
   ```

5. Update Atlas/Ideas.md — move the link from `## Inbox (unactioned)` to `## Active`:
   Read the file, edit the line, write it back.

6. Confirm: "[[note-name]] is now an active project with [N] steps."

---

As the project progresses, `/log` entries will be linked back to this note under `## Work entries`.
When all steps are done, tell Claude to mark it as complete — it will update the tag to `#status/done` and move it to `## Archived` in the Ideas atlas.

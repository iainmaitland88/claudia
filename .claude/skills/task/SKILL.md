---
name: task
description: Log a concrete task with an optional deadline — surfaces in daily briefings
argument-hint: <task description, optionally including a deadline>
---

Capture a task. Today: !`date +%Y-%m-%d`.

Input: $ARGUMENTS

## Steps

1. If $ARGUMENTS is empty, ask: "What do you need to do?"

2. Extract the task description and any due date mentioned:
   - "before April 17th" → `2026-04-17`
   - "by end of month" → last day of current month
   - "next Friday" → calculate the date

3. If no due date was mentioned, ask: "Is there a deadline? (Fine if not.)"

4. Determine whether this needs a **line item** or a **full note**:
   - **Line item** (default): task is one sentence, no context/links/files mentioned
   - **Full note**: context, background, links, or files were mentioned in the input

### 5a — Line item

```bash
obsidian append file="Atlas/Tasks" content="- [ ] [task description] | Due: YYYY-MM-DD"
```
(Omit `| Due:` part if no deadline.)

Example: `/task Review outstanding PRs in EF BE repo by March 25th` →
```bash
obsidian append file="Atlas/Tasks" content="- [ ] Review outstanding PRs in EF BE repo | Due: 2026-03-25"
```

### 5b — Full note

Create the note:
```bash
obsidian create name="[date]-[slug]" path="Notes/" content="---
date: [date]
type: task
due: [date or leave blank]
tags: [task, status/active]
---
# [Task title]

**Due**: [date or —]

## What to do
[task description]

## Links

## Notes
[any context provided in the input]

## Files
"
```

Then link it from the Tasks atlas:
```bash
obsidian append file="Atlas/Tasks" content="- [ ] [[date-slug]] | Due: YYYY-MM-DD"
```

6. Confirm: "Added. You have [N] open tasks."

---

**Expanding a line item to a note**: If the user asks to "expand" an existing line item, create the full note for it, then update Atlas/Tasks.md — replace the plain-text line with `[[note-slug]]`.

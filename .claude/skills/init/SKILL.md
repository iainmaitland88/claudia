---
name: init
description: Initialise claudia for a new user — sets up paths, vault structure, and cron reminder
---

Welcome to claudia. This will configure the system for your machine.

Do NOT use the Obsidian CLI during this skill — it won't be set up yet. Use Read, Edit, Write, and Bash tools only.

---

## Step 1 — Detect the project path

Run:
```bash
pwd
```
This is the claudia project directory. Store it — you'll need it for the cron entry.

---

## Step 2 — Questionnaire

Ask the following questions **one at a time**, waiting for each answer before proceeding.

---

**Q1: What's your name?**

This is used to personalise CLAUDE.md.

---

**Q2: Where is your Obsidian vault?**

First, try to auto-detect by searching for Obsidian vaults on the machine:
```bash
find ~ -name ".obsidian" -maxdepth 5 -type d 2>/dev/null | sed 's|/.obsidian||'
```

If one or more vaults are found, show them as options:
> "Found these Obsidian vaults:
> 1. /Users/you/Documents/Obsidian Vault
> 2. /Users/you/Documents/Notes
> Which one, or enter a custom path?"

If none are found, ask:
> "No Obsidian vault found automatically. What's the full path to your vault? (e.g. ~/Documents/Obsidian Vault)"

Expand `~` to the full home directory path before using it.

---

**Q3: When do you want your weekly review reminder?**

Ask for the day:
> "Which day should the weekly review reminder fire? (e.g. Friday, Sunday)"

Then the time:
> "What time? (e.g. 4:30pm, 17:00)"

Convert to cron format:
- Day names → numbers: Monday=1, Tuesday=2, Wednesday=3, Thursday=4, Friday=5, Saturday=6, Sunday=0
- Time → `MINUTE HOUR`: e.g. "4:30pm" → `30 16`, "9am" → `0 9`, "17:00" → `0 17`

---

**Q4: What kind of work do you do?**

This goes into CLAUDE.md so Claude understands what counts as a meaningful work achievement.

> "What's your role? (e.g. software engineer, product manager, designer — a sentence is fine)"

---

## Step 3 — Update project files

### 3a. Update CLAUDE.md

Read the current CLAUDE.md:
```bash
cat CLAUDE.md
```

Make these replacements:
- Replace the `Vault` path with the vault path from Q2
- Replace the `Who` section with the user's name and role from Q1 and Q4
- Replace the `goal-health.md`, `goal-sleep.md`, `goal-fitness.md`, `goal-diet.md` paths to use the correct vault path

Use the Edit tool to make these changes precisely.

### 3b. Update session-start.sh

Read `.claude/hooks/session-start.sh` and update the `VAULT=` line with the correct path.

Use the Edit tool.

### 3c. Update weekly-reminder.sh

Read `scripts/weekly-reminder.sh` and update the notification message to include the correct project path (so the user can copy-paste the `cd` command from the notification).

Use the Edit tool.

### 3d. Make scripts executable

```bash
chmod +x .claude/hooks/session-start.sh scripts/weekly-reminder.sh
```

---

## Step 4 — Create vault folder structure

```bash
mkdir -p "[VAULT]/00-Inbox" \
  "[VAULT]/Notes" \
  "[VAULT]/Atlas" \
  "[VAULT]/Archive" \
  "[VAULT]/Daily Notes/Templates"
```

---

## Step 5 — Seed vault files

Only create each file if it does not already exist. Check with:
```bash
test -f "[VAULT]/Atlas/Work.md" && echo "exists" || echo "missing"
```

Create any missing files with the following contents:

### `Atlas/Work.md`

```markdown
# Work

Map of all work achievement notes. Primary source for performance review summaries.

## 2026

### Q1 (Jan–Mar)

### Q2 (Apr–Jun)

### Q3 (Jul–Sep)

### Q4 (Oct–Dec)

---

## Tags
#work/shipped — #work/unblocked — #work/led — #work/learned — #work/improved
```

### `Atlas/Ideas.md`

```markdown
# Ideas

Map of all idea notes. Reviewed weekly — stale inbox items get a decision.

## Inbox (unactioned)

## Active

## Archived
```

### `Atlas/Actions.md`

```markdown
# Actions

One-off tasks with deadlines. Reviewed daily — overdue items are flagged immediately.

## Open

## Done
```

### `Atlas/Goals.md`

```markdown
# Goals

- [[goal-health]] — physical health, weight, energy
- [[goal-sleep]] — sleep quality and consistency
- [[goal-fitness]] — exercise, strength, endurance
- [[goal-diet]] — nutrition and eating habits
```

### `Atlas/Knowledge.md`

```markdown
# Knowledge

## Engineering

## Process & Craft

## Personal

## Reference
```

### `Notes/goal-health.md`, `Notes/goal-sleep.md`, `Notes/goal-fitness.md`, `Notes/goal-diet.md`

Same template for each (substitute `health`/`sleep`/`fitness`/`diet` and `#goal/TAG`):

```markdown
---
type: goal
persona: health
tags:
  - "#goal/health"
last-reviewed: ""
target: ""
metric: ""
---

# Health

## Goal

## Why It Matters

## Current Approach

## Recent Adjustments

| Date | Change | Why |
|------|--------|-----|

## Commitments This Week

- [ ]

## Data Log

| Date | Value | Notes |
|------|-------|-------|

## Review History

| Date | Trend | Assessment |
|------|-------|------------|
```

### `Daily Notes/Templates/Daily Note.md`

```markdown
---
date: {{date:YYYY-MM-DD}}
type: daily
---

# {{date:dddd, MMMM D, YYYY}}

## Focus
> What's the one thing that makes today a success?

## Tasks
- [ ]

## Morning Metrics
> Log any tracked goal metrics here (e.g. weight, sleep hours)

## Notes & Ideas
> Anything worth capturing? Use /idea or /action if it needs tracking.

## Work
> Anything shipped or unblocked today? Use /log to record it.

## End of Day
- [ ] Anything worth logging with /log?
- [ ] Any new ideas captured?
- [ ] Inbox cleared or triaged?
```

---

## Step 6 — Set up the cron job

Check if a claudia cron entry already exists:
```bash
crontab -l 2>/dev/null | grep -c "claudia"
```

If it already exists, show it and ask: "A claudia cron entry already exists. Replace it?"

To install or replace:
```bash
(crontab -l 2>/dev/null | grep -v "claudia"; echo "[MINUTE] [HOUR] * * [DAY] [PROJECT_PATH]/scripts/weekly-reminder.sh") | crontab -
```

Confirm it was set:
```bash
crontab -l | grep claudia
```

---

## Step 7 — Summary

Print a setup summary:

```
## Setup complete

**Project**: [claudia project path]
**Vault**: [vault path]
**Weekly reminder**: [day] at [time]

### Done automatically
- [x] CLAUDE.md updated
- [x] session-start.sh updated
- [x] Vault folders created
- [x] Atlas and Notes files seeded
- [x] Weekly reminder cron job installed

### Do these manually in Obsidian (takes ~2 minutes)

1. **Enable the CLI**
   Settings → General → Command line interface → Register CLI
   Then test: run `obsidian --version` in your terminal

2. **Set the daily note template**
   Settings → Daily Notes → Template file → `Daily Notes/Templates/Daily Note`

3. **Install the Dataview plugin** (recommended)
   Settings → Community Plugins → Browse → Dataview → Install → Enable

### You're ready. Start with:
   cd [claudia project path] && claude
   /daily
```

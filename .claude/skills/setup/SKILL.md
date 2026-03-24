---
name: setup
description: Initialise claudia for a new user — walks through prerequisites, then uses the Obsidian CLI to set up the vault
---

Welcome to claudia. This will configure the system for your machine.

---

## Phase 1 — Prerequisites (requires user action)

### Step 1 — Detect the project path

```bash
pwd
```

Store this as PROJECT_PATH — you'll need it throughout.

### Step 2 — Check Obsidian is installed

```bash
which obsidian 2>/dev/null || echo "not found"
```

If not found, tell the user:

> **Before we continue, you need Obsidian installed with the CLI enabled.**
>
> 1. Download and install Obsidian from https://obsidian.md (v1.12.4 or later)
> 2. Open Obsidian and create a vault (or open an existing one)
> 3. Go to **Settings → General → Command line interface → Register CLI**
> 4. Come back here and tell me when you're done.

**Wait for the user to confirm before continuing.**

### Step 3 — Verify CLI is working

```bash
obsidian version
```

If this fails, the CLI isn't registered. Ask the user to check the Obsidian setting and try again. Do NOT proceed until this command succeeds.

---

## Phase 2 — Questionnaire

Ask the following questions **one at a time**, waiting for each answer.

**Q1: What's your name?**

Used to personalise CLAUDE.md.

---

**Q2: Where is your Obsidian vault?**

Auto-detect first:
```bash
obsidian vaults
```

Show the results and ask which vault to use, or let them enter a custom path. Store the vault name and path.

If they need to target a specific vault in later CLI commands, use `vault="VAULT_NAME"` parameter.

---

**Q3: When do you want your daily check-in reminder?**

> "What time should I remind you to do your end-of-day check-in? This runs Monday–Friday. (e.g. 5pm, 17:30)"

Convert to cron format:
- Time → `MINUTE HOUR`: e.g. "5pm" → `0 17`, "5:30pm" → `30 17`

---

**Q4: When do you want your weekly review reminder?**

Ask for the day:
> "Which day for the weekly review reminder? (e.g. Friday, Sunday)"

Then the time:
> "What time? (e.g. 4:30pm, 17:00)"

Convert to cron format:
- Day names → numbers: Monday=1, Tuesday=2, Wednesday=3, Thursday=4, Friday=5, Saturday=6, Sunday=0
- Time → `MINUTE HOUR`: e.g. "4:30pm" → `30 16`, "9am" → `0 9`

**Overlap check:** If the weekly review lands on a weekday at the same time as the daily check-in, the weekly review replaces the daily check-in on that day. On Fridays at 5pm you don't need both — `/weekly` covers everything `/checkin` does plus more. Exclude the weekly review day from the daily check-in cron (e.g. if weekly is Friday, daily runs Mon–Thu only).

---

**Q5: What kind of work do you do?**

> "What's your role? (e.g. software engineer, product manager, designer — a sentence is fine)"

---

## Phase 3 — Update project files

Use the Read and Edit tools for these.

### 3a. Update CLAUDE.md

Read `CLAUDE.md` and update:
- The `Vault` path with the vault path from Q2
- The `Who` section with the user's name (Q1) and role (Q4)

### 3b. Update session-start.sh

Read `.claude/hooks/session-start.sh` and update the `VAULT=` line with the correct vault path.

### 3c. Update checkin-reminder.sh

Read `scripts/checkin-reminder.sh` and update the notification message to include the correct project path.

### 3d. Update weekly-reminder.sh

Read `scripts/weekly-reminder.sh` and update the notification message to include the correct project path.

### 3e. Make scripts executable

```bash
chmod +x .claude/hooks/session-start.sh scripts/checkin-reminder.sh scripts/weekly-reminder.sh
```

---

## Phase 4 — Create vault structure via Obsidian CLI

Use the Obsidian CLI for all vault operations from this point on. If the user has multiple vaults, add `vault="VAULT_NAME"` to each command.

Folders are created automatically when files are created via `obsidian create path=`. Most folders will be created when seeding files below. For the empty `Archive/` folder, create it via the filesystem:

```bash
VAULT_PATH="[vault path from Q2]"
mkdir -p "$VAULT_PATH/Archive"
```

### 4a. Seed Atlas files

Only create each file if it does not already exist. Check with:
```bash
obsidian read path="Atlas/Work.md" 2>&1 | head -1
```

If a file doesn't exist, create it with `obsidian create`. Use the content templates below.

**Atlas/Work.md**:
```bash
obsidian create path="Atlas/Work.md" content="Map of all work achievement notes. Primary source for performance review summaries.\n\n## $(date +%Y)\n\n### Q1 (Jan–Mar)\n\n### Q2 (Apr–Jun)\n\n### Q3 (Jul–Sep)\n\n### Q4 (Oct–Dec)\n\n---\n\n## Tags\nwork/shipped — work/unblocked — work/led — work/learned — work/improved"
```

**Atlas/Ideas.md**:
```bash
obsidian create path="Atlas/Ideas.md" content="Map of all idea notes. Reviewed weekly — stale unrefined ideas get a decision.\n\n## Unrefined\n\n## Active\n\n## Archived"
```

**Atlas/Tasks.md**:
```bash
obsidian create path="Atlas/Tasks.md" content="One-off tasks with deadlines. Reviewed daily — overdue items are flagged immediately.\n\n## Open\n\n## Done"
```

**Atlas/Knowledge.md**:
```bash
obsidian create path="Atlas/Knowledge.md" content="## Engineering\n\n## Process & Craft\n\n## Personal\n\n## Reference"
```

### 4c. Create the daily note template

```bash
obsidian create path="Daily Notes/Templates/Daily Note.md" content="---\ndate: {{date:YYYY-MM-DD}}\ntype: daily\n---\n\n# {{date:dddd, MMMM D, YYYY}}\n\n## Focus\n> What's the one thing that makes today a success?\n\n## Tasks\n- [ ]\n\n## Notes & Ideas\n> Anything worth capturing? Use /idea or /task if it needs tracking.\n\n## Work\n> Anything shipped or unblocked today? Use /log to record it.\n\n## End of Day\n- [ ] Anything worth logging with /log?\n- [ ] Any new ideas captured?\n- [ ] Ideas captured or refined?"
```

### 4d. Configure the daily note template setting

This can't be done via the CLI. Write directly to the vault's Obsidian config:

```bash
VAULT_PATH="[vault path from Q2]"
```

Read the current `daily-notes.json`:
```bash
cat "$VAULT_PATH/.obsidian/daily-notes.json"
```

Update it to include the template field. The file is JSON — merge in `"template": "Daily Notes/Templates/Daily Note"` while preserving existing fields (like `format`). Write the result back using the Write tool.

### 4e. Install Dataview plugin

```bash
obsidian plugin:install id=dataview enable
```

---

## Phase 5 — Set up cron jobs

Check if claudia cron entries already exist:
```bash
crontab -l 2>/dev/null | grep -c "claudia"
```

If any exist, show them and ask: "Existing claudia cron entries found. Replace them?"

Install or replace both cron jobs. If the weekly review falls on a weekday at the same time as the daily check-in, exclude that day from the daily check-in cron so only the weekly fires.

For example, if check-in is 5pm and weekly is Friday 5pm:
- Daily check-in: `0 17 * * 1-4` (Mon–Thu, excludes Friday)
- Weekly review: `0 17 * * 5` (Fri only)

If they don't overlap (different day or different time), run the daily check-in on all weekdays `1-5`.

```bash
(crontab -l 2>/dev/null | grep -v "claudia"; echo "[CHECKIN_MINUTE] [CHECKIN_HOUR] * * [CHECKIN_DAYS] [PROJECT_PATH]/scripts/checkin-reminder.sh # claudia checkin"; echo "[WEEKLY_MINUTE] [WEEKLY_HOUR] * * [WEEKLY_DAY] [PROJECT_PATH]/scripts/weekly-reminder.sh # claudia weekly") | crontab -
```

Use the check-in time from Q3 and the weekly review time from Q4.

Verify:
```bash
crontab -l | grep claudia
```

---

## Phase 6 — Summary

```
## Setup complete

**Name**: [name]
**Vault**: [vault path]
**Daily check-in**: weekdays at [time]
**Weekly reminder**: [day] at [time]

### Done automatically
- [x] CLAUDE.md configured
- [x] session-start.sh configured
- [x] Vault folders created (via Obsidian CLI)
- [x] Atlas and Template files seeded (via Obsidian CLI)
- [x] Daily note template configured
- [x] Dataview plugin installed and enabled
- [x] Daily check-in cron job installed
- [x] Weekly reminder cron job installed

### You're ready. Start with:
   cd [PROJECT_PATH] && claude
   /daily
```

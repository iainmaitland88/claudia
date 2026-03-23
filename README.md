# Claudia

<p align="center">
  <img src="claudia.png" alt="Claudia" />
</p>

A personal knowledge base (PKB) built on Claude Code and Obsidian. Not a productivity app — a growing, connected record of your work, ideas, knowledge, and goals that compounds in value over time.

## What it does

- **Logs work achievements** as individual notes, so when performance review season arrives your highlight reel is already written
- **Captures ideas** before they're forgotten, tracks them from unrefined to active project to shipped
- **Plans your day** each morning with a briefing that flags what's urgent, what's stale, and what needs your attention
- **Reviews your week** every Friday — surfaces forgotten tasks, stale ideas, and checks in on long-term goals
- **Tracks long-term goals** with structured data logging and trend analysis (weight loss, sleep, fitness, diet, anything with a measurable metric)

The system uses [Claude Code](https://claude.ai/code) custom skills as the interface and an [Obsidian](https://obsidian.md) vault as the storage layer. Claude reads and writes vault notes via the Obsidian CLI. Obsidian renders the graph, backlinks, and Dataview queries.

---

## Requirements

- [Claude Code](https://claude.ai/code) installed
- [Obsidian](https://obsidian.md) v1.12.4 or later (for the built-in CLI)

---

## Setup

### 1. Clone this repo

```bash
git clone https://github.com/iainmaitland88/claudia.git ~/Code/iainmaitland88/claudia
```

### 2. Install Obsidian and enable the CLI

Download and install [Obsidian](https://obsidian.md) (v1.12.4 or later), open a vault, then enable the CLI:

**Settings → General → Command line interface → Register CLI**

### 3. Run the setup skill

```bash
cd ~/Code/iainmaitland88/claudia && claude
/setup
```

This walks you through four questions (name, vault, weekly review schedule, role), then uses the Obsidian CLI to automatically:

- Update all config files with your paths
- Create the vault folder structure
- Seed all Atlas, Goal, and Template files
- Configure the daily note template
- Install and enable the Dataview plugin
- Install the weekly reminder cron job

### 4. First run

```bash
cd ~/Code/iainmaitland88/claudia && claude
/daily
```

---

## Skills

Skills are Claude Code slash commands. Run them from inside a `claude` session started from this directory.

> **Note:** All skills except `/setup` use the Obsidian CLI, which requires Obsidian to be open and running. The session-start hook uses direct file access and works regardless.

### `/setup` — First-time setup

Run this once after cloning. Walks you through a short questionnaire, then automatically configures paths, creates the vault folder structure, seeds all required files, and installs the weekly reminder cron job.

```
/setup
```

---

### `/daily` — Morning briefing

Reads your vault and produces a focused morning briefing:

- Overdue and upcoming tasks (from `Atlas/Tasks.md`)
- Stale unrefined ideas (>7 days without a decision)
- Yesterday's unchecked tasks
- Signals: last work note date, last weekly review date
- Suggested focus for the day

```
/daily
/daily focus on the auth migration today
```

---

### `/log` — Work achievement

Creates a linked note for a work achievement and appends it to `Atlas/Work.md`. This is your performance review source of truth — built one entry at a time throughout the year.

```
/log Shipped the auth refactor that unblocked the mobile team's deployment
/log Led the Q1 architecture review, got alignment on the new service boundary proposal
```

Each entry gets a `#work/` tag automatically:

| Tag | Meaning |
|-----|---------|
| `#work/shipped` | Completed and delivered something |
| `#work/unblocked` | Removed a blocker for others |
| `#work/led` | Led an initiative, decision, or review |
| `#work/learned` | Gained a significant technical insight |
| `#work/improved` | Improved a process, codebase, or team health |

---

### `/idea` — Idea capture

Creates a linked note for an idea and adds it to `Atlas/Ideas.md` under "Unrefined". Ideas are reviewed weekly — stale ones (>7 days) get a decision: refine and act, or archive.

```
/idea Shared codegen pipeline across front-end repos — write a Notion doc and get Dave's sign-off
/idea Use Jira ticket numbers as worktree branch names and auto-create per-ticket databases
```

---

### `/task` — Task capture

Adds a concrete task with an optional deadline to `Atlas/Tasks.md`. Overdue items appear in every morning briefing until ticked off.

```
/task Renew driving license before April 17th
/task Reply to Jake's email about the API review by end of week
```

For tasks that need context, links, or file attachments, mention them — Claude creates a full note instead of a line item:

```
/task Set up the new staging environment — needs the AWS credentials from 1Password and the runbook Jake sent
```

To expand a simple line item into a full note later: "expand the driving license task into a note."

---

### `/refine` — Idea to project

Refines an unrefined idea into an active project with a step-by-step checklist. Subsequent `/log` entries can be linked back to the project, building a thread of progress.

```
/refine type generation
```

Claude finds the idea note, shows it to you, asks for the steps, and converts it in place. The idea moves from "Unrefined" to "Active" in `Atlas/Ideas.md`.

**Full lifecycle example:**

```
/idea Shared codegen pipeline for front-end repos          ← captured
/refine shared codegen                                      ← becomes a project with steps
/log Drafted the Notion doc, shared with Dave for review    ← linked to the project
/log Dave signed off on the proposal                        ← linked to the project
/log Shipped v1 of the CLI tool, added to monolith          ← linked to the project
```

At performance review time: "Summarise my work on the codegen project." Claude reads the project note and all linked work entries and produces a narrative.

---

### `/weekly` — Weekly review

Meant for Friday afternoons. Reads your whole week and surfaces what needs attention:

- What got done (from work notes and daily notes)
- Overdue tasks
- Stale unrefined ideas that need a decision
- Goal check-in across all four personas

Claude walks you through triaging stale ideas one by one, then offers to save the review as a note.

```
/weekly
```

---

### `/review-goals` — Goal review

Reviews one or all goal personas with trend analysis, not just a status snapshot.

```
/review-goals
/review-goals health
```

For each goal it shows:
- Progress from start to current value
- Actual rate of change vs needed rate to hit the target
- Whether you're on pace
- Logging consistency
- An honest assessment
- A suggested adjustment — only if the data supports one (flat or worsening for 2+ weeks)

To log a data point mid-conversation: "log my weight as 84.2kg" — Claude appends it to the goal note's data log.

---

## Vault structure

```
Obsidian Vault/
├── Atlas/
│   ├── Work.md             ← Hub for all work achievement notes
│   ├── Ideas.md            ← Hub for all idea and project notes
│   ├── Tasks.md            ← Open tasks with deadlines
│   ├── Goals.md            ← Links to the four goal persona notes
│   └── Knowledge.md        ← Hub for learnings and reference material
├── Notes/                  ← All individual notes (flat, no subfolders)
│   ├── goal-health.md
│   ├── goal-sleep.md
│   ├── goal-fitness.md
│   ├── goal-diet.md
│   └── YYYY-MM-DD-slug.md  ← Ideas, work entries, tasks, projects, weekly reviews
├── Daily Notes/
│   ├── Templates/
│   │   └── Daily Note.md
│   └── 2026/MM/            ← Daily notes (existing Obsidian format preserved)
└── Archive/                ← Completed or inactive notes
```

### Why flat `Notes/`?

All notes live in one flat folder. Organisation comes from **tags** and **links**, not subfolders. This is intentional — it lets Obsidian's graph build naturally. A note about an auth refactor can link to a TypeScript learning note, which links to a related idea, which links back to a goal. Folders would silo them.

The `Atlas/` folder holds **Maps of Content (MOCs)** — index notes that link to related notes. They're navigational hubs, not containers. The Work atlas doesn't *contain* work notes; it *links* to them.

### Tagging taxonomy

```
#work/shipped       completed deliverable
#work/unblocked     removed a blocker
#work/led           led an initiative or decision
#work/learned       significant technical learning
#work/improved      process or quality improvement

#idea/work          work-related idea
#idea/personal      personal life idea
#idea/product       product/feature idea
#idea/process       process/tooling improvement

#goal/health
#goal/sleep
#goal/fitness
#goal/diet

#status/unrefined   raw idea — needs refining
#status/refined     idea refined into an active project
#status/active      being worked on (tasks)
#status/done        complete
#status/stale       needs review

#knowledge          reference material or learning worth keeping
```

---

## Daily workflow

| When | Command | Time |
|------|---------|------|
| Morning | `/daily` | ~2 min |
| Shipped something | `/log what you did and why it mattered` | 10 sec |
| Idea appears | `/idea the idea` | 5 sec |
| Task to remember | `/task what to do by when` | 5 sec |
| Idea becomes real | `/refine idea name` | 2 min |
| Friday afternoon | `/weekly` | ~10 min |
| Goal check-in | `/review-goals` | ~5 min |
| Perf review season | "Summarise my work in Q1" | 0 prep — already logged |

---

## How it grows

The system is designed to expand without friction.

**New skill:** create `.claude/skills/my-skill/SKILL.md` — it's immediately available as `/my-skill` the next time you start Claude from this directory.

**New note type:** decide on a `type:` frontmatter value and add relevant tags. No schema to register. Update the taxonomy section of `CLAUDE.md` when you want it to be a first-class concept.

**New Atlas hub:** create `Atlas/Reading.md`, add a line to `CLAUDE.md` under Key Paths. Done.

The vault compounds in value over time. After a year of logging, you can ask Claude "what work have I done related to TypeScript?" or "how have my sleep habits changed since March?" and it will traverse the links and give you a real answer.

---

## Project structure

```
claudia/
├── CLAUDE.md                          ← System context for Claude
├── .claude/
│   ├── settings.json                  ← Hook configuration
│   ├── hooks/
│   │   └── session-start.sh           ← Injects vault status at every session start
│   └── skills/
│       ├── setup/SKILL.md
│       ├── daily/SKILL.md
│       ├── weekly/SKILL.md
│       ├── log/SKILL.md
│       ├── idea/SKILL.md
│       ├── task/SKILL.md
│       ├── refine/SKILL.md
│       └── review-goals/SKILL.md
└── scripts/
    └── weekly-reminder.sh             ← macOS notification via cron
```

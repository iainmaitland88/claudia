# Second Brain — Personal Knowledge Base

This system is Iain's PKB: a growing, connected record of his work, ideas, and knowledge.
Run `claude` from this directory to access it.

## Vault
`/Users/iain.maitland/Documents/Obsidian Vault/`

## Who
Iain Maitland — software engineer. Disorganised but thoughtful.
Needs a system that captures fast and recalls richly.

## Obsidian CLI
All skills use the `obsidian` CLI (requires Obsidian to be running).
Enable once in Obsidian: Settings → General → Command line interface → Register CLI.

Key commands used in skills:
- `obsidian read file="Name"` — read a note by name
- `obsidian read path="Notes/2026-03-23-slug.md"` — read by exact path
- `obsidian create name="Title" path="Notes/" content="..."` — create a new note
- `obsidian append file="Name" content="text"` — append a line to a note
- `obsidian prepend file="Name" content="text"` — prepend a line to a note
- `obsidian daily:read` — read today's daily note
- `obsidian daily:append content="text"` — append to today's daily note
- `obsidian daily:path` — get today's daily note path
- `obsidian search query="tag:status/unrefined"` — search by tag
- `obsidian search query="tag:work/shipped after:2026-01-01"` — search with date filter
- `obsidian properties:set file="Name" key="last-reviewed" value="2026-03-23"` — update frontmatter
- `obsidian files path="Notes/"` — list files in a folder

Note: Skills fall back to direct Read/Edit file tools if the CLI returns an error (e.g., Obsidian not running).

## Key Paths
- Daily notes: `2026/MM/YYYY-MM-DD.md`
- All notes: `Notes/` (flat)
- MOC hubs: `Atlas/Work.md`, `Atlas/Ideas.md`, `Atlas/Knowledge.md`, `Atlas/Tasks.md`
- Weekly reviews saved as: `Notes/weekly-YYYY-WNN.md`

## Note Naming
New notes: `Notes/YYYY-MM-DD-short-slug.md`
MOC notes: `Atlas/[Name].md` (persistent, updated in place)

## Tagging
Work: work/shipped, work/unblocked, work/led, work/learned, work/improved
Ideas: idea/work, idea/personal, idea/product, idea/process
Knowledge: knowledge/engineering, knowledge/process, knowledge/personal, knowledge/reference
Status: status/unrefined, status/refined, status/active, status/done, status/stale

## Note Types
work, idea, project, decision, knowledge, daily, weekly-review, prep

## Urgency Thresholds
- Idea with status/unrefined older than 7 days → flag; older than 21 days → auto-archive
- Active project with no work entry in 14+ days → flag as stalling
- Work note not created in 3+ working days → flag
- No weekly review in 10+ days → flag
- Task overdue → flag immediately

## Tone
Direct. No fluff. No motivational filler. Flag what matters.

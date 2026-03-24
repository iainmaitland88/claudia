---
name: til
description: Capture a reusable piece of knowledge — populates the Knowledge atlas
argument-hint: <what you learned>
---

Capture a piece of knowledge. Today: !`date +%Y-%m-%d`.

Input: $ARGUMENTS

## Steps

1. If $ARGUMENTS is empty, ask: "What did you learn?"

2. Generate a short slug from the insight (lowercase, hyphens, 4-6 words max).

3. Pick the most fitting Knowledge section — don't ask, just pick:
   - **Engineering** — technical knowledge (languages, tools, APIs, debugging, architecture)
   - **Process & Craft** — how to work effectively (practices, patterns, collaboration)
   - **Personal** — self-knowledge, career, habits
   - **Reference** — facts, links, lookup tables

4. Create the note:
   ```bash
   obsidian create name="[date]-[slug]" path="Notes/" content="---
   date: [date]
   type: knowledge
   tags: [knowledge/SECTION]
   ---
   # [Insight title]

   [The knowledge as described — keep it concise and reusable]
   "
   ```

   Tags use the section name lowercase: `knowledge/engineering`, `knowledge/process`, `knowledge/personal`, `knowledge/reference`.

5. Insert into the correct section of Knowledge.md:
   - Read Knowledge.md: `obsidian read file="Atlas/Knowledge"`
   - Find the `## [Section]` heading
   - Insert `- [[date-slug]] | [date]` after any existing entries under that heading
   - Write the updated content back using the Edit tool on the vault file directly

6. Check if the knowledge relates to recent work:
   ```bash
   obsidian search query="tag:status/done" --output paths
   ```
   If a recent work note or project is clearly related, mention the link: "Related to [[note-name]]."

7. Confirm: "Saved as [[date-slug]]. Knowledge atlas now has [N] entries."

Do not over-elaborate. Just capture it.

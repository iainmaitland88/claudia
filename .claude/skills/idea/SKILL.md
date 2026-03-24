---
name: idea
description: Capture an idea as its own note before it's forgotten
argument-hint: <the idea>
---

Capture an idea. Today: !`date +%Y-%m-%d`.

Input: $ARGUMENTS

## Steps

1. If $ARGUMENTS is empty, ask: "What's the idea?"

2. Generate a short slug from the idea (lowercase, hyphens, 4-6 words max).

3. Pick the most fitting tag — don't ask, just pick:
   - `idea/work` — work-related, could benefit the team or product
   - `idea/personal` — personal life improvement
   - `idea/product` — product feature or user-facing improvement
   - `idea/process` — process, tooling, or workflow improvement

4. Create the note:
   ```bash
   obsidian create name="[date]-[slug]" path="Notes/" content="---
   date: [date]
   type: idea
   tags: [idea/TAG, status/unrefined]
   ---

   # [Idea title]

   [The idea as described — keep it as stated, don't over-elaborate]
   "
   ```

5. Append to the Ideas atlas under `## Unrefined`:
   ```bash
   obsidian append file="Atlas/Ideas" content="- [[date-slug]] | Added: [date]"
   ```

6. Confirm: "Captured as [[date-slug]]. You have [N] unrefined ideas."

Do not elaborate, categorise further, or suggest next steps unless asked. Just capture it fast.

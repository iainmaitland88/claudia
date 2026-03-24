---
name: log
description: Log a work achievement as a linked note in the vault — for performance reviews
argument-hint: <what you did and why it mattered>
---

Log a work achievement. Today: !`date +%Y-%m-%d`.

Input: $ARGUMENTS

## Steps

1. If $ARGUMENTS is empty, ask: "What did you accomplish? Include what you did and what changed because of it."

2. Parse the input:
   - **What**: what was done (1-2 sentences)
   - **Impact**: what changed / what was the outcome (infer if not stated, flag it)
   - **Tag**: pick the most fitting — don't ask, just pick:
     - `work/shipped` — completed and delivered something
     - `work/unblocked` — removed a blocker for others
     - `work/led` — led an initiative, decision, or review
     - `work/learned` — gained a significant technical or professional insight
     - `work/improved` — improved a process, codebase, or team health

3. Generate a short slug from the achievement title (lowercase, hyphens, 4-6 words max).

4. Create the note:
   ```bash
   obsidian create name="[date]-[slug]" path="Notes/" content="---
   date: [date]
   type: work
   tags: [work/TAG, status/done]
   ---
   # [Achievement title]

   **What**: [what was done]

   **Impact**: [outcome — what changed]

   **PRs**:
   - [PR link]
   "
   ```

   The **PRs** section is optional — only include it if the achievement references one or more pull requests. A single log entry can reference multiple PRs (even across different repos) when they represent a single logical piece of work.

5. Check for related active projects:
   ```bash
   obsidian search query="type:project tag:status/refined" --output paths
   ```
   If any project notes seem topically related to this achievement, ask:
   "Is this related to [[project-name]]?"
   If yes:
   - Append a back-reference:
     ```bash
     obsidian append file="[project-slug]" content="- [[date-slug]] | [date]"
     ```
   - Read the project note and check off any `## Steps` items that this achievement completes (change `- [ ]` to `- [x]`).

6. Append to the Work atlas:
   ```bash
   obsidian append file="Atlas/Work" content="- [[date-slug]] | [date] | work/TAG"
   ```

7. Confirm: "Logged as [[date-slug]]. Work atlas now has [N] entries."

If impact was inferred, note it: "(impact inferred — edit [[date-slug]] if wrong)".

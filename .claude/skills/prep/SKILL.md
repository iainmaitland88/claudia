---
name: prep
description: Generate a performance review narrative from logged work
argument-hint: [time range, e.g. "Q1 2026" or "last 3 months"]
---

Generate a performance review narrative. Today: !`date +%Y-%m-%d`.

Input: $ARGUMENTS

## Steps

1. **Determine the time range**:
   - If $ARGUMENTS specifies a quarter (e.g. "Q1 2026"), use that quarter's date range
   - If $ARGUMENTS specifies a range (e.g. "last 3 months", "Jan to Mar"), convert to dates
   - If $ARGUMENTS is empty, default to the current quarter

2. **Read the Work atlas**:
   ```bash
   obsidian read file="Atlas/Work"
   ```
   Collect all entries within the time range.

3. **Read each work and decision note** found in the range:
   ```bash
   obsidian read path="Notes/[note-name].md"
   ```
   Extract: what, impact, tag, PRs, related projects, ticket references.

4. **Read active and completed projects** that overlap the time range:
   ```bash
   obsidian search query="type:project" --output paths
   ```
   Read each and note progress (steps completed, work entries linked).

5. **Group achievements by tag**:
   - **Shipped** (`work/shipped`) — things delivered
   - **Unblocked** (`work/unblocked`) — blockers removed for others
   - **Led** (`work/led`) — decisions made, initiatives driven, reviews done
   - **Learned** (`work/learned`) — significant insights gained
   - **Improved** (`work/improved`) — process, codebase, or team improvements

6. **Generate the narrative**:

   ```
   ## Performance Summary — [time range]

   ### Highlights
   [3-5 most impactful achievements, each with specific evidence from the notes]

   ### Shipped
   [Bulleted list with what + impact for each]

   ### Led & Decided
   [Decisions made, initiatives driven — include rationale from decision notes]

   ### Unblocked
   [Blockers removed — who/what was unblocked]

   ### Improved
   [Process and codebase improvements]

   ### Learned
   [Key technical or professional insights]

   ### Projects
   [Status of each project active during this period — what was accomplished, what remains]

   ### By the Numbers
   - [N] work entries logged
   - [N] decisions documented
   - [N] projects advanced
   - [N] PRs shipped
   ```

7. Show the narrative and ask: "Want me to save this as a note, or adjust anything?"

   If saving:
   ```bash
   obsidian create name="prep-[range-slug]" path="Notes/" content="---
   date: [today]
   type: prep
   tags: [status/done]
   ---
   [narrative content]
   "
   ```

Use specific evidence from the notes — names, PR links, dates. No vague filler. This is the payoff of the entire system.

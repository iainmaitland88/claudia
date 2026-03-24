---
name: decide
description: Log a decision with rationale — high-value evidence for performance reviews
argument-hint: <what was decided and why>
---

Log a decision. Today: !`date +%Y-%m-%d`.

Input: $ARGUMENTS

## Steps

1. If $ARGUMENTS is empty, ask: "What was the decision? Include what you chose, what alternatives were considered, and why."

2. Parse the input:
   - **Decision**: what was decided (1 sentence)
   - **Alternatives**: what else was considered (infer if not stated)
   - **Rationale**: why this option was chosen
   - **Impact**: what this enables or prevents (infer if not stated, flag it)

3. Generate a short slug from the decision (lowercase, hyphens, 4-6 words max).

4. Create the note:
   ```bash
   obsidian create name="[date]-[slug]" path="Notes/" content="---
   date: [date]
   type: decision
   tags: [work/led, status/done]
   ---
   # [Decision title]

   **Decision**: [what was decided]

   **Alternatives considered**:
   - [option and why it was rejected]

   **Rationale**: [why this was the right call]

   **Impact**: [what this enables or prevents]
   "
   ```

5. Check for related active projects:
   ```bash
   obsidian search query="type:project tag:status/refined" --output paths
   ```
   If a project is clearly related, ask: "Is this related to [[project-name]]?"
   If yes, append a back-reference to the project note.

6. Insert into the correct quarter in the Work atlas (decisions are work):
   - Determine the quarter from the entry date: Jan-Mar → Q1, Apr-Jun → Q2, Jul-Sep → Q3, Oct-Dec → Q4.
   - Determine the year from the entry date.
   - Read Work.md: `obsidian read file="Atlas/Work"`
   - Find the `### QN (...)` heading under the correct year.
   - Insert `- [[date-slug]] | [date] | work/led` after existing entries under that quarter heading.
   - Write the updated content back using the Edit tool on the vault file directly.

7. Confirm: "Logged decision as [[date-slug]]."

If alternatives or impact were inferred, note it: "(inferred — edit [[date-slug]] if wrong)".

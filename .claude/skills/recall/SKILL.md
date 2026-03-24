---
name: recall
description: Search and retrieve past notes — answer questions from the vault
argument-hint: <what you want to find or know>
---

Search the vault and answer a question. Today: !`date +%Y-%m-%d`.

Input: $ARGUMENTS

## Steps

1. If $ARGUMENTS is empty, ask: "What do you want to find?"

2. Analyse the query and determine the search strategy:
   - **By topic**: extract key terms, search note content
   - **By date range**: convert to `after:` / `before:` filters (e.g. "last week" → `after:YYYY-MM-DD`)
   - **By tag**: map to known tags (e.g. "what I shipped" → `tag:work/shipped`, "decisions" → `type:decision`)
   - **By project**: search for the project note name
   - **By ticket**: search for the Jira ticket ID in content or frontmatter

3. Run one or more searches:
   ```bash
   obsidian search query="[terms and filters]"
   ```
   Also check Atlas files (Work.md, Ideas.md, Tasks.md, Knowledge.md) if the query is broad (e.g. "what did I do this week").

4. Read the top matching notes (up to 10). For each, read the full note content.

5. Synthesise an answer:
   - Lead with the direct answer to the question
   - Reference source notes with `[[note-name]]` links
   - Include dates and tags for context
   - If the query spans a time range, organise chronologically
   - If nothing matches, say so clearly — don't fabricate

6. If the results are extensive, offer: "Want me to narrow this down or go deeper on any of these?"

Keep the answer concise. The user wants information, not a lecture.

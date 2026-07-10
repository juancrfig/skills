---
name: process
description: Source of truth for Juanes' book-note template semantics (vault Templates/book.md) and the harvest protocol run after study sessions. Use whenever working with a book note in "2 - Input/" — creating/updating a skill from one, closing questions, or when Juanes invokes /process pointing at a book note. Also invoked by /teach at session close.
---

# /process — book-note semantics & harvest

Version 1 — built 2026-07-10, ratified in the template-grilling session. The template file (`vault/Templates/book.md`) holds only the structure; **this file is the single source of truth for what each section means and how to treat it.** If they ever disagree, this file wins and the template gets fixed.

## The model: a 2×2, not a pipeline

Sections are inventory bins in a 2×2 — **author's vs. Juanes'** × **claim vs. rule**:

| | Claim (descriptive) | Rule (actionable) |
|---|---|---|
| **Author's, on trust** | Statements | Reminders |
| **Juanes', verified** | Insights | Protocols |

**Juanes is the processor; gated study sessions are the processing step.** Value flows from the trust column to the verified column through sessions — the note itself doesn't "process" anything. Insights/Protocols usually can't be traced to one specific Statement; don't add provenance ceremony.

## Section semantics

- **Statements** — the author's claims, in the author's words, selected by Juanes. The selection is the signal (a map of his attention on the book), not the content — the AI already knows the book. On trust until tested.
- **Reminders** — the author's actionable rules, pre-compressed 80/20. On trust. Provisional skill material until tested; **a Reminder that conflicts with a Protocol loses.**
- **Questions** — the pending-verification log; the engine that moves items from trust to verified. Lifecycle: conceptual questions close only through a comprehension gate; short factual ones may close inline with a source or example. The answer lands where it belongs (Statement, Dictionary note, Zettel); the question is struck through with a link: `~~question~~ → [[answer-note]]`. The section stays a scannable list.
- **Insights** — claims Juanes produced, verified by Claude on sight (per /teach). Verified knowledge; Zettel candidates.
- **Protocols** — actionable rules Juanes produced, verified against real code/systems in a gated session.
- **Counterarguments** — semantics deliberately open until first real use. Do not plan or define it.
- Anything else is freeform, per book, with no standard meaning.

## Skill creation/updating from a book note

Manual only: Juanes points at a book note and asks for the skill. Priority order for distilling skill behavior:

1. **Protocols** (highest — verified rules; a skill's behavior comes from here first)
2. **Insights** (verified claims)
3. **Reminders** (provisional; include only where no Protocol/Insight covers the ground, and mark nothing as settled that only a Reminder supports)

Statements are not skill material.

## Harvest protocol (post-session cleanup)

Run after any study session that touched a book note — invoked automatically by /teach at session close, or manually via /process. **Claude always does the striking; Juanes never has to ask.**

1. **Strike closed questions.** Cross-reference the session's gated tickets against the note's Questions section. For each question whose answer was gated and landed somewhere (new/updated Dictionary entry, Zettel, Statement), strike it through with the link: `~~question~~ → [[answer-note]]`. If the answer was gated but its landing note doesn't exist yet (Juanes still has to write it), leave the question unstruck and tell him it's blocked on that note.
2. **Verify new Insights/Protocols landed.** Any `# Insights` / `# Protocol` marked during the session must appear in the book note's matching section (already verified-on-sight per /teach). If missing, add them.
3. **Flag Counterarguments candidates** encountered during the session — surface them to Juanes; never file them silently (section semantics are still open).
4. **Report** what was struck, what's blocked on notes he owes, and any queue items (deferred questions, tool skills) recorded in the session's ticket queue.

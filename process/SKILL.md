---
name: process
description: Source of truth for Juanes' input-note template semantics (vault Templates/input.md — books, lectures, videos, papers, courses) and the harvest protocol run after study sessions. Use whenever working with an input note in "2 - Input/" — creating/updating a skill from one, closing questions, or when Juanes invokes /process pointing at an input note. Also invoked by /teach at session close.
---

# /process — input-note semantics & harvest

Version 2 — built 2026-07-10 as the book-note template (Version 1), generalized to all input media 2026-07-11 in the absorb/process grilling session. The template file (`vault/Templates/input.md`) holds only the structure; **this file is the single source of truth for what each section means and how to treat it.** If they ever disagree, this file wins and the template gets fixed.

## Scope: one note per input resource

An input note covers any consumed resource — the medium tag on line 1 comes from a **closed set**: `#book`, `#lecture`, `#video`, `#paper`, `#course`, `#session`. The metadata line must carry a **resolvable source pointer (URL)** — mandatory for every note, because for sources the AI can't be assumed to know (talks, niche videos, internal lectures) the note is the only record. For such sources, Statements must be written to stand alone, not as memory-joggers; for well-known books, compressed selections are fine because the content is recoverable.

**A `/teach` session note (`2 - Input/Sessions/`, `#session`) is an input note like any other** — same six sections, same semantics, same lifecycle. Its only distinguishing trait: the "author" on trust is Claude (the one teaching), not a book's author. So in a session note, Statements/Heuristics are Claude's claims/rules on trust, while Insights/Protocols are still Juanes' verified output — the 2×2 still applies, just with Claude in the author slot instead of, say, Ousterhout.

The note is a **lifecycle ledger, not an absorption artifact**: it spans both stages of learning (absorb, then process — per Rabbi Simon Jacobson's distinction). Absorption fills the trust row; gated sessions fill the verified row. "Don't rush processing" is a rule about which sections Juanes touches during consumption, not a separate template.

## The model: a 2×2, not a pipeline

Sections are inventory bins in a 2×2 — **author's vs. Juanes'** × **claim vs. rule**:

| | Claim (descriptive) | Rule (actionable) |
|---|---|---|
| **Author's, on trust** | Statements | Heuristics |
| **Juanes', verified** | Insights | Protocols |

**Juanes is the processor; gated study sessions are the processing step.** Value flows from the trust column to the verified column through sessions — the note itself doesn't "process" anything. Insights/Protocols usually can't be traced to one specific Statement; don't add provenance ceremony.

Section names are **canonical and frozen** — exactly these six, identical in every input note. (One grandfathered exception: the "Statements and Interpretations" header in the Rabbi Jacobson lecture note stays as-is.)

## Section semantics

- **Statements** — the author's claims, in the author's words, selected by Juanes. For sources the AI knows, the selection is the signal (a map of his attention), not the content. For obscure sources, the content is also the signal — write to stand alone. On trust until tested.
- **Heuristics** — the author's actionable rules, pre-compressed 80/20. On trust. Provisional skill material until tested; **a Heuristic that conflicts with a Protocol loses.**
- **Questions** — the pending-verification log; the engine that moves items from trust to verified. Lifecycle: conceptual questions close only through a comprehension gate; short factual ones may close inline with a source or example. The answer lands where it belongs (Statement, Dictionary note, Zettel); the question is struck through with a link: `~~question~~ → [[answer-note]]`. The section stays a scannable list.
- **Insights** — claims Juanes produced, verified by Claude on sight (per /teach). Verified knowledge; Zettel candidates. **No candidates**: unverified items never sit here marked "pending."
- **Protocols** — actionable rules Juanes produced, verified against real code/systems in a gated session.
- **Counterarguments** — semantics deliberately open until first real use. Do not plan or define it.
- Anything else is freeform, per note, with no standard meaning.

## Parentheses: untracked marginalia

Parenthetical text inside the author's row (Statements, Heuristics) is Juanes' marginalia — reactions, extra context for himself or the AI (e.g., "(this connects with Zettel X)"). Rules:

- **The harvest ignores parentheticals entirely.** They have no lifecycle and are never parsed, promoted, or tracked.
- Anything that *does* have a lifecycle — a question needing an answer, an insight candidate, a rule worth adopting — must be promoted by Juanes into its proper section; parens are not a shadow inventory.
- Parens are only meaningful in the author's row; in Insights/Protocols everything is already Juanes' voice.

## Mid-absorption ideas

When an idea of Juanes' own arrives while consuming (too substantial for a paren, not yet gated for Insights): capture it as a fleeting note in `0 - Inbox/workspace/` tagged `#active`, optionally leaving a one-line paren pointer in the input note, then return to absorbing. This satisfies both "write ideas down immediately" and "don't rush processing" — the verified row stays untouched until a gate.

## Skill creation/updating from an input note

Manual only: Juanes points at an input note and asks for the skill. Priority order for distilling skill behavior:

1. **Protocols** (highest — verified rules; a skill's behavior comes from here first)
2. **Insights** (verified claims)
3. **Heuristics** (provisional; include only where no Protocol/Insight covers the ground, and mark nothing as settled that only a Heuristic supports)

Statements are not skill material.

## Harvest protocol (post-session cleanup)

Run after any study session that touched an input note — invoked automatically by /teach at session close, or manually via /process. **Claude always does the striking; Juanes never has to ask.**

A `/teach` session typically touches two input notes at once: the **source note** (the book/lecture/etc. being studied, if any) and the **session note** (the `#session` note this teach run produces or continues). Harvest treats each by its role, not as different kinds of thing.

**Landing notes are written live, by Juanes, during the session.** Dictionary entries and zettels get created or filled mid-session — by Juanes directly, or by Claude when he asks in the moment. Harvest does not write landing-note content after the fact; it cleans up and closes the loop around what already landed.

**Do not touch Juanes' own words.** In every note, Juanes' own sections/prose are his — harvest never rephrases, restructures, or "cleans up" anything he wrote, in any note. Harvest only fills sections that start the session empty and belong to the note's non-Juanes author: the source note's Questions get struck (not rewritten), and the session note's Statements + Notes/Created/Updated get filled (Claude is that note's author). If a harvest step would edit Juanes' prose, that's a sign the step is wrong — stop and ask instead.

1. **Strike closed questions** in the source note's Questions section. Cross-reference the session's gated tickets. For each question whose answer was gated and landed somewhere (new/updated Dictionary entry, Zettel, Statement), strike it through with the link: `~~question~~ → [[answer-note]]`. If the answer was gated but its landing note doesn't exist yet (Juanes still has to write it), leave the question unstruck and tell him it's blocked on that note.
2. **Fill the session note's Statements.** Claude is that note's author (per the 2×2, Statements = author's claims, on trust). Write the 80/20 of what Claude asserted/taught during the session, in Claude's own words.
3. **Verify new Insights/Protocols landed.** Any `# Insights` / `# Protocol` marked during the session must appear in the matching note's matching section (already verified-on-sight per /teach) — the source note if it's about the source material, the session note if it's about the session's own claims. If missing, add them as new bullets, never by editing existing ones.
4. **Fill the session note's Notes → Created/Updated ledger.** List every note (Dictionary, Zettel, session note itself, diagram) created or updated during the session, as plain `[[links]]` with no parenthetical commentary.
5. **Flip the session note's tag from `#active` to `#done`** (or `#doneN` if it's a repeat pass — see the vault's tag convention in `2 - Input/`).
6. **Flag Counterarguments candidates** encountered during the session — surface them to Juanes; never file them silently (section semantics are still open).
7. **Report** what was struck, what's blocked on notes he owes, and any queue items (deferred questions, tool skills) recorded in the session's ticket queue.

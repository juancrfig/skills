---
name: teach
description: Teaching protocol for Juanes — use whenever he asks to learn, understand, or have something explained (a concept, a codebase, a technology), in any repo. Treats the subject as a system of components (words) and relationships, taught as dependency-ordered tickets with hard comprehension gates. Session files live in ~/Workspace/vault/.
---

# /teach — how Juanes learns

Version 1 — built 2026-07-08 after a failed git-internals session. This skill is expected to evolve; every session should end by asking what to adjust.

## The model

**Everything is a system. A system = components (words) + relationships.**
Learning happens in exactly two kinds of units, and every explanation must be one of them:

- **Word ticket** — what a single term means.
- **Relationship ticket** — how one already-owned thing relates to another.

## Session flow

1. **Overview** — one succinct, jargon-free, layman statement of what the system does and/or what problem it solves. Nothing else.
2. **Ticket board** — the 80/20 list of word tickets and relationship tickets needed to close the original question, shown with their dependencies (which tickets block which). The original question is the final ticket. Keep the board visible and updated as tickets close.
3. **Teach loop** — always take the simplest **unblocked** ticket:
   - Explain it. A word gets a definition grounded in one real example. A relationship gets how the two parts interact.
   - **Gate**: Juanes re-explains in his own words. The ticket closes only when Claude confirms the restatement is accurate. Until he restates and it checks out, assume he does NOT understand — never build on an ungated ticket.
   - Closing a ticket may unblock relationship tickets. Explain a relationship **as soon as it unblocks** — the system is assembled incrementally, alongside the words, never after all of them.
4. **End** — the session is done when the final ticket (the original question) is unblocked, explained, and gated like any other ticket.

## Hard rules

- **No implicit "got it."** Silence, "ok", or a plausible-sounding sentence is not a pass. Only a gated restatement closes a ticket.
- **One ticket at a time.** A correction must never smuggle in new concepts, new metaphors, or a new check question on top of the fix. Fix the one thing, re-gate, move on.
- **Vocabulary law.** A potentially-new word is either its own ticket or gets an immediate one-phrase gloss. Acronyms are always expanded on first use.
- **Draw graph-shaped things — only when asked.** If the subject is structural — a tree, a graph, a flow, an architecture, pointers — prose is forbidden as the primary medium. But do NOT auto-generate an Excalidraw diagram; at most offer to generate one ("Want me to draw this as an Excalidraw diagram?") and only proceed if he says yes. When generated: one stable spatial model per session, pick one visual metaphor and never churn it.
- **Calibrate before teaching.** Check `vault/` for prior session records on the topic before assuming what he knows.

## Failure modes this skill exists to prevent (observed 2026-07-08)

1. Explaining how the whole system works before the atomic words are gated.
2. Explaining all the words first and assembling the system only at the end.
3. Graph-shaped content delivered as prose walls with churning metaphors.
4. Check questions bundled with new material, so answering never confirms anything.
5. Explaining a word that already has a `4 - Dictionary/` entry in his vault as if it were new (ratified 2026-07-10). Inline-glossing genuinely new tool vocabulary mid-ticket is fine and normal — the failure is only re-teaching what he already owns. Check the Dictionary (filter by topic tag) before glossing.

## Insights & Protocols (added 2026-07-10, MTBT session 1)

During sessions Juanes may mark a message `# Insights` (a statement in his own words — the most valuable output type) or `# Protocol` (a procedure for accomplishing something, e.g. "trace an abstraction via who-imports-this, one hop at a time").

- **Verify on sight.** When either marker appears, immediately check it for accuracy and say so explicitly — confirm it, or correct it before it lands in the vault. A stored-but-wrong Insight is worse than none.
- **Protocols may imply tool skills** (grep, find, vim navigation). Name the implied tool skill explicitly and queue it — per his fundamentals-first vision (portable tools over IDE dependence), practicing the tool is part of the learning, not a distraction. Where possible, have him run the command instead of running it for him.
- At retro, Protocols produced during the session are candidates for skill rules.

## Home

`vault/` is the single home for session output and stateful learning docs. Check its `AGENTS.md` for further context

## Session close (added 2026-07-10)

If the session touched a book note (`vault/2 - Input/`), run the **harvest protocol** from the `/process` skill at session close — strike closed questions, verify Insights/Protocols landed, report what's blocked.

## Feedback

End every session by asking what worked and what didn't; fold confirmed adjustments into this file.

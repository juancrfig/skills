---
name: software-architecture
description: Lens protocol for analyzing a real codebase with Juanes through the software-design concepts he has mastered so far. Use when he asks to analyze, understand, or study the architecture/design of any codebase under ~/Workspace/Projects/ (work repos like MTBT, or open-source forks), or invokes /software-architecture. Reads his current concept state live from the vault; teaches via /teach-style gated tickets.
---

# /software-architecture — codebase analysis as a learning lens

Version 0.1 — recreated 2026-07-09 following the book-template protocol (`~/Workspace/vault/Templates/book.md`). Built from Juanes' notes on *A Philosophy of Software Design* (Ousterhout, ch. 1–6).

**Purpose:** deepening Juanes' understanding is the goal; this skill is a consequence of that activity, not the product. It is a **lens protocol, not a knowledge base** — it stores no book content and no concept definitions. The vault is the single source of truth for what he knows; this file only encodes how to use that state against real code.

**Provenance:** every rule below is tagged with its source, so Juanes can audit why it exists:
- `[R]` — derived from a Reminder in his book note (quoted or paraphrased).
- `[G]` — decision from the grilling sessions of 2026-07-09.
- `[P]` — provisional: Claude's judgment, kept because it fits the system, not yet explicitly ratified. Ratify or delete at any retro.

## Founding premise `[R]`

*"The best way to learn about design is with code reviews. Specifically, reading other people's code."* — his own note. Hence: concepts are never taught in the abstract; every session is anchored to real code.

## The corpus — `~/Workspace/Projects/` `[G]`

Any real codebase under `~/Workspace/Projects/` is valid session material: work repos (e.g. `MTBT/`) and forks of open-source projects alike. Learning must never depend on company property. When hunting for a concept, prefer whichever repo exhibits it most clearly; open-source forks have the advantage that findings and docs can be shared or committed freely.

## Step 0 — Load Juanes' concept state (always, before touching the code) `[G]`

Read, in this order:

1. His `#active` book note(s) in `~/Workspace/vault/2 - Input/`, interpreted **per `Templates/book.md`** — the template defines each section's consumer. Consequences for this skill:
   - **Reminders** → the working checklist for code scanning. His captured red flags and 80/20 rules are the lenses to scan with. Read them fresh each session; never copy them into this file (they grow as he reads).
   - **Questions** → the hunt-list. Answering an open question with real code is the highest-value move a session can make. Closing follows the template's lifecycle: conceptual questions need a gate; short/factual ones close inline; answers land as Statements/Dictionary/Zettels written by Juanes, question struck through with a link.
   - **Statements** → calibration only (what he has encountered). Not skill material; never lecture him on his own Statements.
   - **Counterarguments** → once it has content, its entries are limits on the lenses: where he has seen a book principle fail, do not enforce it dogmatically.
2. `~/Workspace/vault/4 - Dictionary/` — concepts he has processed into his own definitions.
3. Prior session records for the target codebase: `<repo>/docs/` in the repo itself, plus the matching vault folder for work projects (e.g. `1 - Projects/Applus/MTBT/`).

From these, build two working lists: **mastered concepts** (gated in a prior session or Dictionary-defined — usable as lenses, in his vocabulary) and **open questions**.

**Mastered vs. encountered `[P]`:** a concept that appears in the book note but was never gated or Dictionary-defined counts as *encountered, not mastered* — it may be used only as its own word ticket, never assumed as shared vocabulary.

## Default mode — codebase-driven walk `[G]`

The codebase sets the agenda; concepts land where the code exhibits them. Walk order across sessions:

1. **Entry points** — where execution starts.
2. **Module inventory** — the major units with an interface and an implementation.
3. **Interface vs. implementation** — what each module that matters promises vs. hides.
4. **Dependencies and data flow** — which modules cannot be understood in isolation, and why.
5. **Boundary contracts** — how separate systems/services talk; what each side must know about the other.

Rules during the walk:

- Tag findings only with **mastered** concepts; code exhibiting an unmastered concept goes to the ticket queue instead of being taught in passing. `[G]`
- *"Use moderation and discretion. Every rule has its exceptions, and every principle has its limits."* `[R]` — never present a book principle as absolute. When real code violates a principle *and works*, flag it as a **Counterarguments candidate** for his book note rather than as a defect.
- *"Always be on the lookout for opportunities to improve the design of the system you are working on."* `[R]` — each session ends by naming one concrete, low-blast-radius improvement opportunity spotted in the code walked (named, not executed; acting on it is Juanes' call, especially in company repos).

## Alternate mode — dedicated Q&A session (on demand only) `[G]`

When Juanes explicitly points at his open questions and asks to burn them down (never the default rhythm), run a session whose agenda is the questions themselves. Same rules: prefer answering with a real code snippet from a corpus repo (theory-only is acceptable when no repo exhibits the situation), gate the conceptual questions, close the factual ones inline, and he writes the resulting notes.

## Teaching mode — guided discovery, gated `[G]`

Follow the `/teach` skill's protocol (ticket board, one ticket at a time, hard gates, vocabulary law, Excalidraw-first for graph-shaped structure). Additions specific to codebase sessions:

- **Juanes navigates; Claude directs.** Tickets name a file/function and a question ("open X — what knowledge does this module hide? what breaks if Y changes?"). Claude scouts ahead to design good tickets but does not read the answer aloud.
- **Presentation is allowed only for raw inventory** — enumerating repos, languages, entry points, top-level structure (session zero). All *interpretation* must come from Juanes and pass a gate.
- **Verdicts need evidence `[P]`.** A gate on a judgment ("this module is shallow") passes only if he cites the code that supports it.

## Outputs `[G]`

- **Session artifacts** (architecture maps, Excalidraw diagrams, session notes, ticket queue) → `<repo>/docs/`. **Company repos:** keep untracked — add to `.git/info/exclude` at first write; never commit unless Juanes explicitly decides to. **Open-source forks:** committing docs to his fork is fine (never to an upstream PR).
- **Ticket queue** — `docs/ticket-queue.md`: unmastered concepts encountered, each with the file/line exhibiting it, so a future session teaches the concept against that exact example.
- **Gated concepts** → Juanes writes the `4 - Dictionary/` entry himself. Note bodies are his; Claude may suggest what to capture, never write it for him. `[G]`
- **Project-level insights** → he writes them under the matching `1 - Projects/` folder (e.g. `Applus/MTBT/` for job work).

## Retro & growth `[G]`

End every session by asking:

1. **"What should this lens have done better?"** — apply 1–2 concrete, approved edits to this file.
2. **"Did today's code contradict anything the book claims?"** — candidates for his Counterarguments section.
3. New Reminders he has written since last session are candidate rules — propose, he ratifies.

Every rule added must carry a provenance tag. If a session produces zero edits twice in a row, ask whether the skill has stabilized or the retro has gone soft. When a new book on this topic becomes `#active`, its note (same template) plugs into Step 0 unchanged — this skill improves across resources, one skill per topic, never per book.

## Failure modes this skill exists to prevent

1. Lecturing about design concepts in the abstract instead of anchoring them to a file Juanes has open.
2. Using a concept as a lens that he has only read about, not gated — the analysis sounds smart and teaches nothing.
3. Duplicating book/vault content into this file, creating a second drifting source of truth.
4. Claude doing the interpretation and Juanes nodding along (the "presentation trap").
5. Rules appearing in this file that Juanes cannot trace to a source he understands (untagged provenance).

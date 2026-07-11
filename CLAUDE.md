# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

# This repository: `skills`

A collection of Claude Code skills (slash commands) used across all of Juanes' projects, plus the tooling to install them.

## What a skill is

Each subdirectory with a `SKILL.md` is a skill. The frontmatter (`name`, `description`) tells Claude Code how to register and invoke it. The body of `SKILL.md` is the instruction set executed when the skill runs.

Skills are registered globally by symlinking each skill directory into `~/.claude/skills/<name>`. They are then available as `/name` in any Claude Code session.

## Installation

```bash
./init.sh
# or, to also link vault project memory:
./init.sh --vault-path /path/to/vault
```

`init.sh` symlinks:
- `soul/CLAUDE.md` → `~/.claude/CLAUDE.md` (Juanes' personal profile, injected into every session globally)
- `memory/` → `~/.claude/projects/<vault-slug>/memory/` (persistent memory for vault sessions)
- Each `<skill>/` with a `SKILL.md` → `~/.claude/skills/<skill>/`

## Skills in this repo

| Skill | Purpose |
|---|---|
| `caveman` | Ultra-compressed response mode (~75% fewer tokens). Trigger: "caveman mode" or `/caveman`. Off: "stop caveman". |
| `grilling` | Relentless one-question-at-a-time design interview to stress-test a plan. |
| `grill-me` | Alias that invokes `/grilling`. |
| `grill-with-docs` | Grilling session that also writes ADRs and a glossary via `/domain-modeling`. |
| `handoff` | Compacts the current conversation into a handoff doc for a fresh agent. |
| `process` | Book-note harvest protocol — runs after study sessions to strike closed questions, verify Insights/Protocols landed. Also invoked by `/teach` at session close. |
| `teach` | Structured learning protocol (word tickets + relationship tickets, hard comprehension gates). Used when Juanes asks to learn something. |
| `software-architecture` | Codebase analysis through software-design concepts Juanes has mastered; anchored to real code, never abstract. |
| `excalidraw-diagram-generator` | Generates Excalidraw diagrams from templates and scripts. |

## `skills-lock.json`

Tracks externally sourced skills (from GitHub repos like `mattpocock/skills`, `github/awesome-copilot`) with their source path and content hash. Update this file when pulling in or pinning a new external skill.

## Key relationships between skills

- `/teach` → calls `/process` at session close when a book note was touched.
- `/process` → the harvest step; `process/SKILL.md` is the single source of truth for book-note section semantics (not `vault/Templates/book.md`).
- `/software-architecture` → follows `/teach`'s gating protocol; reads Juanes' mastered concepts live from `vault/` before each session.
- `/grill-me` and `/grill-with-docs` → thin wrappers over `/grilling`.

## `memory/`

Persistent project-scoped memories for vault sessions. Linked into Claude Code's project memory path for the vault checkout. Currently empty; grows as sessions produce memorable facts.

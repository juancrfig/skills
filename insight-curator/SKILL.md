---
name: insight-curator
description: >
  Run when an error report reaches CLOSED status and before discarding it.
  Reads the full report, extracts generalizable insights, and updates the
  skill library: either a principle in the relevant core SKILL.md or a
  procedure in a references/ file. Prevents knowledge loss from one-off fixes.
---

# Insight Curator

After an error report closes, extract durable lessons and feed them back into
skills before the report is forgotten.

## Trigger

- Error report status = **CLOSED**
- Must run **before** discarding or archiving the report

## Workflow

| Step | Action | Output |
|------|--------|--------|
| 1 | Read report fully, focusing on what misled, gaps in hypotheses, and why the fix wasn't anticipated | Mental summary |
| 2 | Abstraction test: would this help on a similar-but-different problem? | Decision: core / reference / discard |
| 3 | If core-worthy: check existing core, resolve conflicts, add as principle | Updated SKILL.md |
| 4 | If reference-worthy: create or update a file in `references/` | New or updated `.md` file |
| 5 | Before creating a reference file, scan existing ones for relevance | Avoid duplicates |
| 6 | Update `Last referenced:` on every file touched | Fresh date stamp |

See assets for detailed checklists and templates for each step.

## Rules

- **Never append specifics to core.** Core gets principles; specifics go to references.
- **One insight per core update.** Batch tempting — resist.
- **Thin lessons? Go back.** If the report's Lessons section is empty or vague, fill it before curating.
- **Stale references get flagged.** Any reference file not touched in 6+ months should be flagged for deletion review.
- **Unsure? Lean reference.** Never force an abstraction that isn't genuinely there.
- **Already covered? Skip or merge.** Don't append redundant principles.
- **Contradicts existing? Resolve.** Don't stack conflicting principles.

## Resources

- `assets/abstraction-checklist.md` — Decision framework for Step 2
- `assets/core-update-guide.md` — How to write principles vs patches (Step 3)
- `assets/reference-template.md` — Template for new reference files (Step 4)
- `references/example-curation.md` — Worked example of a full curation session

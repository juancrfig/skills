# Abstraction Checklist

> Step 2 of the curation workflow. Run this after reading a closed error report.

## The Test

Ask:

> "Would this insight help an agent facing a similar but not identical problem?"

## Decision Branches

### Yes — Core update candidate
- The lesson reveals a hidden assumption or missing mental model
- It generalizes to a whole class of problems, not this specific incident
- It changes how an agent should approach a broad category of work

**Next:** Proceed to Step 3 (Core Update). Use `assets/core-update-guide.md`.

### No — Reference file candidate
- The process is specific, multi-step, and likely to recur in nearly identical form
- The context is narrow (one tool, one framework, one environment)
- It is useful as a lookup, not as a guiding principle

**Next:** Proceed to Step 4 (Reference File). Use `assets/reference-template.md`.

### Neither — Discard
- The fix was a one-off typo or transient environmental issue
- The lesson is already well-covered by existing skills
- Nothing in the report would change future behavior

**Next:** Close the report. Nothing to curate.

## Tie-Breaker

If unsure, **lean reference file**. Never force an abstraction that isn't genuinely there.

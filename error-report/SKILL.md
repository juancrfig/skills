---
name: error-report
description: Create structured error reports documenting bug lifecycle from discovery through resolution. Use when (1) a user reports something broken, unexpected behavior, or an error, (2) starting investigation of a bug before making changes, (3) logging findings during troubleshooting, or (4) closing a resolved issue with root cause and lessons learned.
---

# Error Report

Document bug lifecycle from discovery to resolution in a structured report. Create the report immediately when a bug is signaled — before investigation starts.

## Workflow

1. **Open**: Create report using the template in `assets/error-report-template.md` as soon as a bug is reported.
2. **Investigate**: Fill the Investigation Log live as work progresses. Do not wait until the end.
3. **Close**: Complete Root Cause, Solution, and Lessons only after the fix is confirmed.

## Report Sections

| Section | When to Fill | Guidance |
|---------|-------------|----------|
| Bug Description | At open | Quote exact errors. Contrast observed vs expected behavior. |
| Initial Hypotheses | At open | List all suspected causes without filtering. Wrong guesses are valuable. |
| Investigation Log | During work | One entry per branch: hypothesis -> what was tried -> result -> keep or abandon. |
| Root Cause | At close | Actual cause. Note if it differed from initial hypotheses. |
| Solution | At close | Exact steps taken. Include non-obvious details. |
| Lessons | At close | One paragraph. Write for someone who was not present. |

## Rules

- Open the report before touching code or config.
- Fill the Investigation Log live, not from memory afterward.
- Close the report only when the bug is confirmed fixed.

## Template

Use `assets/error-report-template.md` as the starting point for every new report.

## Example

See `references/example-report.md` for a completed report demonstrating tone and depth.

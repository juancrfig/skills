---
name: settle
description: Quickly stress-test a raw idea and produce a settled card filed into _Ideas.md. Use when Juanes wants to move an idea from Incomplete to Settled, or types /settle.
---

# /settle — Idea Settlement Protocol

Juanes has a raw idea he wants to stress-test quickly (10 minutes max). Your job is to run three sharp questions, then write a settled card directly into `_Ideas.md` without asking for review.

## The vault

The vault is Juanes' second brain repo. Check `AGENTS.md` at the vault root for the folder structure. Ideas live at `0 - Inbox/_Ideas.md`, which has two sections: `## Incomplete` and `## Settled`.

## The three questions

Ask them one at a time. Wait for his answer before continuing.

1. **What problem does this solve?** Push him to describe the pain, not the feature. If he describes a solution, redirect: "Yes, but what breaks or hurts today without this?"

2. **What's your proposed approach in one paragraph?** No implementation details. Just the shape of the solution — who uses it, what it does, what makes it different from what already exists.

3. **What's blocking this from being a project right now?** If the answer is "nothing", flag that the idea is ready to graduate to `1 - Projects/` instead of being settled here.

## After the three questions

Before writing the settled card, navigate Juanes' current goals to propose an accurate blocker:

1. Read today's daily note from `7 - Journal/Days/`
2. Read the current weekly note from `7 - Journal/Weeks/`
3. Read the current monthly note from `7 - Journal/Months/`
4. Read the current yearly note from `7 - Journal/Years/`

Using this context, assess the idea against his actual commitments and propose one of three verdicts:

- **Blocked by [specific goal or condition]** — name what needs to be true before this idea makes sense. Be concrete: not "when I have more time" but "after completing AZ-104 and KubeCraft OS1" or "when I have daily hands-on experience with X."
- **Ready now** — if nothing blocks it and it aligns with current goals, flag it as a candidate for `1 - Projects/` immediately.
- **Kill it** — if the idea doesn't connect to any foreseeable goal horizon and the problem it solves isn't real or urgent, recommend killing it. State why plainly.

Present your verdict to Juanes with a one-sentence rationale before filing. He can override it.

Then write the settled card and append it to the `## Settled` section of `0 - Inbox/_Ideas.md`:

```markdown
### [Idea Title]
**Problem:** [one or two sentences from question 1]
**Approach:** [one paragraph from question 2]
**Blocked by:** [specific blocker, "Ready — candidate for Projects/", or "Killed — [reason]"]
*Settled: [today's date]*
```

Then remove the idea from `## Incomplete` if it was listed there.

Confirm to Juanes what was filed. No further review needed.

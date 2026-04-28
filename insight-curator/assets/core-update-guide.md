# Core Update Guide

> Step 3 of the curation workflow. How to add a principle to a core SKILL.md.

## Before Writing

1. **Read the existing core skill** first.
2. Ask three questions:
   - **Already covered?** → Skip, or merge if your wording is clearer. Do not append.
   - **Contradicts existing?** → Resolve the conflict. Replace or reconcile. Do not stack.
   - **Genuinely new?** → Add as a principle.

## Write as Principle, Not Patch

Bad (patch):

```
Remember to check token expiry with <= not <.
```

Good (principle):

```
Verify boundary conditions on all comparison operators in auth flows.
```

Bad (patch):

```
When using fetchURL, pass headers as a second argument.
```

Good (principle):

```
Always validate API client configuration against the latest provider spec before use.
```

## Principles of Good Principles

- **Abstract the mechanism**, not the symptom
- **State the invariant** (what should always be true), not the fix
- **One idea per principle** — no compound rules
- **Short enough to remember**, specific enough to act on

## Placement

- Add to the most relevant section (Triggers, Workflow, or Rules)
- If no section fits, prefer Rules for behavioral principles
- Keep the total core skill lean — if it grows past ~100 lines, consider whether some content belongs in references

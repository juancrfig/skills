# Example Curation Session

> This reference shows how a closed error report becomes a core update and a reference file.

Source report: `Error Report — API 401 after token refresh`
Date: 2026-04-20

---

## Step 1 — Read Report Fully

**What misled investigation:**
The 401 appeared immediately after a successful token refresh, so the team assumed the refresh itself had failed or returned stale credentials. They spent an hour logging refresh responses before noticing the issue.

**Gap between initial hypotheses and root cause:**
Initial hypothesis: "Refresh token is expired or revoked."
Root cause: The refreshed token was correct, but it was being sent with `Bearer <token>` in a header named `Authentication` instead of `Authorization`. A typo in the auth middleware.

**Why it wasn't anticipated:**
No one checked the header name because the code "had been working for months." The typo was introduced during a refactor that extracted the header-setting logic into a helper. The helper was unit-tested for token format but not header name.

## Step 2 — Abstraction Test

| Insight | Similar-but-different? | Decision |
|---------|------------------------|----------|
| "Check header names after refactor" | Yes — any extracted logic can drift from its original context | Core principle |
| "Auth middleware typo pattern" | No — very specific to this codebase's refactor | Reference file |

## Step 3 — Core Update

**Existing core skill checked:** `api-client/SKILL.md`

- Not already covered.
- No contradiction found.
- Genuinely new principle.

**Added to `api-client/SKILL.md` under Rules:**

```markdown
- After extracting or refactoring request-construction logic, verify that
  every outgoing header, query param, and path segment matches the original
  behavior end-to-end. Unit tests of the extracted helper are not sufficient.
```

## Step 4 — Reference File

Created `references/auth-middleware-typo-check.md`:

```markdown
# Auth Middleware Typo Check

> Post-refactor verification checklist for auth header logic.

Date: 2026-04-20
Last referenced: 2026-04-20
Source report: API 401 after token refresh

## Context

Run this after any refactor that moves header-setting logic into a helper,
middleware, or interceptor.

## Procedure

1. Identify every HTTP header the original code set
2. In the refactored code, trace each header from the call site to the wire
3. Verify the header *name* and *value* are unchanged
4. Run a live request and inspect the actual headers sent (not mocks)

## Notes

- Common drift: `Authentication` vs `Authorization`, `ContentType` vs `Content-Type`
- Mocks often hide this because they match on URL or body, not headers
- If using an HTTP client wrapper, check the wrapper's default headers too
```

## Step 5 — Reference Discovery

Scanned `api-client/references/`. No existing auth-related reference files. No duplicate created.

## Step 6 — Update Last Referenced

- `api-client/SKILL.md`: Last referenced updated
- `api-client/references/auth-middleware-typo-check.md`: Last referenced updated

## Result

One core principle added, one reference file created, report safely closed.

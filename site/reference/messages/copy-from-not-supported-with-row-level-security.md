---
message: "COPY FROM not supported with row-level security"
slug: copy-from-not-supported-with-row-level-security
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/copy.c:251"
reproduced: false
---

# `COPY FROM not supported with row-level security`

## What it means

A `COPY FROM` targeted a table with active row-level security policies. `COPY FROM` bypasses per-row policy checks, so it is not allowed when RLS applies to the current role.

## When it happens

It happens on `COPY tab FROM ...` when the table has RLS enabled and the current user is subject to its policies.

## How to fix

Load the data with `INSERT` (which enforces RLS policies), or run the `COPY` as a role that bypasses RLS (the table owner with `BYPASSRLS`, or after `ALTER TABLE ... DISABLE ROW LEVEL SECURITY` if appropriate). Use `INSERT ... SELECT` for policy-checked bulk loads.

## Example

*Illustrative* — COPY FROM into an RLS-protected table.

```text
ERROR:  COPY FROM not supported with row-level security
-- HINT:  Use INSERT statements instead.
```

## Related

- [COPY query must have a RETURNING clause](./copy-query-must-have-a-returning-clause.md)
- [COPY (SELECT INTO) is not supported](./copy-select-into-is-not-supported.md)

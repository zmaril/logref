---
message: "ON CONFLICT DO SELECT requires a RETURNING clause"
slug: on-conflict-do-select-requires-a-returning-clause
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/parser/analyze.c:1065"
  - "postgres/src/backend/rewrite/rewriteHandler.c:704"
reproduced: false
---

# `ON CONFLICT DO SELECT requires a RETURNING clause`

## What it means

An `INSERT ... ON CONFLICT DO SELECT` was written without a `RETURNING` clause. The `DO SELECT` form exists to return the conflicting rows, so it needs `RETURNING` to have any output.

## When it happens

It arises using the `ON CONFLICT ... DO SELECT` action without attaching a `RETURNING` list to the `INSERT`.

## How to fix

Add a `RETURNING` clause naming the columns you want back from the conflicting/inserted rows. `DO SELECT` without `RETURNING` has no effect and is rejected.

## Example

*Illustrative* — DO SELECT with no RETURNING.

```sql
INSERT INTO t VALUES (1) ON CONFLICT (id) DO SELECT;  -- needs RETURNING
```

## Related

- [is not allowed in ON CONFLICT clause](./is-not-allowed-in-on-conflict-clause.md)
- [only WITH CHECK expression allowed for INSERT](./only-with-check-expression-allowed-for-insert.md)

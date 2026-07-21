---
message: "multiple assignments to same column \"%s\""
slug: multiple-assignments-to-same-column
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/rewrite/rewriteHandler.c:1168"
  - "postgres/src/backend/rewrite/rewriteHandler.c:1186"
reproduced: false
---

# `multiple assignments to same column "%s"`

## What it means

An `UPDATE` (or `INSERT ... ON CONFLICT DO UPDATE`) tried to set the same column more than once in a single statement. Each target column may be assigned only once. The placeholder is the column name.

## When it happens

It arises when a `SET` list names a column twice, or a multi-column assignment overlaps with a single-column one that targets the same column.

## How to fix

Assign each column exactly once. Combine the intended value into a single assignment, and check for a duplicated column in the `SET` list or an overlap between a `SET (a, b) = ...` form and a separate `SET a = ...`.

## Example

*Illustrative* — assigning a column twice.

```sql
UPDATE t SET x = 1, x = 2;  -- multiple assignments to same column
```

## Related

- [number of columns does not match number of values](./number-of-columns-does-not-match-number-of-values.md)
- [only WITH CHECK expression allowed for INSERT](./only-with-check-expression-allowed-for-insert.md)

---
message: "each %s query must have the same number of columns"
slug: each-query-must-have-the-same-number-of-columns
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/parser/analyze.c:2617"
reproduced: false
---

# `each %s query must have the same number of columns`

## What it means

A set operation (`UNION`, `INTERSECT`, or `EXCEPT`) combined queries that return different numbers of columns. The placeholder names the operation. Both sides of a set operation must have matching column counts.

## When it happens

It fires during parse analysis of a `UNION`/`INTERSECT`/`EXCEPT` when the branches produce a different number of output columns.

## How to fix

Make each branch select the same number of columns, in the same order and with compatible types. Add or remove columns from one side, or use explicit `NULL::type` placeholders to line the lists up.

## Example

*Illustrative* — a UNION with mismatched column counts.

```sql
SELECT a, b FROM t UNION SELECT a FROM t;
-- each UNION query must have the same number of columns
```

## Related

- [empty query does not return tuples](./empty-query-does-not-return-tuples.md)
- [DISTINCT is not implemented for window functions](./distinct-is-not-implemented-for-window-functions.md)

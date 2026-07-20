---
message: "SELECT DISTINCT ON expressions must match initial ORDER BY expressions"
slug: select-distinct-on-expressions-must-match-initial-order-by-expressions
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_COLUMN_REFERENCE
    code: "42P10"
call_sites:
  - "postgres/src/backend/parser/parse_clause.c:3323"
  - "postgres/src/backend/parser/parse_clause.c:3355"
reproduced: false
---

# `SELECT DISTINCT ON expressions must match initial ORDER BY expressions`

## What it means

A `SELECT DISTINCT ON (...)` query has an `ORDER BY` whose leading expressions do not match the `DISTINCT ON` expressions. For `DISTINCT ON` to pick a well-defined row per group, the `ORDER BY` must begin with the same expressions.

## When it happens

It arises when the `DISTINCT ON (a, b)` list is not a prefix of the `ORDER BY` list — for example ordering by a different column first.

## How to fix

Make `ORDER BY` start with exactly the `DISTINCT ON` expressions, then add any further ordering. For `DISTINCT ON (a, b)`, write `ORDER BY a, b, other_col` so the row kept per (a,b) group is deterministic.

## Example

*Illustrative* — DISTINCT ON that does not lead the ORDER BY.

```text
ERROR:  SELECT DISTINCT ON expressions must match initial ORDER BY expressions
```

## Related

- [ORDER/GROUP BY expression not found in targetlist](./order-group-by-expression-not-found-in-targetlist.md)
- [subquery must return only one column](./subquery-must-return-only-one-column.md)

---
message: "arguments to GROUPING must be grouping expressions of the associated query level"
slug: arguments-to-grouping-must-be-grouping-expressions-of-the-associated-query-level
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_GROUPING_ERROR
    code: "42803"
call_sites:
  - "postgres/src/backend/parser/parse_agg.c:1777"
reproduced: false
---

# `arguments to GROUPING must be grouping expressions of the associated query level`

## What it means

The `GROUPING()` function was given an argument that is not one of the grouping expressions of the query level it belongs to, so it cannot report that expression's grouping status.

## When it happens

It occurs with `GROUPING SETS`, `ROLLUP`, or `CUBE` when `GROUPING(expr)` names an expression that is not part of the `GROUP BY` grouping expressions at that level.

## How to fix

Pass to `GROUPING()` only expressions that appear in the query's grouping clause. Reference the exact grouping columns/expressions used in `GROUP BY GROUPING SETS`/`ROLLUP`/`CUBE`.

## Example

*Illustrative* — GROUPING over a non-grouping expression.

```sql
SELECT GROUPING(z) FROM t GROUP BY ROLLUP (x, y);  -- z is not a grouping expression
```

## Related

- [argument of must not contain variables](./argument-of-must-not-contain-variables.md)
- [aggregate functions are not allowed in](./aggregate-functions-are-not-allowed-in.md)

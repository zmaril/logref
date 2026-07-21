---
message: "set-returning functions are not allowed in %s"
slug: set-returning-functions-are-not-allowed-in
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/parser/parse_expr.c:1783"
  - "postgres/src/backend/parser/parse_expr.c:2282"
  - "postgres/src/backend/parser/parse_func.c:2811"
reproduced: false
---

# `set-returning functions are not allowed in %s`

## What it means

A set-returning function was used in a clause where only scalar expressions are allowed. Set-returning functions produce multiple rows, and some clauses — such as `WHERE`, `CASE`, or aggregate arguments — cannot accept a row-producing expression. The message names the clause.

## When it happens

Placing a function like `generate_series`, `unnest`, or a custom set-returning function in a context that must yield a single value per row, such as a `WHERE` condition, a `CASE` branch, or the argument of an aggregate.

## How to fix

Move the set-returning call to a position that accepts a set — usually the `FROM` clause, often with `LATERAL`, or the target list where it is allowed. Join against its output rather than embedding it in a scalar clause. The message names the clause that rejected it, which points to what to restructure.

## Example

*Illustrative* — a set-returning function in WHERE.

```sql
SELECT * FROM t WHERE x = ANY(generate_series(1, 10)) ;  -- move the SRF to FROM
```

## Related

- [set-returning functions must appear at top level of from](./set-returning-functions-must-appear-at-top-level-of-from.md)
- [is not allowed in a non-volatile function](./is-not-allowed-in-a-non-volatile-function.md)

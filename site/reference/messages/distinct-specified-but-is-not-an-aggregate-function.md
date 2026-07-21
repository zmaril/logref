---
message: "DISTINCT specified, but %s is not an aggregate function"
slug: distinct-specified-but-is-not-an-aggregate-function
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/parser/parse_func.c:325"
reproduced: false
---

# `DISTINCT specified, but %s is not an aggregate function`

## What it means

A function call used `DISTINCT` in its argument list, but the function is an ordinary (non-aggregate) function. `DISTINCT` in the argument list is only meaningful for aggregates. The placeholder names the function.

## When it happens

It fires during parse analysis when `func(DISTINCT ...)` names a plain function rather than an aggregate.

## How to fix

Remove `DISTINCT` from the argument list of the non-aggregate call. If you meant to deduplicate rows, use `SELECT DISTINCT` at the query level, or call an aggregate that supports `DISTINCT`.

## Example

*Illustrative* — `DISTINCT` on a scalar function.

```sql
SELECT lower(DISTINCT name) FROM t;
-- DISTINCT specified, but lower is not an aggregate function
```

## Related

- [DISTINCT is not implemented for window functions](./distinct-is-not-implemented-for-window-functions.md)
- [DEFAULT is not allowed in this context](./default-is-not-allowed-in-this-context.md)

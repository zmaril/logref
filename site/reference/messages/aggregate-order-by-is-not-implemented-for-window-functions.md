---
message: "aggregate ORDER BY is not implemented for window functions"
slug: aggregate-order-by-is-not-implemented-for-window-functions
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/parser/parse_expr.c:3988"
  - "postgres/src/backend/parser/parse_func.c:885"
reproduced: false
---

# `aggregate ORDER BY is not implemented for window functions`

## What it means

An `ORDER BY` was written inside the argument list of an aggregate used as a window function. Ordered aggregation within the argument parentheses is not supported when the aggregate runs as a window function over an `OVER` clause.

## When it happens

Writing something like `agg(x ORDER BY y) OVER (...)`, combining an aggregate's internal `ORDER BY` with window-function usage, which the implementation does not support.

## How to fix

Remove the `ORDER BY` from inside the aggregate's arguments. Order the window itself with the `ORDER BY` inside the `OVER (...)` clause instead, or compute the ordered aggregate in a separate non-windowed query and join the result. The two forms of ordering cannot be combined here.

## Example

*Illustrative* — ordered aggregate used as a window function.

```sql
SELECT array_agg(x ORDER BY y) OVER (PARTITION BY g) FROM t;  -- not supported
```

## Related

- [is an aggregate function](./is-an-aggregate-function.md)
- [window functions are not allowed in](./window-functions-are-not-allowed-in.md)

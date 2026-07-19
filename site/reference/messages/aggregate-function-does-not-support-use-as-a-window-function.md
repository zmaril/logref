---
message: "aggregate function %s does not support use as a window function"
slug: aggregate-function-does-not-support-use-as-a-window-function
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/executor/nodeWindowAgg.c:3078"
reproduced: false
---

# `aggregate function %s does not support use as a window function`

## What it means

An aggregate was used with an `OVER (...)` clause, but this particular aggregate is not permitted to act as a window function.

## When it happens

It occurs when a `WITHIN GROUP` ordered-set or hypothetical-set aggregate (or another aggregate not allowed as a window function) is called with an `OVER` clause.

## How to fix

Use the aggregate in its supported form — as a plain aggregate with `GROUP BY` or `WITHIN GROUP` — rather than as a window function. If you need windowed behavior, choose a function that supports `OVER`, or restructure the query.

## Example

*Illustrative* — an ordered-set aggregate used as a window function.

```sql
SELECT percentile_cont(0.5) WITHIN GROUP (ORDER BY x) OVER () FROM t;  -- ERROR
```

## Related

- [aggregate function calls cannot contain window function calls](./aggregate-function-calls-cannot-contain-window-function-calls.md)
- [aggregate functions do not accept RESPECT/IGNORE NULLS](./aggregate-functions-do-not-accept-respect-ignore-nulls.md)

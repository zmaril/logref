---
message: "aggregate function calls cannot contain window function calls"
slug: aggregate-function-calls-cannot-contain-window-function-calls
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_GROUPING_ERROR
    code: "42803"
call_sites:
  - "postgres/src/backend/parser/parse_agg.c:833"
reproduced: false
---

# `aggregate function calls cannot contain window function calls`

## What it means

An aggregate's argument expression contained a window function call, which is not allowed because window functions are evaluated after aggregation, not inside it.

## When it happens

It occurs when a window function (an `OVER (...)` call) is nested inside an aggregate's argument, for example `sum(rank() OVER (...))`.

## How to fix

Compute the window function in a subquery first, then aggregate its result in an outer query. Aggregation and windowing happen in different phases, so they must be layered rather than nested.

## Example

*Illustrative* — a window function inside an aggregate.

```sql
SELECT sum(row_number() OVER ()) FROM t;  -- ERROR
```

## Related

- [aggregate function calls cannot contain set-returning function calls](./aggregate-function-calls-cannot-contain-set-returning-function-calls.md)
- [aggregate function does not support use as a window function](./aggregate-function-does-not-support-use-as-a-window-function.md)

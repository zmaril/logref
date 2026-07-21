---
message: "aggregate function calls cannot contain set-returning function calls"
slug: aggregate-function-calls-cannot-contain-set-returning-function-calls
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/parser/parse_agg.c:827"
reproduced: true
---

# `aggregate function calls cannot contain set-returning function calls`

## What it means

An aggregate's argument expression contained a set-returning function call, which is not allowed because an aggregate argument must produce a single value per input row.

## When it happens

It occurs when a set-returning function (like `unnest` or `generate_series`) is nested inside an aggregate's argument, for example `sum(unnest(arr))`.

## How to fix

Move the set-returning function out of the aggregate: expand the set in a `FROM`-clause function or a lateral subquery first, then aggregate over the resulting rows. `SELECT sum(x) FROM t, unnest(t.arr) AS x` is the usual rewrite.

## Example

*Reproduced* — captured from `reproducers/scenarios/44_functions_operators_aggregates.sql`.

```sql
SELECT sum(generate_series(1, 3));
```

Produces:

```text
ERROR:  aggregate function calls cannot contain set-returning function calls
```

## Related

- [aggregate function calls cannot contain window function calls](./aggregate-function-calls-cannot-contain-window-function-calls.md)
- [aggregate functions are not allowed in](./aggregate-functions-are-not-allowed-in.md)

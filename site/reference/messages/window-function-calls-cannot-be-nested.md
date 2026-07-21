---
message: "window function calls cannot be nested"
slug: window-function-calls-cannot-be-nested
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WINDOWING_ERROR
    code: "42P20"
call_sites:
  - "postgres/src/backend/executor/execExpr.c:1155"
  - "postgres/src/backend/parser/parse_agg.c:910"
reproduced: true
---

# `window function calls cannot be nested`

## What it means

A window-function call was written directly inside the arguments of another window function, which SQL does not allow.

## When it happens

It arises when an `OVER` expression contains another window function in its arguments — for example `rank() OVER (ORDER BY sum(x) OVER ())`.

## How to fix

Compute the inner window result in a subquery or CTE first, then apply the outer window function to that result. Window functions must be layered across query levels, not nested within one call.

## Example

*Reproduced* — captured from `reproducers/scenarios/44_functions_operators_aggregates.sql`.

```sql
SELECT lag(rank() OVER ()) OVER () FROM repro.parent;
```

Produces:

```text
ERROR:  window function calls cannot be nested
```

## Related

- [window functions are not allowed in %s](./window-functions-are-not-allowed-in.md)
- [window "%s" does not exist](./window-does-not-exist.md)

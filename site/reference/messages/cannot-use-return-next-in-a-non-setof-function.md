---
message: "cannot use RETURN NEXT in a non-SETOF function"
slug: cannot-use-return-next-in-a-non-setof-function
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/pl/plpgsql/src/pl_exec.c:3366"
reproduced: false
---

# `cannot use RETURN NEXT in a non-SETOF function`

## What it means

A PL/pgSQL function used `RETURN NEXT`, but the function is not declared to return a set. `RETURN NEXT` appends a row to a result set, so it is only valid in a `SETOF` (or table-returning) function.

## When it happens

It occurs when a function body contains `RETURN NEXT` while the function's signature returns a single value rather than `SETOF` or `TABLE`.

## How to fix

Declare the function as `RETURNS SETOF type` or `RETURNS TABLE (...)`, or replace `RETURN NEXT` with a plain `RETURN` if the function should yield one value.

## Example

*Illustrative* — RETURN NEXT in a scalar function.

```text
ERROR:  cannot use RETURN NEXT in a non-SETOF function
```

## Related

- [cannot use RETURN QUERY in a non-SETOF function](./cannot-use-return-query-in-a-non-setof-function.md)
- [cannot use table references in parameter default value](./cannot-use-table-references-in-parameter-default-value.md)

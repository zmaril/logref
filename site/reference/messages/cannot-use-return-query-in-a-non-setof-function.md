---
message: "cannot use RETURN QUERY in a non-SETOF function"
slug: cannot-use-return-query-in-a-non-setof-function
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/pl/plpgsql/src/pl_exec.c:3588"
reproduced: false
---

# `cannot use RETURN QUERY in a non-SETOF function`

## What it means

A PL/pgSQL function used `RETURN QUERY`, but the function is not declared to return a set. `RETURN QUERY` emits the rows of a query into a result set, so it requires a `SETOF` or table-returning function.

## When it happens

It occurs when a function body contains `RETURN QUERY` while the signature returns a single value rather than `SETOF` or `TABLE`.

## How to fix

Declare the function as `RETURNS SETOF type` or `RETURNS TABLE (...)`. If the function should return one value, run the query with `SELECT ... INTO` and use a plain `RETURN`.

## Example

*Illustrative* — RETURN QUERY in a scalar function.

```text
ERROR:  cannot use RETURN QUERY in a non-SETOF function
```

## Related

- [cannot use RETURN NEXT in a non-SETOF function](./cannot-use-return-next-in-a-non-setof-function.md)
- [cannot use table references in parameter default value](./cannot-use-table-references-in-parameter-default-value.md)

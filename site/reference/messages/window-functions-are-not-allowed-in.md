---
message: "window functions are not allowed in %s"
slug: window-functions-are-not-allowed-in
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WINDOWING_ERROR
    code: "42P20"
call_sites:
  - "postgres/src/backend/parser/parse_agg.c:1063"
  - "postgres/src/backend/parser/parse_clause.c:2116"
reproduced: false
---

# `window functions are not allowed in %s`

## What it means

A window function appeared in a clause where window functions are not permitted, such as `WHERE`, `GROUP BY`, `HAVING`, or an aggregate's arguments.

## When it happens

It arises when a window function is placed in a clause evaluated before windowing happens — window functions run after grouping and filtering, so they cannot drive those clauses.

## How to fix

Move the window function into the `SELECT` list (or `ORDER BY`), then filter or group on its result in an enclosing subquery or CTE. The named clause runs before window functions are computed.

## Example

*Illustrative* — a window function in WHERE.

```text
ERROR:  window functions are not allowed in WHERE
```

## Related

- [window function calls cannot be nested](./window-function-calls-cannot-be-nested.md)
- [window "%s" does not exist](./window-does-not-exist.md)

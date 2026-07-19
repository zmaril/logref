---
message: "function has wrong number of declared columns"
slug: function-has-wrong-number-of-declared-columns
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_FUNCTION_DEFINITION
    code: "42P13"
call_sites:
  - "postgres/contrib/pageinspect/brinfuncs.c:161"
  - "postgres/contrib/pageinspect/btreefuncs.c:896"
reproduced: false
---

# `function has wrong number of declared columns`

## What it means

A set-returning function's actual result columns did not match the column list declared for it. It fires when a function returning `record` is used with a column definition list of a different width.

## When it happens

Calling a `RETURNS record`/`RETURNS SETOF record` function (or a `pageinspect`-style function) with an `AS (col type, ...)` list whose number of columns differs from what the function produces.

## How to fix

Match the column definition list to the function's real output — the right number of columns with compatible types. Consult the function's documented result shape and correct the `AS (...)` list.

## Example

*Illustrative* — a mismatched column definition list.

```text
ERROR:  function has wrong number of declared columns
```

## Related

- [functions in FROM can return at most columns](./functions-in-from-can-return-at-most-columns.md)
- [function should return type](./function-should-return-type.md)

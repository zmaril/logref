---
message: "ROWS is not applicable when function does not return a set"
slug: rows-is-not-applicable-when-function-does-not-return-a-set
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/commands/functioncmds.c:1269"
  - "postgres/src/backend/commands/functioncmds.c:1458"
reproduced: false
---

# `ROWS is not applicable when function does not return a set`

## What it means

A `CREATE FUNCTION` specified the `ROWS` estimate, but the function does not return a set (`RETURNS SETOF`/`RETURNS TABLE`). The `ROWS` planner hint only makes sense for set-returning functions.

## When it happens

It arises when defining a scalar-returning function and including a `ROWS n` clause that only applies to functions producing multiple rows.

## How to fix

Remove the `ROWS` clause for a scalar function. If the function is meant to return many rows, declare it `RETURNS SETOF type` or `RETURNS TABLE(...)`, after which `ROWS` becomes valid.

## Example

*Illustrative* — ROWS on a non-set-returning function.

```text
ERROR:  ROWS is not applicable when function does not return a set
```

## Related

- [ROWS must be positive](./rows-must-be-positive.md)
- [parameter "parallel" must be SAFE, RESTRICTED, or UNSAFE](./parameter-parallel-must-be-safe-restricted-or-unsafe.md)

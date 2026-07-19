---
message: "ROWS must be positive"
slug: rows-must-be-positive
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/commands/functioncmds.c:848"
  - "postgres/src/backend/commands/functioncmds.c:1454"
reproduced: false
---

# `ROWS must be positive`

## What it means

A `CREATE FUNCTION ... ROWS n` clause gave a value that is not greater than zero. The estimated number of rows a set-returning function produces must be a positive number.

## When it happens

It arises when defining a set-returning function with `ROWS 0` or a negative value.

## How to fix

Provide a positive estimate for `ROWS` — a rough count of the rows the function typically returns. If you have no better estimate, omit `ROWS` and let the default apply.

## Example

*Illustrative* — a non-positive ROWS estimate.

```text
ERROR:  ROWS must be positive
```

## Related

- [ROWS is not applicable when function does not return a set](./rows-is-not-applicable-when-function-does-not-return-a-set.md)
- [statistics target %d is too low](./statistics-target-is-too-low.md)

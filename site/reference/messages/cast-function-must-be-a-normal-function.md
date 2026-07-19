---
message: "cast function must be a normal function"
slug: cast-function-must-be-a-normal-function
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_OBJECT_DEFINITION
    code: "42P17"
call_sites:
  - "postgres/src/backend/commands/functioncmds.c:1663"
reproduced: false
---

# `cast function must be a normal function`

## What it means

A `CREATE CAST ... WITH FUNCTION` named a routine that is not an ordinary function. Cast functions must be plain functions, so an aggregate, window function, or procedure cannot back a cast.

## When it happens

It occurs on `CREATE CAST` when the referenced function is defined as an aggregate, a window function, or a procedure.

## How to fix

Use a plain function that takes the source type and returns the target type as the cast function. Define an ordinary `CREATE FUNCTION` for the conversion and reference it.

## Example

*Illustrative* — an aggregate as a cast function.

```text
ERROR:  cast function must be a normal function
```

## Related

- [cast function must not be volatile](./cast-function-must-not-be-volatile.md)
- [cast function must not return a set](./cast-function-must-not-return-a-set.md)

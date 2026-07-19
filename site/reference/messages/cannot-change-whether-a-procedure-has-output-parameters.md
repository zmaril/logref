---
message: "cannot change whether a procedure has output parameters"
slug: cannot-change-whether-a-procedure-has-output-parameters
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_FUNCTION_DEFINITION
    code: "42P13"
call_sites:
  - "postgres/src/backend/catalog/pg_proc.c:439"
reproduced: false
---

# `cannot change whether a procedure has output parameters`

## What it means

A `CREATE OR REPLACE PROCEDURE` changed whether the procedure has output parameters. The presence of `OUT`/`INOUT` parameters is part of the procedure's identity and affects how it is called, so it cannot be toggled in a replacement.

## When it happens

It occurs when replacing a procedure and adding or removing output parameters relative to the existing definition.

## How to fix

Keep the output-parameter shape unchanged when replacing a procedure. To change it, drop the procedure and create a new one with the desired parameters.

## Example

*Illustrative* — changing output parameters.

```text
ERROR:  cannot change whether a procedure has output parameters
```

## Related

- [cannot change return type of existing function](./cannot-change-return-type-of-existing-function.md)
- [cannot change number of direct arguments of an aggregate function](./cannot-change-number-of-direct-arguments-of-an-aggregate-function.md)

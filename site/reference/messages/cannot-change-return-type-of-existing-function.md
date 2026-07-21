---
message: "cannot change return type of existing function"
slug: cannot-change-return-type-of-existing-function
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_FUNCTION_DEFINITION
    code: "42P13"
call_sites:
  - "postgres/src/backend/catalog/pg_proc.c:471"
reproduced: false
---

# `cannot change return type of existing function`

## What it means

A `CREATE OR REPLACE FUNCTION` changed the function's declared return type. The return type is part of a function's identity, and dependents rely on it, so a replacement must keep the same return type.

## When it happens

It occurs when replacing an existing function with a definition that declares a different `RETURNS` type.

## How to fix

Keep the return type unchanged when replacing a function. To change it, drop the function and create it anew, updating any objects that depend on the old signature.

## Example

*Illustrative* — changing a return type.

```text
ERROR:  cannot change return type of existing function
```

## Related

- [cannot change name of input parameter](./cannot-change-name-of-input-parameter.md)
- [cannot change whether a procedure has output parameters](./cannot-change-whether-a-procedure-has-output-parameters.md)

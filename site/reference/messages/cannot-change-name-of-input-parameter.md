---
message: "cannot change name of input parameter \"%s\""
slug: cannot-change-name-of-input-parameter
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_FUNCTION_DEFINITION
    code: "42P13"
call_sites:
  - "postgres/src/backend/catalog/pg_proc.c:516"
reproduced: false
---

# `cannot change name of input parameter "%s"`

## What it means

A `CREATE OR REPLACE FUNCTION` renamed an existing input parameter. Because callers may use named-argument notation, a replacement function must keep the names of its input parameters. The placeholder is the parameter name.

## When it happens

It occurs when replacing a function and giving one of its input parameters a different name than before.

## How to fix

Keep input parameter names stable across `CREATE OR REPLACE`. To rename a parameter, drop the function and create it anew, accepting that any named-argument callers must be updated.

## Example

*Illustrative* — renaming a parameter.

```text
ERROR:  cannot change name of input parameter "x"
```

## Related

- [cannot change data type of existing parameter default value](./cannot-change-data-type-of-existing-parameter-default-value.md)
- [cannot change return type of existing function](./cannot-change-return-type-of-existing-function.md)

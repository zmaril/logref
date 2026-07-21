---
message: "cannot change data type of existing parameter default value"
slug: cannot-change-data-type-of-existing-parameter-default-value
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_FUNCTION_DEFINITION
    code: "42P13"
call_sites:
  - "postgres/src/backend/catalog/pg_proc.c:567"
reproduced: false
---

# `cannot change data type of existing parameter default value`

## What it means

A `CREATE OR REPLACE FUNCTION` changed the data type of a parameter that has a default value, without dropping the default. When a parameter keeps its default across a replacement, its type must stay the same so the stored default expression remains valid.

## When it happens

It occurs when replacing a function and altering the declared type of a parameter that carries a `DEFAULT`, while still retaining the default.

## How to fix

Keep the parameter's type unchanged, or drop and recreate the function so the default is re-parsed against the new type. Removing the default in the replacement definition also avoids the conflict.

## Example

*Illustrative* — retyping a defaulted parameter.

```text
ERROR:  cannot change data type of existing parameter default value
```

## Related

- [cannot change name of input parameter](./cannot-change-name-of-input-parameter.md)
- [cannot change return type of existing function](./cannot-change-return-type-of-existing-function.md)

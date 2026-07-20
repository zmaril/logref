---
message: "cannot remove parameter defaults from existing function"
slug: cannot-remove-parameter-defaults-from-existing-function
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_FUNCTION_DEFINITION
    code: "42P13"
call_sites:
  - "postgres/src/backend/catalog/pg_proc.c:543"
reproduced: false
---

# `cannot remove parameter defaults from existing function`

## What it means

A `CREATE OR REPLACE FUNCTION` tried to drop default values that the existing function's parameters already have. Replacing a function may add defaults but not remove them, because callers may depend on the shorter call signature.

## When it happens

It occurs when you replace a function and omit default values that the previous definition supplied for some parameters.

## How to fix

Keep the existing parameter defaults in the replacement definition, or `DROP FUNCTION` and recreate it if you truly need to remove the defaults (after confirming no callers rely on them).

## Example

*Illustrative* — replacing a function without its defaults.

```text
ERROR:  cannot remove parameter defaults from existing function
```

## Related

- [cannot pass more than argument to a procedure](./cannot-pass-more-than-argument-to-a-procedure.md)
- [cannot specify a canonical function without a pre-created shell type](./cannot-specify-a-canonical-function-without-a-pre-created-shell-type.md)

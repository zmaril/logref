---
message: "cannot specify a canonical function without a pre-created shell type"
slug: cannot-specify-a-canonical-function-without-a-pre-created-shell-type
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_OBJECT_DEFINITION
    code: "42P17"
call_sites:
  - "postgres/src/backend/commands/typecmds.c:1548"
reproduced: false
---

# `cannot specify a canonical function without a pre-created shell type`

## What it means

A `CREATE TYPE` for a range or base type specified a canonical function, but no shell type existed for it first. A canonical function refers to the type it belongs to, so the type must be pre-declared as a shell before the function can reference it.

## When it happens

It occurs when you define a type with a `CANONICAL` function in a single `CREATE TYPE` without first creating the shell type with a bare `CREATE TYPE name`.

## How to fix

Create the shell type first with `CREATE TYPE name;`, define the canonical function against it, then complete the type definition. The two-step declaration lets the function reference its own type.

## Example

*Illustrative* — a canonical function without a shell type.

```text
ERROR:  cannot specify a canonical function without a pre-created shell type
```

## Related

- [cannot remove parameter defaults from existing function](./cannot-remove-parameter-defaults-from-existing-function.md)
- [cannot set privileges of array types](./cannot-set-privileges-of-array-types.md)

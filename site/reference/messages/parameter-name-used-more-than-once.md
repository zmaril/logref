---
message: "parameter name \"%s\" used more than once"
slug: parameter-name-used-more-than-once
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_FUNCTION_DEFINITION
    code: "42P13"
call_sites:
  - "postgres/src/backend/commands/functioncmds.c:398"
  - "postgres/src/pl/plpgsql/src/pl_comp.c:931"
reproduced: false
---

# `parameter name "%s" used more than once`

## What it means

A list of named parameters or options contained the same name twice. The placeholder is the duplicated name. Each name in such a list must be unique.

## When it happens

It arises when defining or altering an object whose option list repeats a key — for example a foreign server, user mapping, or a function's named arguments — with the same name appearing more than once.

## How to fix

Remove the duplicate so each parameter name appears once. If you meant to change an existing value rather than add it again, use the appropriate `SET` form instead of listing it twice.

## Example

*Illustrative* — an option list repeating a key.

```text
ERROR:  parameter name "host" used more than once
```

## Related

- [%s options %s and %s cannot be used together](./options-and-cannot-be-used-together-72fe42.md)
- [parameter "parallel" must be SAFE, RESTRICTED, or UNSAFE](./parameter-parallel-must-be-safe-restricted-or-unsafe.md)

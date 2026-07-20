---
message: "function %s should return type %s"
slug: function-should-return-type
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_OBJECT_DEFINITION
    code: "42P17"
call_sites:
  - "postgres/src/backend/commands/tsearchcmds.c:122"
  - "postgres/src/backend/commands/tsearchcmds.c:639"
reproduced: false
---

# `function %s should return type %s`

## What it means

A function supplied for a text-search or similar template did not have the required return type. The `%s` values are the function and the expected type. The function's signature does not fit the role it was given.

## When it happens

Creating a text-search template, parser, or dictionary (or a similar pluggable component) with a support function whose return type is wrong.

## How to fix

Provide a support function whose return type matches what the template requires. Correct the function signature or point at the right function.

## Example

*Illustrative* — a support function with the wrong return type.

```text
ERROR:  function my_lexize should return type internal
```

## Related

- [final function with extra arguments must not be declared STRICT](./final-function-with-extra-arguments-must-not-be-declared-strict.md)
- [function has wrong number of declared columns](./function-has-wrong-number-of-declared-columns.md)

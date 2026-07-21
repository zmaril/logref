---
message: "cast function must not be volatile"
slug: cast-function-must-not-be-volatile
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_OBJECT_DEFINITION
    code: "42P17"
call_sites:
  - "postgres/src/backend/commands/functioncmds.c:1658"
reproduced: false
---

# `cast function must not be volatile`

## What it means

A `CREATE CAST ... WITH FUNCTION` named a function marked `VOLATILE`. Casts may be applied by the planner in ways that assume stable results, so the backing function must be `IMMUTABLE` or `STABLE`.

## When it happens

It occurs on `CREATE CAST` when the referenced function's volatility is `VOLATILE`.

## How to fix

Mark the cast function `IMMUTABLE` (or `STABLE`) if its result depends only on its input, then recreate the cast. Do not use a volatile function for a cast.

## Example

*Illustrative* — a volatile cast function.

```text
ERROR:  cast function must not be volatile
```

## Related

- [cast function must be a normal function](./cast-function-must-be-a-normal-function.md)
- [cast function must take one to three arguments](./cast-function-must-take-one-to-three-arguments.md)

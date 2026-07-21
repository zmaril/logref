---
message: "invalid parameter mode '%c'"
slug: invalid-parameter-mode
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/catalog/pg_proc.c:312"
  - "postgres/src/backend/utils/adt/ruleutils.c:3760"
reproduced: false
---

# `invalid parameter mode '%c'`

## What it means

Internal error. A function parameter mode byte was not one of the recognized modes (in, out, inout, variadic, table). The placeholder is the unrecognized mode character. It is a consistency guard over `pg_proc.proargmodes`.

## When it happens

It fires when function-definition or call code reads a parameter mode that is not valid. A normally created function does not reach it; it points to corrupted `pg_proc` data or an internal inconsistency.

## How to fix

This is a can't-happen guard. If a specific function triggers it, its catalog row may be damaged — recreate the function. Capture the function definition and report a reproducible case.

## Example

*Illustrative* — an unrecognized parameter mode.

```text
ERROR:  invalid parameter mode 'z'
```

## Related

- [not enough default arguments](./not-enough-default-arguments.md)
- [invalid attribute in procedure definition](./invalid-attribute-in-procedure-definition.md)

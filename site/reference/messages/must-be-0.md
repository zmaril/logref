---
message: "%s must be >= 0"
slug: must-be-0
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/tsearch/wparser_def.c:2639"
  - "postgres/src/backend/tsearch/wparser_def.c:2643"
reproduced: false
---

# `%s must be >= 0`

## What it means

A value that must be zero or greater was negative. The placeholder names what was being checked. It is a range check that rejects negative input.

## When it happens

It arises across many settings and function arguments that require a non-negative number — counts, sizes, offsets, and similar — when a negative value is supplied.

## How to fix

Pass a value of zero or more for the named quantity. Check the source of the value for an underflow or an accidental negation, and clamp it to the valid range.

## Example

*Illustrative* — a negative value where non-negative is required.

```text
ERROR:  window frame offset must be >= 0
```

## Related

- [must be in range](./must-be-in-range-979b1e.md)
- [number is out of range](./number-is-out-of-range.md)

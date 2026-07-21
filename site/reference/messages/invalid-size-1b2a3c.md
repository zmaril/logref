---
message: "invalid size: \"%s\""
slug: invalid-size-1b2a3c
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/utils/adt/dbsize.c:780"
  - "postgres/src/backend/utils/adt/dbsize.c:856"
reproduced: false
---

# `invalid size: "%s"`

## What it means

A human-readable size string could not be parsed. The placeholder shows the rejected text. Size strings accept a number with an optional unit such as `kB`, `MB`, `GB`, or `TB`.

## When it happens

It arises when a size-valued setting or function argument is given text that is not a valid quantity — a missing number, an unknown unit, or stray characters.

## How to fix

Write the size as a number optionally followed by a supported unit, for example `512MB` or `2GB`. Do not add spaces inside the token in contexts that forbid them, and use the documented unit suffixes.

## Example

*Illustrative* — an unparseable size string.

```text
ERROR:  invalid size: "10 gigs"
```

## Related

- [invalid value for integer option](./invalid-value-for-integer-option.md)
- [invalid size for shared memory request for](./invalid-size-for-shared-memory-request-for.md)

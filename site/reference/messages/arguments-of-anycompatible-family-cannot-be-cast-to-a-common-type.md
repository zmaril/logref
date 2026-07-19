---
message: "arguments of anycompatible family cannot be cast to a common type"
slug: arguments-of-anycompatible-family-cannot-be-cast-to-a-common-type
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATATYPE_MISMATCH
    code: "42804"
call_sites:
  - "postgres/src/backend/parser/parse_coerce.c:2592"
reproduced: false
---

# `arguments of anycompatible family cannot be cast to a common type`

## What it means

A function using the `anycompatible` family of polymorphic types was called with arguments that have no common type they can all be cast to, so the polymorphism cannot be resolved.

## When it happens

It occurs when `anycompatible`, `anycompatiblearray`, `anycompatiblerange`, and similar parameters receive a mix of argument types with no unifying common type.

## How to fix

Cast the arguments so they share a common type before the call. Determine a type all inputs can convert to and apply explicit casts, or restructure the call so the polymorphic arguments are type-compatible.

## Example

*Illustrative* — anycompatible arguments with no common type.

```text
ERROR:  arguments of anycompatible family cannot be cast to a common type
```

## Related

- [anycompatiblerange type does not match anycompatible type](./anycompatiblerange-type-does-not-match-anycompatible-type.md)
- [argument types and cannot be matched](./argument-types-and-cannot-be-matched.md)

---
message: "argument declared %s does not contain a range type but type %s"
slug: argument-declared-does-not-contain-a-range-type-but-type
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATATYPE_MISMATCH
    code: "42804"
call_sites:
  - "postgres/src/backend/utils/fmgr/funcapi.c:642"
reproduced: false
---

# `argument declared %s does not contain a range type but type %s`

## What it means

A polymorphic function declared a parameter as `anyrange` (or a related range polymorphic type), but the argument passed was not a range type, so the range-based polymorphism cannot be resolved.

## When it happens

It occurs when calling a range-polymorphic function with an argument whose type is an ordinary scalar or non-range type where a range was required.

## How to fix

Pass an actual range value (such as `int4range`, `tsrange`, or a custom range type) for the `anyrange` parameter. If you meant to work with the element type, use the appropriate range constructor or a function that takes the element type directly.

## Example

*Illustrative* — a non-range argument for a range-polymorphic parameter.

```text
ERROR:  argument declared anyrange does not contain a range type but type integer
```

## Related

- [anycompatiblerange type does not match anycompatible type](./anycompatiblerange-type-does-not-match-anycompatible-type.md)
- [argument types and cannot be matched](./argument-types-and-cannot-be-matched.md)

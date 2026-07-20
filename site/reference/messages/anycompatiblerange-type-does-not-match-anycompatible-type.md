---
message: "anycompatiblerange type %s does not match anycompatible type %s"
slug: anycompatiblerange-type-does-not-match-anycompatible-type
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATATYPE_MISMATCH
    code: "42804"
call_sites:
  - "postgres/src/backend/parser/parse_coerce.c:2620"
reproduced: false
---

# `anycompatiblerange type %s does not match anycompatible type %s`

## What it means

A function using the `anycompatiblerange` polymorphic type was called with a range whose element type is not consistent with the `anycompatible` arguments, so the polymorphic types cannot be unified.

## When it happens

It occurs when calling a polymorphic function that mixes `anycompatiblerange` and `anycompatible` parameters with arguments whose underlying types do not agree after common-type resolution.

## How to fix

Pass arguments whose types are compatible: the range's element type must match the common type chosen for the `anycompatible` arguments. Cast the inputs so the element type and the compatible scalar type align.

## Example

*Illustrative* — a range element type that does not match the compatible type.

```text
ERROR:  anycompatiblerange type int4range does not match anycompatible type text
```

## Related

- [anycompatiblemultirange type does not match anycompatible type](./anycompatiblemultirange-type-does-not-match-anycompatible-type.md)
- [arguments of anycompatible family cannot be cast to a common type](./arguments-of-anycompatible-family-cannot-be-cast-to-a-common-type.md)

---
message: "anycompatiblemultirange type %s does not match anycompatible type %s"
slug: anycompatiblemultirange-type-does-not-match-anycompatible-type
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATATYPE_MISMATCH
    code: "42804"
call_sites:
  - "postgres/src/backend/parser/parse_coerce.c:2641"
reproduced: false
---

# `anycompatiblemultirange type %s does not match anycompatible type %s`

## What it means

A function using the `anycompatiblemultirange` polymorphic type was called with a multirange whose element type is not consistent with the `anycompatible` arguments, so the polymorphic types cannot be unified.

## When it happens

It occurs when calling a polymorphic function that mixes `anycompatiblemultirange` and `anycompatible` parameters with arguments whose underlying element types do not agree after common-type resolution.

## How to fix

Pass arguments whose types are compatible: the multirange's element type must match the common type chosen for the `anycompatible` arguments. Cast the inputs so the element type and the compatible scalar type line up.

## Example

*Illustrative* — a multirange element type that does not match the compatible type.

```text
ERROR:  anycompatiblemultirange type int8multirange does not match anycompatible type numeric
```

## Related

- [anycompatiblerange type does not match anycompatible type](./anycompatiblerange-type-does-not-match-anycompatible-type.md)
- [arguments of anycompatible family cannot be cast to a common type](./arguments-of-anycompatible-family-cannot-be-cast-to-a-common-type.md)

---
message: "could not identify anycompatiblearray type"
slug: could-not-identify-anycompatiblearray-type
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATATYPE_MISMATCH
    code: "42804"
call_sites:
  - "postgres/src/backend/parser/parse_coerce.c:2834"
reproduced: false
---

# `could not identify anycompatiblearray type`

## What it means

The parser tried to resolve the `anycompatiblearray` polymorphic pseudo-type to a concrete array type and could not. This pseudo-type must resolve to an array whose element type is compatible with the other `anycompatible` arguments.

## When it happens

It fires while type-checking a call using `anycompatiblearray`, when the arguments do not determine a single array type — for example an array argument whose element type is incompatible with the rest of the call.

## How to fix

Pass an array whose element type is compatible with the other arguments, or cast the array (and its partners) to a common type. Explicit casts on the array and the related `anycompatible` inputs usually resolve the ambiguity.

## Example

*Illustrative* — an anycompatiblearray call that cannot resolve.

```text
ERROR:  could not identify anycompatiblearray type
```

## Related

- [could not identify anycompatible type](./could-not-identify-anycompatible-type.md)
- [could not identify anycompatiblemultirange type](./could-not-identify-anycompatiblemultirange-type.md)

---
message: "could not identify anycompatiblemultirange type"
slug: could-not-identify-anycompatiblemultirange-type
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATATYPE_MISMATCH
    code: "42804"
call_sites:
  - "postgres/src/backend/parser/parse_coerce.c:2856"
reproduced: false
---

# `could not identify anycompatiblemultirange type`

## What it means

The parser tried to resolve the `anycompatiblemultirange` polymorphic pseudo-type to a concrete multirange type and could not. It must resolve to a multirange whose element type is compatible with the other `anycompatible` arguments.

## When it happens

It fires while type-checking a call using `anycompatiblemultirange`, when the arguments do not point at a single multirange type — for example a multirange whose subtype is incompatible with the rest of the call.

## How to fix

Pass a multirange whose subtype is compatible with the other arguments, or cast the inputs to a common type so the multirange is determined. Explicit casts on the multirange and its partner arguments usually resolve it.

## Example

*Illustrative* — an anycompatiblemultirange call that cannot resolve.

```text
ERROR:  could not identify anycompatiblemultirange type
```

## Related

- [could not identify anycompatiblerange type](./could-not-identify-anycompatiblerange-type.md)
- [could not identify anycompatiblearray type](./could-not-identify-anycompatiblearray-type.md)

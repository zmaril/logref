---
message: "could not identify anycompatiblerange type"
slug: could-not-identify-anycompatiblerange-type
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATATYPE_MISMATCH
    code: "42804"
call_sites:
  - "postgres/src/backend/parser/parse_coerce.c:2845"
reproduced: false
---

# `could not identify anycompatiblerange type`

## What it means

The parser tried to resolve the `anycompatiblerange` polymorphic pseudo-type to a concrete range type and could not. It must resolve to a range whose element type is compatible with the other `anycompatible` arguments.

## When it happens

It fires while type-checking a call using `anycompatiblerange`, when the arguments do not determine a single range type — for example a range whose subtype is incompatible with the rest of the call.

## How to fix

Pass a range whose subtype is compatible with the other arguments, or cast the inputs to a common type so the range is determined. Explicit casts on the range and its partner arguments usually resolve the ambiguity.

## Example

*Illustrative* — an anycompatiblerange call that cannot resolve.

```text
ERROR:  could not identify anycompatiblerange type
```

## Related

- [could not identify anycompatiblemultirange type](./could-not-identify-anycompatiblemultirange-type.md)
- [could not identify anycompatible type](./could-not-identify-anycompatible-type.md)

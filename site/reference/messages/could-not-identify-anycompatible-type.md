---
message: "could not identify anycompatible type"
slug: could-not-identify-anycompatible-type
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATATYPE_MISMATCH
    code: "42804"
call_sites:
  - "postgres/src/backend/parser/parse_coerce.c:2823"
reproduced: false
---

# `could not identify anycompatible type`

## What it means

The parser tried to resolve the `anycompatible` polymorphic pseudo-type to one concrete type that fits all the relevant arguments and could not find a common type. `anycompatible` requires the inputs to share a single compatible type.

## When it happens

It fires while type-checking a call to a function or operator declared with `anycompatible` parameters, when the supplied arguments have no common type Postgres can settle on.

## How to fix

Make the arguments share a compatible type — cast them to a common type explicitly, or supply values whose types Postgres already knows how to unify. The parser reports this when, for example, unrelated types are passed to a single `anycompatible` position.

## Example

*Illustrative* — arguments with no common compatible type.

```text
ERROR:  could not identify anycompatible type
```

## Related

- [could not identify anycompatiblearray type](./could-not-identify-anycompatiblearray-type.md)
- [could not identify anycompatiblerange type](./could-not-identify-anycompatiblerange-type.md)

---
message: "argument declared %s is not a range type but type %s"
slug: argument-declared-is-not-a-range-type-but-type
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATATYPE_MISMATCH
    code: "42804"
call_sites:
  - "postgres/src/backend/parser/parse_coerce.c:2315"
  - "postgres/src/backend/parser/parse_coerce.c:2465"
  - "postgres/src/backend/utils/fmgr/funcapi.c:614"
reproduced: false
---

# `argument declared %s is not a range type but type %s`

## What it means

A polymorphic function declared an argument or result as `anyrange` (or `anymultirange`), but the actual type supplied at that position is not a range type. The placeholders are the declared pseudotype and the actual type. Polymorphic range arguments require a genuine range type so the element type can be inferred.

## When it happens

Calling a function with `anyrange` parameters and passing a non-range value, or defining a function whose polymorphic argument resolution produces a non-range where a range is required.

## How to fix

Pass a real range type (for example `int4range`, `tsrange`, or a custom range) at the `anyrange` position, or cast the value to the appropriate range type. When defining such a function, make sure the type rules can resolve a range from the arguments provided.

## Example

*Illustrative* — a non-range passed where anyrange is required.

```text
ERROR:  argument declared anyrange is not a range type but type integer
```

## Related

- [argument declared is not an array but type](./argument-declared-is-not-an-array-but-type.md)
- [type is not a range type](./type-is-not-a-range-type.md)

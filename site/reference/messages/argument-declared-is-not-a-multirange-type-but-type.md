---
message: "argument declared %s is not a multirange type but type %s"
slug: argument-declared-is-not-a-multirange-type-but-type
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATATYPE_MISMATCH
    code: "42804"
call_sites:
  - "postgres/src/backend/parser/parse_coerce.c:2349"
  - "postgres/src/backend/parser/parse_coerce.c:2429"
  - "postgres/src/backend/parser/parse_coerce.c:2562"
  - "postgres/src/backend/utils/fmgr/funcapi.c:632"
  - "postgres/src/backend/utils/fmgr/funcapi.c:697"
reproduced: false
---

# `argument declared %s is not a multirange type but type %s`

## What it means

A function declared with the polymorphic pseudo-type `anymultirange` was called with an argument whose actual type is not a multirange. The placeholders are the declared polymorphic type and the concrete type that was passed. Polymorphic resolution requires a real multirange to bind `anymultirange`.

## When it happens

Passing a non-multirange value (a scalar, an array, a plain range) to a function or operator whose signature uses `anymultirange`, or mixing `anymultirange` with an incompatible `anyrange`/`anyelement` in the same call.

## How to fix

Pass a genuine multirange value (for example `int4multirange(...)` or a `*multirange` column). If you meant a plain range, use the range-typed function instead. Check that all polymorphic arguments in the call resolve to a consistent type family.

## Example

*Illustrative* — a scalar where a multirange is required.

```sql
SELECT lower(5);  -- lower() over anymultirange needs a multirange
```

## Related

- [argument declared is not consistent with argument declared](./argument-declared-is-not-consistent-with-argument-declared.md)
- [could not determine polymorphic type](./could-not-determine-polymorphic-type.md)

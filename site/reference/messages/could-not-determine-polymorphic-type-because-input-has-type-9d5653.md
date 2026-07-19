---
message: "could not determine polymorphic type %s because input has type %s"
slug: could-not-determine-polymorphic-type-because-input-has-type-9d5653
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATATYPE_MISMATCH
    code: "42804"
call_sites:
  - "postgres/src/backend/parser/parse_coerce.c:2610"
  - "postgres/src/backend/parser/parse_coerce.c:2631"
  - "postgres/src/backend/parser/parse_coerce.c:2681"
  - "postgres/src/backend/parser/parse_coerce.c:2686"
  - "postgres/src/backend/parser/parse_coerce.c:2750"
  - "postgres/src/backend/parser/parse_coerce.c:2762"
  - "postgres/src/backend/parser/parse_coerce.c:2798"
  - "postgres/src/backend/parser/parse_coerce.c:2810"
reproduced: false
---

# `could not determine polymorphic type %s because input has type %s`

## What it means

A function with polymorphic parameters (`anyelement`, `anyarray`, `anycompatible`, and so on) could not resolve a concrete type because an argument arrived as the `unknown` type — an untyped literal or NULL with no type context. The placeholders are the polymorphic pseudo-type and the input's type (`unknown`).

## When it happens

Calling a polymorphic function with a bare string literal or untyped `NULL` — for example `SELECT array_position(ARRAY[1,2], 'x')` where `'x'` is untyped, or passing `NULL` without a cast to a polymorphic parameter.

## How to fix

Add an explicit cast to the untyped argument so its type is known: `'x'::int`, `NULL::text`. Any `unknown`-typed input to a polymorphic parameter must be annotated. This is the standard, expected fix.

## Example

*Illustrative* — an untyped literal in a polymorphic call.

```sql
SELECT array_append(ARRAY[1,2], NULL);
```

Produces:

```text
ERROR:  could not determine polymorphic type anyelement because input has type unknown
```

## Related

- [could not determine input data type](./could-not-determine-input-data-type.md)
- [arguments declared are not all alike](./arguments-declared-are-not-all-alike.md)

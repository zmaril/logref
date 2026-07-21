---
message: "arguments declared \"%s\" are not all alike"
slug: arguments-declared-are-not-all-alike
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATATYPE_MISMATCH
    code: "42804"
call_sites:
  - "postgres/src/backend/parser/parse_coerce.c:2187"
  - "postgres/src/backend/parser/parse_coerce.c:2207"
  - "postgres/src/backend/parser/parse_coerce.c:2227"
  - "postgres/src/backend/parser/parse_coerce.c:2248"
  - "postgres/src/backend/parser/parse_coerce.c:2303"
  - "postgres/src/backend/parser/parse_coerce.c:2337"
reproduced: false
---

# `arguments declared "%s" are not all alike`

## What it means

A polymorphic function that requires several of its arguments to share a type (declared `anyelement`/`anyarray`/`anyrange` consistently) was given arguments of incompatible types. The placeholder is the polymorphic category. The types cannot be unified into one concrete type.

## When it happens

Calling functions like `array_position`, `coalesce`-style polymorphic helpers, or `greatest`/`least` with arguments that do not share a common type — for example mixing `int` and `text` where the function needs one element type across all of them.

## How to fix

Make the relevant arguments the same type, casting as needed so they unify (for example cast all to `text` or all to `numeric`). Polymorphic parameters marked with the same `anyelement`/`anyarray` must resolve to a single concrete type. Check which arguments disagree and align them.

## Example

*Illustrative* — mixed element types in a polymorphic call.

```sql
SELECT array_position(ARRAY[1,2,3], 'x');
```

Produces:

```text
ERROR:  arguments declared "anyelement" are not all alike
DETAIL:  integer versus text
```

## Related

- [could not determine polymorphic type because input has type](./could-not-determine-polymorphic-type-because-input-has-type-9d5653.md)
- [cannot cast type %s to %s](./cannot-cast-type-to.md)

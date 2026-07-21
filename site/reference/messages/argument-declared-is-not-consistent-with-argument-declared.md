---
message: "argument declared %s is not consistent with argument declared %s"
slug: argument-declared-is-not-consistent-with-argument-declared
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATATYPE_MISMATCH
    code: "42804"
call_sites:
  - "postgres/src/backend/parser/parse_coerce.c:2412"
  - "postgres/src/backend/parser/parse_coerce.c:2443"
  - "postgres/src/backend/parser/parse_coerce.c:2482"
  - "postgres/src/backend/parser/parse_coerce.c:2548"
reproduced: false
---

# `argument declared %s is not consistent with argument declared %s`

## What it means

Two polymorphic arguments to a function resolved to types that are not consistent with each other. The placeholders are the two declared polymorphic types. Postgres requires related polymorphic parameters (like `anyelement` and `anyarray`) to agree on a common underlying type.

## When it happens

Calling a polymorphic function where the actual arguments force incompatible bindings — for example an `anyarray` of one element type together with an `anyelement` of a different, non-coercible type.

## How to fix

Pass arguments whose types line up under the polymorphic rules: the element type of an `anyarray` must match the `anyelement`, the range subtype must match, and so on. Cast one argument so both resolve to a single consistent type.

## Example

*Illustrative* — inconsistent polymorphic arguments.

```sql
SELECT array_append(ARRAY[1,2], 'x');
```

## Related

- [argument declared is not a multirange type but type](./argument-declared-is-not-a-multirange-type-but-type.md)
- [could not determine polymorphic type](./could-not-determine-polymorphic-type.md)

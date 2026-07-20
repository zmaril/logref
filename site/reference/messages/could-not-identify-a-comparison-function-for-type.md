---
message: "could not identify a comparison function for type %s"
slug: could-not-identify-a-comparison-function-for-type
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
  - symbol: ERRCODE_UNDEFINED_FUNCTION
    code: "42883"
call_sites:
  - "postgres/src/backend/access/gin/gininsert.c:1322"
  - "postgres/src/backend/access/gin/ginutil.c:153"
  - "postgres/src/backend/executor/execExpr.c:2241"
  - "postgres/src/backend/utils/adt/array_userfuncs.c:1970"
  - "postgres/src/backend/utils/adt/arrayfuncs.c:4038"
  - "postgres/src/backend/utils/adt/arrayfuncs.c:6750"
  - "postgres/src/backend/utils/adt/rowtypes.c:972"
  - "postgres/src/backend/utils/sort/tuplesortvariants.c:645"
reproduced: false
---

# `could not identify a comparison function for type %s`

## What it means

An operation that needs ordering (sorting, b-tree indexing, `ORDER BY`, `<`/`>` comparisons, min/max) could not find a comparison function for the type. The placeholder is the type. The type has no b-tree operator class, so Postgres cannot order its values.

## When it happens

`ORDER BY`, `DISTINCT` with sorting, b-tree index creation, or min/max aggregates on a column whose type lacks a default b-tree operator class — some custom or opaque types, or comparisons between records/arrays of such types.

## How to fix

Provide a b-tree operator class (with a comparison support function) for the type, or avoid operations that require ordering on it. For custom types, define the comparison operators and a b-tree opclass. If the type genuinely has no natural order, restructure the query to not sort or index by it (for example use hashing/equality only).

## Example

*Illustrative* — ordering a type with no comparison function.

```sql
SELECT * FROM t ORDER BY uncomparable_col;
```

Produces:

```text
ERROR:  could not identify a comparison function for type uncomparable_type
```

## Related

- [could not identify an equality operator for type %s](./could-not-identify-an-equality-operator-for-type.md)
- [could not identify a hash function for type %s](./could-not-identify-a-hash-function-for-type.md)

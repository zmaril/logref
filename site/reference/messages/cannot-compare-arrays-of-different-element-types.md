---
message: "cannot compare arrays of different element types"
slug: cannot-compare-arrays-of-different-element-types
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATATYPE_MISMATCH
    code: "42804"
call_sites:
  - "postgres/src/backend/utils/adt/arrayfuncs.c:3852"
  - "postgres/src/backend/utils/adt/arrayfuncs.c:4021"
  - "postgres/src/backend/utils/adt/arrayfuncs.c:4412"
reproduced: false
---

# `cannot compare arrays of different element types`

## What it means

An array comparison put two arrays with different element types on either side. Array comparison operators compare element by element and require both arrays to share an element type; mixing, say, `integer[]` and `text[]` has no defined ordering.

## When it happens

Comparing or ordering arrays whose element types differ — often from a `UNION`, `CASE`, or comparison that brought together arrays built from different types, or an implicit cast that did not unify them.

## How to fix

Make both arrays the same element type: cast one side (`arr::integer[]`) so the element types match, or fix the expression that produced the mismatched arrays. Ensure operations that combine arrays (unions, case branches) yield a single consistent array type.

## Example

*Illustrative* — comparing arrays of different element types.

```sql
SELECT ARRAY[1,2] = ARRAY['a','b'];  -- different element types
```

## Related

- [cannot work with arrays containing NULLs](./cannot-work-with-arrays-containing-nulls.md)
- [collation mismatch between implicit collations and](./collation-mismatch-between-implicit-collations-and.md)

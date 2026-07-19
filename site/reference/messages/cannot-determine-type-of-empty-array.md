---
message: "cannot determine type of empty array"
slug: cannot-determine-type-of-empty-array
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INDETERMINATE_DATATYPE
    code: "42P18"
call_sites:
  - "postgres/src/backend/parser/parse_expr.c:2124"
reproduced: false
---

# `cannot determine type of empty array`

## What it means

An empty array literal was written without enough context for Postgres to infer its element type. An empty array carries no elements to derive a type from, so the type must be supplied explicitly.

## When it happens

It occurs when using an expression like `ARRAY[]` or `'{}'` in a position where no surrounding type tells Postgres what the array should contain.

## How to fix

Add an explicit cast on the empty array, such as `ARRAY[]::int[]` or `'{}'::text[]`. That gives the array a definite element type.

## Example

*Illustrative* — an untyped empty array.

```sql
SELECT ARRAY[];
```

## Related

- [cannot determine element type of anyarray argument](./cannot-determine-element-type-of-anyarray-argument.md)
- [cannot assign null value to an element of a fixed-length array](./cannot-assign-null-value-to-an-element-of-a-fixed-length-array.md)

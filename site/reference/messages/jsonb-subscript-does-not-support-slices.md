---
message: "jsonb subscript does not support slices"
slug: jsonb-subscript-does-not-support-slices
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATATYPE_MISMATCH
    code: "42804"
call_sites:
  - "postgres/src/backend/utils/adt/jsonbsubs.c:66"
  - "postgres/src/backend/utils/adt/jsonbsubs.c:147"
reproduced: false
---

# `jsonb subscript does not support slices`

## What it means

A jsonb value was subscripted with a slice (`a:b`) syntax. Jsonb subscripting supports single-element access and assignment, but not array-style slices.

## When it happens

It arises when writing `jsonb_col[1:3]` or a similar slice against a jsonb value, mirroring array slice syntax that jsonb does not implement.

## How to fix

Use single-key or single-index subscripts (`jsonb_col['key']` or `jsonb_col[0]`), or extract ranges with jsonb path functions such as `jsonb_path_query`. To operate on a contiguous portion, build it with the jsonb functions rather than slice syntax.

## Example

*Illustrative* — slicing a jsonb value.

```sql
SELECT j['arr'][1:2] FROM t;  -- jsonb subscript does not support slices
```

## Related

- [not a jsonb array](./not-a-jsonb-array.md)
- [jsonb scalar type mismatch](./jsonb-scalar-type-mismatch.md)

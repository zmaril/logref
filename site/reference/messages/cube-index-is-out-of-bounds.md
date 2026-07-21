---
message: "cube index %d is out of bounds"
slug: cube-index-is-out-of-bounds
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_ARRAY_ELEMENT_ERROR
    code: "2202E"
call_sites:
  - "postgres/contrib/cube/cube.c:1618"
reproduced: false
---

# `cube index %d is out of bounds`

## What it means

A `cube` extension function was given a dimension index that does not exist for the cube. The placeholder is the index. Functions like `cube_ll_coord` and `cube_ur_coord` take a one-based dimension number.

## When it happens

It happens when you ask for a coordinate whose index is less than one or greater than the cube's number of dimensions.

## How to fix

Pass an index within the cube's dimension count. Use `cube_dim()` to find how many dimensions a cube has, then request a coordinate within that range.

## Example

*Illustrative* — a coordinate index past the last dimension.

```sql
SELECT cube_ll_coord('(1,2)'::cube, 5);
-- ERROR:  cube index 5 is out of bounds
```

## Related

- [cube dimension is too large](./cube-dimension-is-too-large.md)
- [data type is not an array type](./data-type-is-not-an-array-type.md)

---
message: "cube dimension is too large"
slug: cube-dimension-is-too-large
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_PROGRAM_LIMIT_EXCEEDED
    code: "54000"
call_sites:
  - "postgres/contrib/cube/cube.c:367"
reproduced: false
---

# `cube dimension is too large`

## What it means

The `cube` extension was asked to build a cube with more dimensions than it allows. Cubes represent points and boxes in multi-dimensional space, and there is a fixed cap on the number of dimensions.

## When it happens

It happens when a `cube` value or operation would exceed the dimension limit — for example constructing a cube from an array with too many elements.

## How to fix

Reduce the number of dimensions to within the `cube` type's maximum. If your data genuinely needs more dimensions than `cube` supports, the extension is not the right tool for it. Check the input array's length before building the cube.

## Example

*Illustrative* — a cube with too many dimensions.

```sql
SELECT cube(array_fill(1.0, ARRAY[200]));
-- ERROR:  cube dimension is too large
```

## Related

- [cube index is out of bounds](./cube-index-is-out-of-bounds.md)
- [CUBE is limited to 12 elements](./cube-is-limited-to-12-elements.md)

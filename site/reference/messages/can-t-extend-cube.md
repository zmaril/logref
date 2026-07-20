---
message: "can't extend cube"
slug: can-t-extend-cube
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_PROGRAM_LIMIT_EXCEEDED
    code: "54000"
call_sites:
  - "postgres/contrib/cube/cube.c:162"
  - "postgres/contrib/cube/cube.c:1838"
  - "postgres/contrib/cube/cube.c:1886"
reproduced: false
---

# `can't extend cube`

## What it means

The `cube` extension could not extend a cube value with another dimension because doing so would exceed the maximum number of dimensions a cube may have (100). The `cube` type has a fixed dimensional cap tied to its storage format.

## When it happens

Building or combining cubes so the result would have more than 100 dimensions — for example repeatedly extending a cube, or constructing one from an over-long coordinate list.

## How to fix

Keep cube dimensionality at or below the limit. Reduce the number of coordinates, or model the data so no single cube needs more than 100 dimensions. The cap is fixed and cannot be raised without rebuilding the extension differently.

## Example

*Illustrative* — extending a cube past the dimension limit.

```text
ERROR:  can't extend cube
```

## Related

- [cannot work with arrays containing NULLs](./cannot-work-with-arrays-containing-nulls.md)
- [number of pairs exceeds the maximum allowed](./number-of-pairs-exceeds-the-maximum-allowed.md)

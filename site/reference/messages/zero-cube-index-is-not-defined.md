---
message: "zero cube index is not defined"
slug: zero-cube-index-is-not-defined
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_ARRAY_ELEMENT_ERROR
    code: "2202E"
call_sites:
  - "postgres/contrib/cube/cube.c:1426"
  - "postgres/contrib/cube/cube.c:1662"
reproduced: false
---

# `zero cube index is not defined`

## What it means

A `cube` extension operation referenced coordinate index zero, but cube coordinates are numbered from one, so index zero has no meaning.

## When it happens

It arises from `cube` functions that take a coordinate index (such as `cube_ll_coord`/`cube_ur_coord` and the subscript accessors) when the index argument is zero.

## How to fix

Use a one-based coordinate index. The first coordinate of a cube is index 1; adjust any zero-based index from your application before passing it.

## Example

*Illustrative* — a zero cube coordinate index.

```text
ERROR:  zero cube index is not defined
```

## Related

- [weight out of range](./weight-out-of-range.md)
- [value %s out of bounds for option "%s"](./value-out-of-bounds-for-option.md)

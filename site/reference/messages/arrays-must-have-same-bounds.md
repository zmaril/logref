---
message: "arrays must have same bounds"
slug: arrays-must-have-same-bounds
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_ARRAY_SUBSCRIPT_ERROR
    code: "2202E"
call_sites:
  - "postgres/contrib/hstore/hstore_io.c:668"
reproduced: false
---

# `arrays must have same bounds`

## What it means

An element-wise array operation was given two arrays whose dimensions or subscript bounds differ, so their elements cannot be paired up.

## When it happens

It occurs in operations that combine arrays position-by-position (for example certain array arithmetic or comparison paths) when the operands do not have identical bounds.

## How to fix

Make the arrays the same shape — same number of dimensions and the same lower/upper bounds — before combining them. Reshape or re-slice one array to match the other, or handle differing lengths explicitly by unnesting and joining.

## Example

*Illustrative* — combining arrays of different bounds.

```text
ERROR:  arrays must have same bounds
```

## Related

- [array slice subscript must provide both boundaries](./array-slice-subscript-must-provide-both-boundaries.md)
- [array size exceeds the maximum allowed](./array-size-exceeds-the-maximum-allowed-16139a.md)

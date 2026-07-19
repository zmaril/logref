---
message: "cannot merge incompatible arrays"
slug: cannot-merge-incompatible-arrays
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATATYPE_MISMATCH
    code: "42804"
call_sites:
  - "postgres/src/backend/executor/execExprInterp.c:3487"
reproduced: false
---

# `cannot merge incompatible arrays`

## What it means

An array operation tried to combine arrays whose element types or dimensions do not match. Concatenating or merging arrays requires compatible element types and matching dimensionality, and these did not agree.

## When it happens

It occurs when array concatenation or a merge combines arrays of different element types, or arrays whose dimensions do not line up.

## How to fix

Make the arrays compatible before merging: cast elements to a common type and ensure the dimensions match. Build the arrays with the same element type from the start where you plan to combine them.

## Example

*Illustrative* — merging arrays of different shapes.

```text
ERROR:  cannot merge incompatible arrays
```

## Related

- [cannot merge addresses from different families](./cannot-merge-addresses-from-different-families.md)
- [cannot extract elements from a scalar](./cannot-extract-elements-from-a-scalar.md)

---
message: "source array too small"
slug: source-array-too-small
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_ARRAY_SUBSCRIPT_ERROR
    code: "2202E"
call_sites:
  - "postgres/src/backend/utils/adt/arrayfuncs.c:2908"
  - "postgres/src/backend/utils/adt/arrayfuncs.c:3020"
reproduced: false
---

# `source array too small`

## What it means

Internal error. An array-processing routine was given a source array with fewer elements than the operation requires, so it cannot read the expected number of values.

## When it happens

It fires from internal array-handling code (for example when unpacking a fixed-shape array) when the input's length falls short of what the caller assumed. It usually reflects a mismatch between a catalog array and code expectations, not ordinary SQL.

## How to fix

This is an internal consistency guard. If reproducible, capture the operation and any custom type/array involved and report it; there is no user setting to adjust.

## Example

*Illustrative* — an array shorter than expected.

```text
ERROR:  source array too small
```

## Related

- [source key array length must match number of key attributes](./source-key-array-length-must-match-number-of-key-attributes.md)
- [searching for elements in multidimensional arrays is not supported](./searching-for-elements-in-multidimensional-arrays-is-not-supported.md)

---
message: "invalid number of dimensions: %d"
slug: invalid-number-of-dimensions
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_BINARY_REPRESENTATION
    code: "22P03"
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/utils/adt/arrayfuncs.c:1303"
  - "postgres/src/backend/utils/adt/arrayfuncs.c:3516"
  - "postgres/src/backend/utils/adt/arrayfuncs.c:6141"
reproduced: false
---

# `invalid number of dimensions: %d`

## What it means

An array value was given a dimension count that Postgres does not accept. Arrays may have between zero and a fixed maximum number of dimensions, and the supplied count was negative, too large, or otherwise out of range.

## When it happens

Constructing an array from a text or binary representation whose dimension header is malformed, or building an array through a function call that computes a dimension count outside the allowed range. Malformed binary input from a client protocol is a common source.

## How to fix

Check the array literal or the client-side encoder that produced the value. Array literals should have a consistent, well-formed shape, and any binary array data must carry a dimension count within the supported range. If the value comes from an application, verify the driver's array-encoding path.

## Example

*Illustrative* — a malformed array dimension count.

```text
ERROR:  invalid number of dimensions: -1
```

## Related

- [mismatched array dimensions](./mismatched-array-dimensions.md)
- [number of array dimensions exceeds the maximum allowed](./number-of-array-dimensions-exceeds-the-maximum-allowed-c53afe.md)

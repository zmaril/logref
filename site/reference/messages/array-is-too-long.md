---
message: "array is too long"
slug: array-is-too-long
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_PROGRAM_LIMIT_EXCEEDED
    code: "54000"
call_sites:
  - "postgres/contrib/cube/cube.c:226"
  - "postgres/contrib/cube/cube.c:266"
reproduced: false
---

# `array is too long`

## What it means

A cube or array operation produced a value with more elements than the type allows. The `cube` type and related array handling cap the number of elements, and the result exceeded that cap.

## When it happens

Building a `cube` value or performing an array operation whose result would have more dimensions or elements than the type permits — for example combining cubes into one with too many dimensions.

## How to fix

Reduce the number of elements or dimensions so the result fits within the type's limit. For `cube`, keep the dimensionality within the supported maximum; restructure the data if you are approaching it.

## Example

*Illustrative* — a cube with too many dimensions.

```sql
SELECT cube(array_fill(1, ARRAY[1000]));  -- array is too long
```

## Related

- [number of array dimensions exceeds the maximum allowed](./number-of-array-dimensions-exceeds-the-maximum-allowed-c53afe.md)
- [array size exceeds the maximum allowed](./array-size-exceeds-the-maximum-allowed-075b47.md)

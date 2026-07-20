---
message: "%s: expected %d-element float8 array"
slug: expected-element-float8-array
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/float.c:2985"
reproduced: false
---

# `%s: expected %d-element float8 array`

## What it means

An internal guard. A routine that reads a stored array of double-precision numbers expected an array with a specific element count and found a different shape. The placeholders are the count and the number of elements expected.

## When it happens

It fires when internal code deserializes a fixed-length float8 array from the catalog or from computed statistics and the array does not have the expected number of elements. In normal operation these arrays are written with the right shape.

## How to fix

This is an internal invariant rather than a user error. It points at inconsistent or corrupted stored data. If it followed a crash or storage problem, investigate the underlying catalog or statistics; regenerating the affected statistics (for example with `ANALYZE`) may clear it. Report it if the data was produced normally.

## Example

*Illustrative* — the message as logged.

```
ERROR:  myfunc: expected 3-element float8 array
```

## Related

- [expected 1-D text array](./expected-1-d-text-array.md)
- [expression not found in statistics object](./expression-not-found-in-statistics-object.md)

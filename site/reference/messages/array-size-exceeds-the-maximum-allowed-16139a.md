---
message: "array size exceeds the maximum allowed (%d)"
slug: array-size-exceeds-the-maximum-allowed-16139a
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_PROGRAM_LIMIT_EXCEEDED
    code: "54000"
call_sites:
  - "postgres/src/backend/executor/execExprInterp.c:3541"
reproduced: false
---

# `array size exceeds the maximum allowed (%d)`

## What it means

An array grew beyond the maximum size Postgres allows, so the operation building or extending it cannot complete.

## When it happens

It occurs when constructing, concatenating, or assigning into an array whose total element count or storage size would exceed the internal array limit.

## How to fix

Reduce the size of the array — split the data into multiple rows or arrays, or reconsider whether a very large array is the right representation. Extremely large arrays are usually better modeled as rows in a table.

## Example

*Illustrative* — an array exceeding the size limit.

```text
ERROR:  array size exceeds the maximum allowed (134217727)
```

## Related

- [argument exceeds the maximum length of bytes](./argument-exceeds-the-maximum-length-of-bytes.md)
- [arrays must have same bounds](./arrays-must-have-same-bounds.md)

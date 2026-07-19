---
message: "string is too long for tsvector (%d bytes, max %d bytes)"
slug: string-is-too-long-for-tsvector-bytes-max-bytes
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_PROGRAM_LIMIT_EXCEEDED
    code: "54000"
call_sites:
  - "postgres/src/backend/tsearch/to_tsany.c:192"
  - "postgres/src/backend/utils/adt/tsvector_op.c:1098"
reproduced: false
---

# `string is too long for tsvector (%d bytes, max %d bytes)`

## What it means

A `tsvector` value would exceed the maximum byte size the type allows. The placeholders are the actual and maximum sizes. A single `tsvector` has a hard upper bound on its total serialized size.

## When it happens

It arises when building a `tsvector` from a very large document, or concatenating vectors, so the combined lexemes and positions surpass the limit.

## How to fix

Reduce the document size before conversion — index sections separately, strip positions with `strip()` when not needed, or remove very common lexemes. For large texts, split into multiple rows/vectors rather than one oversize value.

## Example

*Illustrative* — a tsvector past its maximum size.

```text
ERROR:  string is too long for tsvector (1100000 bytes, max 1048575 bytes)
```

## Related

- [positions array too long](./positions-array-too-long.md)
- [row is too big: size %zu, maximum size %zu](./row-is-too-big-size-maximum-size.md)

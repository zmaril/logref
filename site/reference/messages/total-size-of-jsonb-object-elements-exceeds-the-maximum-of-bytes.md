---
message: "total size of jsonb object elements exceeds the maximum of %d bytes"
slug: total-size-of-jsonb-object-elements-exceeds-the-maximum-of-bytes
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_PROGRAM_LIMIT_EXCEEDED
    code: "54000"
call_sites:
  - "postgres/src/backend/utils/adt/jsonb_util.c:1877"
  - "postgres/src/backend/utils/adt/jsonb_util.c:1912"
  - "postgres/src/backend/utils/adt/jsonb_util.c:1932"
reproduced: false
---

# `total size of jsonb object elements exceeds the maximum of %d bytes`

## What it means

A jsonb object grew past the internal size limit for the combined length of its element data. jsonb stores element offsets in a fixed-width form, which caps the total size of an object's contents, and this object exceeded that cap.

## When it happens

Building or storing a single jsonb object whose keys and values together are very large — for example aggregating a huge number of entries into one object, or constructing an object with extremely long values.

## How to fix

Reduce the size of the individual jsonb object. Split the data across multiple objects or rows, store large values outside jsonb, or restructure so no single object approaches the limit. The cap is on one object's contents, so distributing the data resolves it.

## Example

*Illustrative* — a jsonb object exceeding the size cap.

```text
ERROR:  total size of jsonb object elements exceeds the maximum of 268435455 bytes
```

## Related

- [total size of jsonb array elements exceeds the maximum of bytes](./total-size-of-jsonb-array-elements-exceeds-the-maximum-of-bytes.md)
- [string is too long for tsvector](./string-is-too-long-for-tsvector-bytes-max-bytes.md)

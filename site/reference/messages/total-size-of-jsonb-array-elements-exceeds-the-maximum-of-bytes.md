---
message: "total size of jsonb array elements exceeds the maximum of %d bytes"
slug: total-size-of-jsonb-array-elements-exceeds-the-maximum-of-bytes
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_PROGRAM_LIMIT_EXCEEDED
    code: "54000"
call_sites:
  - "postgres/src/backend/utils/adt/jsonb_util.c:1796"
  - "postgres/src/backend/utils/adt/jsonb_util.c:1816"
reproduced: false
---

# `total size of jsonb array elements exceeds the maximum of %d bytes`

## What it means

A `jsonb` array being built would exceed the maximum total byte size the format allows for its elements. The placeholder is the maximum. `jsonb` has a hard cap on the combined size of a container's contents.

## When it happens

It arises when constructing or aggregating a very large `jsonb` array (for example `jsonb_agg` over many large rows) whose elements together surpass the size limit.

## How to fix

Reduce the size of the constructed value: aggregate fewer or smaller elements, split the result into multiple `jsonb` values, or store large payloads outside a single `jsonb` array. The per-value size limit is fixed.

## Example

*Illustrative* — a jsonb array over the size limit.

```text
ERROR:  total size of jsonb array elements exceeds the maximum of 268435455 bytes
```

## Related

- [row is too big: size %zu, maximum size %zu](./row-is-too-big-size-maximum-size.md)
- [result is out of range](./result-is-out-of-range.md)

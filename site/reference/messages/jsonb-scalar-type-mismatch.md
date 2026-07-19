---
message: "jsonb scalar type mismatch"
slug: jsonb-scalar-type-mismatch
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/jsonb_util.c:1549"
  - "postgres/src/backend/utils/adt/jsonb_util.c:1589"
reproduced: false
---

# `jsonb scalar type mismatch`

## What it means

Internal error. Jsonb comparison or extraction code found a scalar whose stored type tag does not match the type it was asked to read. It is a consistency guard over the binary jsonb scalar format.

## When it happens

It fires while processing a jsonb value whose scalar header is inconsistent. Ordinary jsonb operations do not surface it; it points to a corrupted jsonb datum or an internal bug.

## How to fix

This is a can't-happen guard. If a specific stored value triggers it, that value may be corrupt — locate and rewrite or delete it, and check storage for I/O errors. Report a reproducible case if corruption is not otherwise evident.

## Example

*Illustrative* — a jsonb scalar with a mismatched type tag.

```text
ERROR:  jsonb scalar type mismatch
```

## Related

- [invalid jsonb container type](./invalid-jsonb-container-type.md)
- [not a jsonb array](./not-a-jsonb-array.md)

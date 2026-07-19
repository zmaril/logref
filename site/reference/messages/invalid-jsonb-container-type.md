---
message: "invalid jsonb container type"
slug: invalid-jsonb-container-type
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/jsonb_util.c:748"
  - "postgres/src/backend/utils/adt/jsonb_util.c:1428"
reproduced: false
---

# `invalid jsonb container type`

## What it means

Internal error. Jsonb code inspected a binary jsonb container whose header does not identify it as an object, array, or scalar. It is a consistency guard over the on-disk jsonb format.

## When it happens

It fires while traversing a jsonb value whose container tag is unrecognized. Ordinary jsonb operations do not surface it; it points to a corrupted jsonb datum or an internal bug.

## How to fix

This is a can't-happen guard. If a specific stored value triggers it, that value is likely corrupt — locate and rewrite or delete it. Check storage for I/O errors, and report a reproducible case if it appears without corruption elsewhere.

## Example

*Illustrative* — an unrecognized jsonb container tag.

```text
ERROR:  invalid jsonb container type
```

## Related

- [invalid jsonb container type 0x](./invalid-jsonb-container-type-0x.md)
- [not a jsonb array](./not-a-jsonb-array.md)

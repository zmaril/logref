---
message: "invalid Datum pointer"
slug: invalid-datum-pointer
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATA_EXCEPTION
    code: "22000"
call_sites:
  - "postgres/src/backend/utils/adt/datum.c:88"
  - "postgres/src/backend/utils/adt/datum.c:100"
reproduced: false
---

# `invalid Datum pointer`

## What it means

Internal error. A routine that dereferences a pass-by-reference datum was handed a pointer it considers invalid. It is a defensive check in datum-handling code.

## When it happens

It fires from datum copying/inspection paths when a `Datum` that should point at a value does not. Ordinary queries do not surface it; it points to an internal bug or memory corruption, often around custom C functions.

## How to fix

This is a can't-happen guard. If a custom C function or extension is in play, review its datum construction and lifetime handling. For built-in paths, capture the statement and report a reproducible case; investigate host memory if other corruption appears.

## Example

*Illustrative* — a bad pass-by-reference datum.

```text
ERROR:  invalid Datum pointer
```

## Related

- [invalid memory alloc request size](./invalid-memory-alloc-request-size.md)
- [invalid jsonb container type](./invalid-jsonb-container-type.md)

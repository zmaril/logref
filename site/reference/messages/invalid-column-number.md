---
message: "invalid column number %d"
slug: invalid-column-number
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/common/heaptuple.c:1213"
  - "postgres/src/backend/catalog/index.c:349"
reproduced: false
---

# `invalid column number %d`

## What it means

Internal error. A routine received a column number that is out of range for the tuple or descriptor it applies to. The placeholder is the offending number.

## When it happens

It fires from tuple-descriptor and SPI-adjacent code when a one-based column index is zero, negative, or greater than the number of columns. Ordinary queries do not surface it; it points to an internal inconsistency.

## How to fix

This is a can't-happen guard. If a custom C function or extension is involved, check its column-index arithmetic. For built-in paths, capture the statement and report a reproducible case.

## Example

*Illustrative* — a column index past the tuple width.

```text
ERROR:  invalid column number 7
```

## Related

- [invalid attnum for relation](./invalid-attnum-for-relation.md)
- [invalid line number](./invalid-line-number.md)

---
message: "invalid attnum: %d"
slug: invalid-attnum
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/common/heaptuple.c:491"
  - "postgres/src/backend/access/common/heaptuple.c:669"
reproduced: false
---

# `invalid attnum: %d`

## What it means

Internal error. Code was given an attribute number (column position) that is outside the valid range for the relation it applies to. The placeholder is the bad attribute number.

## When it happens

It fires from low-level tuple and catalog routines when an attribute number is zero, negative in a context that forbids system columns, or beyond the relation's column count. Ordinary queries do not surface it; it points to an internal inconsistency.

## How to fix

This is a can't-happen guard. Retry if it coincides with concurrent DDL that changed a table's columns. If it recurs, capture the statement and the table's current definition and report a reproducible case.

## Example

*Illustrative* — an out-of-range attribute number.

```text
ERROR:  invalid attnum: 0
```

## Related

- [invalid attnum for relation](./invalid-attnum-for-relation.md)
- [invalid varattno](./invalid-varattno.md)

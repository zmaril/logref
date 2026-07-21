---
message: "column number out of range"
slug: column-number-out-of-range
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/catalog/aclchk.c:1586"
reproduced: false
---

# `column number out of range`

## What it means

An internal privilege- or catalog-handling routine was given a column number that falls outside the valid range for the relation. This is a low-level consistency check rather than a user-facing message.

## When it happens

It fires from access-control code (for example when applying column-level privileges) if the column index it processes is out of bounds.

## How to fix

This normally reflects an internal inconsistency, not an everyday SQL mistake. If it appears repeatedly, note the operation that triggered it and inspect the affected object's ACL and column set for corruption; report it if it recurs on an unmodified catalog.

## Example

*Illustrative* — an out-of-range column index in privilege handling.

```text
ERROR:  column number out of range
```

## Related

- [column number of relation does not exist](./column-number-of-relation-does-not-exist.md)
- [column privileges are only valid for relations](./column-privileges-are-only-valid-for-relations.md)

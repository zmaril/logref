---
message: "proargnames is not a 1-D text array of length %d or it contains nulls"
slug: proargnames-is-not-a-1-d-text-array-of-length-or-it-contains-nulls
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/fmgr/funcapi.c:1660"
  - "postgres/src/backend/utils/fmgr/funcapi.c:1804"
reproduced: false
---

# `proargnames is not a 1-D text array of length %d or it contains nulls`

## What it means

Internal error. A function's `pg_proc.proargnames` catalog column was expected to be a one-dimensional text array of a specific length with no null elements, and it did not meet that shape. The placeholder is the expected length.

## When it happens

It fires when catalog-reading code processes a function's argument names and finds the array malformed — wrong dimensionality, wrong length, or containing nulls. Normal `CREATE FUNCTION` builds this array correctly; a bad value implies catalog corruption or a hand-modified catalog.

## How to fix

This is an internal catalog-shape guard. Investigate the function's `pg_proc` row for corruption, recreate the function cleanly, and check for catalog damage more broadly if it recurs.

## Example

*Illustrative* — a function with a malformed argument-name array.

```text
ERROR:  proargnames is not a 1-D text array of length 3 or it contains nulls
```

## Related

- [parameter name "%s" used more than once](./parameter-name-used-more-than-once.md)
- [too many function arguments](./too-many-function-arguments.md)

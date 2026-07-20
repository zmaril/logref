---
message: "column \"%s\" is not of type oid"
slug: column-is-not-of-type-oid
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/catalog/catalog.c:718"
reproduced: false
---

# `column "%s" is not of type oid`

## What it means

An internal catalog helper expected a column of type `oid` but found a different type. This is a consistency check on a system catalog or on the arguments passed to a catalog-manipulating routine.

## When it happens

It fires from catalog code (for example when validating a mapping between catalog columns) when the column it reads is not the expected `oid` type.

## How to fix

This indicates a mismatch in catalog usage rather than an everyday SQL mistake. Verify you are querying the correct catalog and column; if it appears against an unmodified catalog, treat it as a possible catalog inconsistency and investigate for corruption.

## Example

*Illustrative* — an unexpected column type in catalog processing.

```text
ERROR:  column "x" is not of type oid
```

## Related

- [column number out of range](./column-number-out-of-range.md)
- [column number of relation does not exist](./column-number-of-relation-does-not-exist.md)

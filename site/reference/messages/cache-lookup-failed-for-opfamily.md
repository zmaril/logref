---
message: "cache lookup failed for opfamily %u"
slug: cache-lookup-failed-for-opfamily
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/catalog/namespace.c:2352"
  - "postgres/src/backend/catalog/objectaddress.c:4444"
  - "postgres/src/backend/catalog/objectaddress.c:6485"
reproduced: false
---

# `cache lookup failed for opfamily %u`

## What it means

Internal error. An operator family's catalog row (`pg_opfamily`) could not be found by OID. The placeholder is the opfamily OID. Operator families group operator classes for the planner and index code; one expected to exist was missing.

## When it happens

A concurrent `DROP OPERATOR FAMILY` on a family still referenced, or catalog inconsistency. Not caused by ordinary data.

## How to fix

If it coincides with concurrent operator-family DDL, retry. If it recurs for one OID, inspect `pg_opfamily`; a dangling reference indicates corruption. Report reproducible cases.

## Example

*Illustrative* — an opfamily dropped while referenced.

```text
ERROR:  cache lookup failed for opfamily 1976
```

## Related

- [cache lookup failed for ordering operator for type](./cache-lookup-failed-for-ordering-operator-for-type.md)
- [could not find hash function for hash operator](./could-not-find-hash-function-for-hash-operator.md)

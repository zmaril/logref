---
message: "cache lookup failed for operator family %u"
slug: cache-lookup-failed-for-operator-family
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/cache/lsyscache.c:1544"
  - "postgres/src/backend/utils/cache/lsyscache.c:1564"
reproduced: false
---

# `cache lookup failed for operator family %u`

## What it means

Internal error. An operator family's catalog row (`pg_opfamily`) could not be found by OID. The placeholder is the OID. Planner or index code held an operator-family OID it expected to still resolve.

## When it happens

A concurrent `DROP OPERATOR FAMILY` while an index or operator class still references it, or catalog inconsistency. Ordinary queries do not raise it.

## How to fix

If operator-class DDL was running concurrently, retry. If it recurs, inspect `pg_opfamily` for the OID; a missing row points to corruption. Report the reproduction.

## Example

*Illustrative* — an operator family dropped while still referenced.

```text
ERROR:  cache lookup failed for operator family 1976
```

## Related

- [could not find opfamilies for equality operator](./could-not-find-opfamilies-for-equality-operator.md)
- [cache lookup failed for range type](./cache-lookup-failed-for-range-type.md)

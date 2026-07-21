---
message: "cache lookup failed for conversion %u"
slug: cache-lookup-failed-for-conversion
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/catalog/namespace.c:2605"
  - "postgres/src/backend/catalog/objectaddress.c:3194"
  - "postgres/src/backend/catalog/objectaddress.c:5326"
reproduced: false
---

# `cache lookup failed for conversion %u`

## What it means

Internal error. A conversion's catalog row (`pg_conversion`) could not be found by OID. The placeholder is the conversion OID. Conversions define encoding-to-encoding transforms; code expected this one to exist because something still referenced it.

## When it happens

A concurrent `DROP CONVERSION` on a conversion still in use, or catalog inconsistency. Not caused by ordinary data.

## How to fix

If it coincides with concurrent DDL on conversions, retry. If it recurs for one OID, inspect `pg_conversion`; a missing row for a referenced OID indicates corruption. Report reproducible cases.

## Example

*Illustrative* — a conversion dropped while still referenced.

```text
ERROR:  cache lookup failed for conversion 16490
```

## Related

- [cache lookup failed for opfamily](./cache-lookup-failed-for-opfamily.md)
- [cache lookup failed for user mapping](./cache-lookup-failed-for-user-mapping.md)

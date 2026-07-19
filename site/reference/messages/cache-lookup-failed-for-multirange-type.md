---
message: "cache lookup failed for multirange type %u"
slug: cache-lookup-failed-for-multirange-type
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/cache/typcache.c:1072"
reproduced: false
---

# `cache lookup failed for multirange type %u`

## What it means

An internal lookup for a multirange type by OID found no matching row. The placeholder is the OID. The multirange type referenced during planning or execution is missing from the type catalog.

## When it happens

It usually reflects a race with a concurrent `DROP TYPE` on the underlying range type, or catalog inconsistency in `pg_range`/`pg_type`.

## How to fix

Retry if the type was being dropped concurrently. If it persists, investigate catalog consistency around the range and multirange types and consider a restore from backup.

## Example

*Illustrative* — a missing multirange type.

```text
ERROR:  cache lookup failed for multirange type 16410
```

## Related

- [cache lookup failed for oid](./cache-lookup-failed-for-oid.md)
- [cannot alter multirange type](./cannot-alter-multirange-type.md)

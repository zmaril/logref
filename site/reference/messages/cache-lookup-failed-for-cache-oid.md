---
message: "cache lookup failed for cache %d oid %u"
slug: cache-lookup-failed-for-cache-oid
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/catalog/objectaddress.c:2695"
reproduced: false
---

# `cache lookup failed for cache %d oid %u`

## What it means

An internal lookup in a named system cache found no row for the requested OID. The placeholders are the cache identifier and the object OID. It generally means the object disappeared or the catalog is inconsistent.

## When it happens

It usually reflects a race with a concurrent `DROP` that removed the object mid-operation, or, more rarely, catalog corruption.

## How to fix

If it coincided with concurrent DDL, retry the operation once the drop has settled. If it recurs with no concurrent change, suspect catalog corruption: check storage and hardware, and consider `amcheck` and a restore from backup.

## Example

*Illustrative* — an internal cache miss.

```text
ERROR:  cache lookup failed for cache 12 oid 16384
```

## Related

- [cache lookup failed for oid](./cache-lookup-failed-for-oid.md)
- [cache lookup failed for object](./cache-lookup-failed-for-object.md)

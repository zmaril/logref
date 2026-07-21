---
message: "cache lookup failed for property %u"
slug: cache-lookup-failed-for-property
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/cache/lsyscache.c:4106"
reproduced: false
---

# `cache lookup failed for property %u`

## What it means

An internal lookup for a property object by OID found no matching catalog row. The placeholder is the OID. The property referenced during an operation is missing.

## When it happens

It usually reflects a race with a concurrent drop of the owning object, or a catalog inconsistency.

## How to fix

Retry if concurrent DDL was involved. If it recurs with no concurrent change, investigate catalog consistency and consider a restore from backup.

## Example

*Illustrative* — a missing property entry.

```text
ERROR:  cache lookup failed for property 16450
```

## Related

- [cache lookup failed for property graph property](./cache-lookup-failed-for-property-graph-property.md)
- [cache lookup failed for oid](./cache-lookup-failed-for-oid.md)

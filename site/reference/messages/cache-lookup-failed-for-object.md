---
message: "cache lookup failed for object %u/%u"
slug: cache-lookup-failed-for-object
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/commands/event_trigger.c:2166"
reproduced: false
---

# `cache lookup failed for object %u/%u`

## What it means

A generic object-address lookup found no catalog row for the class and OID it was given. The placeholders identify the object. The addressed object no longer exists or the catalog is inconsistent.

## When it happens

It usually reflects a race with a concurrent `DROP` of the referenced object, or a catalog inconsistency reached while resolving an object address.

## How to fix

Retry the operation if concurrent DDL removed the object. If it recurs without concurrent change, investigate catalog consistency, run `amcheck` where relevant, and consider a restore from backup.

## Example

*Illustrative* — a missing object address.

```text
ERROR:  cache lookup failed for object 1259/16384
```

## Related

- [cache lookup failed for oid](./cache-lookup-failed-for-oid.md)
- [cache lookup failed for cache oid](./cache-lookup-failed-for-cache-oid.md)

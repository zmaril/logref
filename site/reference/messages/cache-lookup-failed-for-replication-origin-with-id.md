---
message: "cache lookup failed for replication origin with ID %d"
slug: cache-lookup-failed-for-replication-origin-with-id
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/replication/logical/origin.c:479"
reproduced: false
---

# `cache lookup failed for replication origin with ID %d`

## What it means

An internal lookup for a replication origin by its numeric ID found no matching row. The placeholder is the origin ID. The replication origin referenced during logical replication or origin tracking is missing.

## When it happens

It usually reflects a race with a concurrent drop of the origin, or a catalog inconsistency in `pg_replication_origin`.

## How to fix

Retry if the origin was being dropped. If it persists, examine the replication-origin catalog and the subscription or apply worker that referenced the origin.

## Example

*Illustrative* — a missing replication origin.

```text
ERROR:  cache lookup failed for replication origin with ID 3
```

## Related

- [cache lookup failed for subscription oid](./cache-lookup-failed-for-subscription-oid.md)
- [cache lookup failed for oid](./cache-lookup-failed-for-oid.md)

---
message: "cache lookup failed for subscription oid %u"
slug: cache-lookup-failed-for-subscription-oid
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/replication/logical/tablesync.c:1696"
reproduced: false
---

# `cache lookup failed for subscription oid %u`

## What it means

An internal lookup for a logical-replication subscription by OID found no `pg_subscription` row. The placeholder is the OID. The subscription referenced by an apply worker or catalog operation is missing.

## When it happens

It usually reflects a race with a concurrent `DROP SUBSCRIPTION`, or a catalog inconsistency in `pg_subscription`.

## How to fix

Retry if the subscription was dropped concurrently. If it persists, investigate the subscription catalog and the state of the apply worker and its slot.

## Example

*Illustrative* — a missing subscription.

```text
ERROR:  cache lookup failed for subscription oid 16480
```

## Related

- [cache lookup failed for replication origin with id](./cache-lookup-failed-for-replication-origin-with-id.md)
- [cannot alter replication slot](./cannot-alter-replication-slot.md)

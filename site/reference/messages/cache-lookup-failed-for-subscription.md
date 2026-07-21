---
message: "cache lookup failed for subscription %u"
slug: cache-lookup-failed-for-subscription
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/catalog/pg_subscription.c:108"
  - "postgres/src/backend/catalog/pg_subscription.c:273"
  - "postgres/src/backend/catalog/pg_subscription.c:715"
  - "postgres/src/backend/utils/cache/lsyscache.c:4067"
reproduced: false
---

# `cache lookup failed for subscription %u`

## What it means

Internal error. Code looked up a subscription catalog row (`pg_subscription`) by OID and found nothing. The placeholder is the OID. A missing row for an OID in active use points to a concurrent drop or catalog inconsistency.

## When it happens

Typically a concurrent `DROP SUBSCRIPTION` while its apply worker or a command references it; otherwise catalog inconsistency. Not caused by ordinary data.

## How to fix

If concurrent DDL was in flight, retry. If it recurs, inspect the subscription and its workers; a persistently missing row indicates corruption warranting investigation.

## Example

*Illustrative* — a concurrently dropped subscription.

```text
ERROR:  cache lookup failed for subscription 16395
```

## Related

- [cache lookup failed for publication](./cache-lookup-failed-for-publication.md)
- [subscription does not exist](./subscription-does-not-exist.md)

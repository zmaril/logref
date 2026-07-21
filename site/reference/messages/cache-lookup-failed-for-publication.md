---
message: "cache lookup failed for publication %u"
slug: cache-lookup-failed-for-publication
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/catalog/pg_publication.c:1280"
  - "postgres/src/backend/commands/publicationcmds.c:1781"
  - "postgres/src/backend/utils/cache/lsyscache.c:4017"
  - "postgres/src/backend/utils/cache/relcache.c:5900"
reproduced: false
---

# `cache lookup failed for publication %u`

## What it means

Internal error. Code looked up a publication catalog row (`pg_publication`) by OID and found nothing. The placeholder is the OID. A missing row for an OID in active use points to a concurrent drop or catalog inconsistency.

## When it happens

Typically a concurrent `DROP PUBLICATION` while a subscription or decoding session references it; otherwise catalog inconsistency. Not caused by ordinary data.

## How to fix

If concurrent DDL was in flight, retry. If it recurs, inspect the publication and its subscribers; a persistently missing row indicates corruption warranting investigation.

## Example

*Illustrative* — a concurrently dropped publication.

```text
ERROR:  cache lookup failed for publication 16390
```

## Related

- [cache lookup failed for subscription](./cache-lookup-failed-for-subscription.md)
- [cache lookup failed for %s %u](./cache-lookup-failed-for.md)

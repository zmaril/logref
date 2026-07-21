---
message: "cache lookup failed for text search parser %u"
slug: cache-lookup-failed-for-text-search-parser
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/catalog/namespace.c:2873"
  - "postgres/src/backend/catalog/objectaddress.c:3613"
  - "postgres/src/backend/catalog/objectaddress.c:5721"
  - "postgres/src/backend/utils/cache/ts_cache.c:156"
reproduced: false
---

# `cache lookup failed for text search parser %u`

## What it means

Internal error. Code looked up a text-search parser catalog row (`pg_ts_parser`) by OID and found nothing. The placeholder is the OID. A missing row for an OID in active use points to a concurrent drop or catalog inconsistency.

## When it happens

A concurrent drop of the parser, or inconsistency among the text-search configuration objects. Not caused by ordinary data.

## How to fix

If concurrent DDL was in flight, retry. Otherwise inspect the text-search configuration objects for consistency; a genuinely missing row is corruption.

## Example

*Illustrative* — a missing text-search parser.

```text
ERROR:  cache lookup failed for text search parser 16412
```

## Related

- [cache lookup failed for text search template](./cache-lookup-failed-for-text-search-template.md)
- [cache lookup failed for %s %u](./cache-lookup-failed-for.md)

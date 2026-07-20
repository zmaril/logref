---
message: "cache lookup failed for text search template %u"
slug: cache-lookup-failed-for-text-search-template
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/catalog/namespace.c:3164"
  - "postgres/src/backend/catalog/objectaddress.c:3674"
  - "postgres/src/backend/catalog/objectaddress.c:5775"
  - "postgres/src/backend/commands/tsearchcmds.c:360"
  - "postgres/src/backend/utils/cache/ts_cache.c:272"
reproduced: false
---

# `cache lookup failed for text search template %u`

## What it means

Internal error. Code looked up a text-search template catalog row (`pg_ts_template`) by OID and found nothing. The placeholder is the OID. Text-search templates are usually stable, so a missing row means a concurrent drop or catalog inconsistency.

## When it happens

A concurrent drop of the template, or catalog inconsistency in the text-search configuration objects. Not caused by ordinary data.

## How to fix

If concurrent DDL was in flight, retry. Otherwise inspect the text-search configuration objects (`pg_ts_template`, `pg_ts_dict`) for consistency; a genuinely missing row is corruption.

## Example

*Illustrative* — a missing text-search template.

```text
ERROR:  cache lookup failed for text search template 16410
```

## Related

- [cache lookup failed for text search parser](./cache-lookup-failed-for-text-search-parser.md)
- [cache lookup failed for %s %u](./cache-lookup-failed-for.md)

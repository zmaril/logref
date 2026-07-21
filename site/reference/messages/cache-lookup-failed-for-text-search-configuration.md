---
message: "cache lookup failed for text search configuration %u"
slug: cache-lookup-failed-for-text-search-configuration
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/catalog/namespace.c:3309"
  - "postgres/src/backend/catalog/objectaddress.c:3705"
  - "postgres/src/backend/catalog/objectaddress.c:5802"
  - "postgres/src/backend/commands/tsearchcmds.c:799"
  - "postgres/src/backend/commands/tsearchcmds.c:965"
  - "postgres/src/backend/utils/cache/ts_cache.c:428"
  - "postgres/src/backend/utils/cache/ts_cache.c:651"
reproduced: false
---

# `cache lookup failed for text search configuration %u`

## What it means

Internal error. A text-search configuration's catalog row (`pg_ts_config`) could not be found by OID. The placeholder is the OID. Something referenced the text-search configuration but the row is gone.

## When it happens

A concurrent `DROP TEXT SEARCH CONFIGURATION` on one still referenced (by a column default, an index, or `default_text_search_config`), catalog inconsistency, or an extension holding the OID across a transaction. Not caused by ordinary data.

## How to fix

If it coincides with concurrent DDL on text-search objects, retry. If it recurs, inspect `pg_ts_config` for the OID; a missing row is corruption. Check that `default_text_search_config` and any index/column references point at existing configurations. Report reproducible cases.

## Example

*Illustrative* — a text-search config dropped while referenced.

```text
ERROR:  cache lookup failed for text search configuration 16910
```

## Related

- [cache lookup failed for text search dictionary](./cache-lookup-failed-for-text-search-dictionary.md)
- [cache lookup failed for type](./cache-lookup-failed-for-type.md)

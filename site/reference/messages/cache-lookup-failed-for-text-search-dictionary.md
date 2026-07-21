---
message: "cache lookup failed for text search dictionary %u"
slug: cache-lookup-failed-for-text-search-dictionary
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/catalog/namespace.c:3018"
  - "postgres/src/backend/catalog/objectaddress.c:3643"
  - "postgres/src/backend/catalog/objectaddress.c:5748"
  - "postgres/src/backend/commands/tsearchcmds.c:515"
  - "postgres/src/backend/commands/tsearchcmds.c:1122"
  - "postgres/src/backend/utils/cache/ts_cache.c:256"
reproduced: false
---

# `cache lookup failed for text search dictionary %u`

## What it means

Internal error. A text-search dictionary's catalog row (`pg_ts_dict`) could not be found by OID. The placeholder is the OID. Something referenced the dictionary but the row is gone.

## When it happens

A concurrent `DROP TEXT SEARCH DICTIONARY` on one still used by a configuration, catalog inconsistency, or an extension holding the OID across a transaction. Not caused by ordinary data.

## How to fix

If it coincides with concurrent DDL on text-search objects, retry. If it recurs, inspect `pg_ts_dict` for the OID; a missing row is corruption. Check that no text-search configuration references a dropped dictionary. Report reproducible cases.

## Example

*Illustrative* — a dictionary dropped while a config used it.

```text
ERROR:  cache lookup failed for text search dictionary 16920
```

## Related

- [cache lookup failed for text search configuration](./cache-lookup-failed-for-text-search-configuration.md)
- [cache lookup failed for type](./cache-lookup-failed-for-type.md)

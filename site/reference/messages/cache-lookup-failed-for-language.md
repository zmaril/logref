---
message: "cache lookup failed for language %u"
slug: cache-lookup-failed-for-language
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/catalog/objectaddress.c:5373"
  - "postgres/src/backend/utils/cache/lsyscache.c:1429"
  - "postgres/src/backend/utils/fmgr/fmgr.c:430"
  - "postgres/src/backend/utils/fmgr/fmgr.c:2136"
reproduced: false
---

# `cache lookup failed for language %u`

## What it means

Internal error. Code looked up a procedural-language catalog row (`pg_language`) by OID and found nothing. The placeholder is the OID. A missing row for an OID in active use points to a concurrent drop or catalog inconsistency.

## When it happens

Typically a concurrent `DROP LANGUAGE` (or dropping the extension providing it) while a function in that language is used; otherwise catalog inconsistency. Not caused by ordinary data.

## How to fix

If concurrent DDL was in flight, retry. If it recurs, inspect the language and dependent functions; a persistently missing row indicates corruption warranting investigation.

## Example

*Illustrative* — a concurrently dropped language.

```text
ERROR:  cache lookup failed for language 16388
```

## Related

- [cache lookup failed for %s %u](./cache-lookup-failed-for.md)
- [cache lookup failed for role](./cache-lookup-failed-for-role.md)

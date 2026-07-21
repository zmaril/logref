---
message: "cache lookup failed for collation %u"
slug: cache-lookup-failed-for-collation
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/catalog/namespace.c:2503"
  - "postgres/src/backend/catalog/objectaddress.c:3125"
  - "postgres/src/backend/catalog/objectaddress.c:5252"
  - "postgres/src/backend/commands/collationcmds.c:147"
  - "postgres/src/backend/commands/collationcmds.c:457"
  - "postgres/src/backend/commands/explain.c:2869"
  - "postgres/src/backend/parser/parse_utilcmd.c:2194"
  - "postgres/src/backend/utils/adt/pg_locale.c:1059"
  - "postgres/src/backend/utils/adt/pg_locale.c:1211"
  - "postgres/src/backend/utils/adt/pg_locale_builtin.c:297"
  - "postgres/src/backend/utils/adt/pg_locale_icu.c:375"
  - "postgres/src/backend/utils/adt/pg_locale_libc.c:804"
  - "postgres/src/backend/utils/adt/ri_triggers.c:2262"
  - "postgres/src/backend/utils/adt/ruleutils.c:14340"
  - "postgres/src/backend/utils/cache/lsyscache.c:1288"
reproduced: false
---

# `cache lookup failed for collation %u`

## What it means

Internal error. A collation's catalog row (`pg_collation`) could not be found by OID. The placeholder is the collation OID. Code expected the collation to exist because a column, index, or expression still references it.

## When it happens

A concurrent `DROP COLLATION` on a collation still in use, catalog inconsistency, or an extension holding a collation OID across a transaction. Not caused by ordinary data.

## How to fix

If it coincides with concurrent DDL on collations, retry. If it recurs, inspect `pg_collation` for the OID; a missing row indicates corruption. Report reproducible cases with the steps.

## Example

*Illustrative* — a collation dropped while still referenced.

```text
ERROR:  cache lookup failed for collation 16650
```

## Related

- [cache lookup failed for type](./cache-lookup-failed-for-type.md)
- [collations are not supported by type %s](./collations-are-not-supported-by-type.md)

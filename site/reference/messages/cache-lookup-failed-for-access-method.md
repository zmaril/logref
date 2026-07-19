---
message: "cache lookup failed for access method %u"
slug: cache-lookup-failed-for-access-method
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/index/amapi.c:81"
  - "postgres/src/backend/catalog/objectaddress.c:3288"
  - "postgres/src/backend/catalog/objectaddress.c:3321"
  - "postgres/src/backend/catalog/objectaddress.c:4451"
  - "postgres/src/backend/catalog/objectaddress.c:5433"
  - "postgres/src/backend/catalog/objectaddress.c:5464"
  - "postgres/src/backend/catalog/objectaddress.c:6492"
  - "postgres/src/backend/commands/opclasscmds.c:121"
  - "postgres/src/backend/commands/opclasscmds.c:202"
  - "postgres/src/backend/parser/parse_utilcmd.c:1732"
  - "postgres/src/backend/utils/adt/ruleutils.c:1354"
  - "postgres/src/backend/utils/cache/relcache.c:1477"
  - "postgres/src/backend/utils/cache/relcache.c:1855"
reproduced: false
---

# `cache lookup failed for access method %u`

## What it means

Internal error. An access method's catalog row (`pg_am`) could not be found by OID. The placeholder is the access-method OID. Something referenced the access method (an index method or table method) but the row is gone.

## When it happens

A concurrent drop of a custom access method still referenced by an index or table, catalog inconsistency, or an extension holding an AM OID across a transaction. Not caused by ordinary data.

## How to fix

If it coincides with concurrent DDL, retry. If it recurs, inspect `pg_am` for the OID; a missing row is corruption. Custom access-method extensions are the usual source when dropped while in use — verify their upgrade/teardown scripts. Report reproducible cases.

## Example

*Illustrative* — an access method dropped while indexes used it.

```text
ERROR:  cache lookup failed for access method 16700
```

## Related

- [cache lookup failed for opclass](./cache-lookup-failed-for-opclass.md)
- [cache lookup failed for operator class](./cache-lookup-failed-for-operator-class.md)

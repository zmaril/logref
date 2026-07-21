---
message: "cache lookup failed for opclass %u"
slug: cache-lookup-failed-for-opclass
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/catalog/index.c:434"
  - "postgres/src/backend/catalog/namespace.c:2250"
  - "postgres/src/backend/catalog/objectaddress.c:3278"
  - "postgres/src/backend/catalog/objectaddress.c:5423"
  - "postgres/src/backend/catalog/pg_constraint.c:1688"
  - "postgres/src/backend/commands/indexcmds.c:2497"
  - "postgres/src/backend/commands/matview.c:762"
  - "postgres/src/backend/commands/tablecmds.c:10490"
  - "postgres/src/backend/parser/parse_utilcmd.c:2221"
  - "postgres/src/backend/utils/adt/ruleutils.c:13664"
  - "postgres/src/backend/utils/cache/lsyscache.c:1450"
  - "postgres/src/backend/utils/cache/lsyscache.c:1472"
  - "postgres/src/backend/utils/cache/lsyscache.c:1520"
  - "postgres/src/backend/utils/cache/partcache.c:202"
reproduced: false
---

# `cache lookup failed for opclass %u`

## What it means

Internal error. An operator class's catalog row (`pg_opclass`) could not be found by OID. The placeholder is the opclass OID. Something referenced the opclass but the row is gone.

## When it happens

A concurrent drop of an operator class still referenced by an index, catalog inconsistency, or an extension holding an opclass OID across a transaction. Not caused by ordinary data.

## How to fix

If it coincides with concurrent DDL, retry. If it recurs, inspect `pg_opclass`; a missing row is corruption. Extensions that define opclasses are a likely source when their upgrade scripts drop objects still in use — verify them. Report reproducible cases.

## Example

*Illustrative* — an opclass dropped while an index used it.

```text
ERROR:  cache lookup failed for opclass 16680
```

## Related

- [cache lookup failed for operator class](./cache-lookup-failed-for-operator-class.md)
- [missing operator in opfamily](./missing-operator-in-opfamily.md)

---
message: "cache lookup failed for operator %u"
slug: cache-lookup-failed-for-operator
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/contrib/postgres_fdw/deparse.c:3322"
  - "postgres/contrib/postgres_fdw/deparse.c:3497"
  - "postgres/contrib/postgres_fdw/deparse.c:3854"
  - "postgres/src/backend/access/index/amvalidate.c:214"
  - "postgres/src/backend/catalog/namespace.c:2145"
  - "postgres/src/backend/catalog/pg_operator.c:489"
  - "postgres/src/backend/commands/explain.c:2884"
  - "postgres/src/backend/commands/opclasscmds.c:1165"
  - "postgres/src/backend/commands/operatorcmds.c:456"
  - "postgres/src/backend/commands/operatorcmds.c:473"
  - "postgres/src/backend/commands/operatorcmds.c:527"
  - "postgres/src/backend/optimizer/plan/subselect.c:861"
  - "postgres/src/backend/parser/parse_utilcmd.c:1832"
  - "postgres/src/backend/rewrite/rewriteGraphTable.c:1223"
  - "postgres/src/backend/utils/adt/ruleutils.c:14162"
  - "postgres/src/backend/utils/adt/ruleutils.c:14238"
  - "postgres/src/backend/utils/cache/lsyscache.c:1665"
reproduced: false
---

# `cache lookup failed for operator %u`

## What it means

Internal error. An operator's catalog row (`pg_operator`) could not be found by OID. The placeholder is the operator OID. Something referenced the operator but the row is gone.

## When it happens

A concurrent drop of an operator still referenced (for example by an index opclass, a cached plan, or an extension), or catalog inconsistency. Not caused by ordinary data.

## How to fix

If it coincides with concurrent DDL, retry. If it recurs for one OID, inspect `pg_operator`; a missing row is corruption. Extensions that define operators and drop them on upgrade are a likely source — verify their upgrade scripts. Report reproducible cases.

## Example

*Illustrative* — an operator dropped while referenced by an opclass.

```text
ERROR:  cache lookup failed for operator 16632
```

## Related

- [cache lookup failed for operator class](./cache-lookup-failed-for-operator-class.md)
- [could not identify an equality operator for type %s](./could-not-identify-an-equality-operator-for-type.md)

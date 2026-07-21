---
message: "cache lookup failed for statistics object %u"
slug: cache-lookup-failed-for-statistics-object
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/catalog/namespace.c:2728"
  - "postgres/src/backend/catalog/objectaddress.c:5694"
  - "postgres/src/backend/commands/statscmds.c:834"
  - "postgres/src/backend/commands/statscmds.c:979"
  - "postgres/src/backend/optimizer/util/plancat.c:1759"
  - "postgres/src/backend/parser/parse_utilcmd.c:2073"
  - "postgres/src/backend/statistics/dependencies.c:699"
  - "postgres/src/backend/statistics/extended_stats.c:2460"
  - "postgres/src/backend/statistics/mcv.c:565"
  - "postgres/src/backend/statistics/mvdistinct.c:155"
  - "postgres/src/backend/utils/adt/ruleutils.c:2040"
reproduced: false
---

# `cache lookup failed for statistics object %u`

## What it means

Internal error. An extended-statistics object's catalog row (`pg_statistic_ext`) could not be found by OID. The placeholder is the OID. Something referenced the statistics object but the row is gone.

## When it happens

A concurrent `DROP STATISTICS` on an object still referenced, catalog inconsistency, or dropping the underlying table concurrently. Not caused by ordinary data.

## How to fix

If it coincides with concurrent DDL on statistics or their tables, retry. If it recurs, inspect `pg_statistic_ext` for the OID; a missing row is corruption. Report reproducible cases.

## Example

*Illustrative* — a statistics object dropped mid-operation.

```text
ERROR:  cache lookup failed for statistics object 16740
```

## Related

- [cache lookup failed for relation](./cache-lookup-failed-for-relation-0e5774.md)
- [cache lookup failed for type](./cache-lookup-failed-for-type.md)

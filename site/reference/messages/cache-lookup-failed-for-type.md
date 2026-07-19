---
message: "cache lookup failed for type %u"
slug: cache-lookup-failed-for-type
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/common/tupdesc.c:963"
  - "postgres/src/backend/access/spgist/spgutils.c:175"
  - "postgres/src/backend/catalog/index.c:378"
  - "postgres/src/backend/catalog/index.c:467"
  - "postgres/src/backend/catalog/namespace.c:1068"
  - "postgres/src/backend/catalog/pg_type.c:775"
  - "postgres/src/backend/commands/analyze.c:1137"
  - "postgres/src/backend/commands/tablecmds.c:4262"
  - "postgres/src/backend/commands/typecmds.c:668"
  - "postgres/src/backend/commands/typecmds.c:1320"
  - "postgres/src/backend/commands/typecmds.c:2671"
  - "postgres/src/backend/commands/typecmds.c:2793"
  - "postgres/src/backend/commands/typecmds.c:2884"
  - "postgres/src/backend/commands/typecmds.c:2988"
  - "postgres/src/backend/commands/typecmds.c:3093"
  - "postgres/src/backend/commands/typecmds.c:3801"
  - "postgres/src/backend/commands/typecmds.c:3997"
  - "postgres/src/backend/commands/typecmds.c:4043"
  - "postgres/src/backend/commands/typecmds.c:4224"
  - "postgres/src/backend/commands/typecmds.c:4694"
  - "postgres/src/backend/parser/parse_agg.c:2206"
  - "postgres/src/backend/parser/parse_type.c:209"
  - "postgres/src/backend/parser/parse_type.c:584"
  - "postgres/src/backend/parser/parse_type.c:676"
  - "postgres/src/backend/parser/parse_type.c:699"
  - "postgres/src/backend/replication/logical/proto.c:740"
  - "postgres/src/backend/replication/logical/proto.c:828"
  - "postgres/src/backend/statistics/extended_stats.c:593"
  - "postgres/src/backend/statistics/extended_stats.c:681"
  - "postgres/src/backend/statistics/mcv.c:2301"
  - "postgres/src/backend/utils/adt/domains.c:414"
  - "postgres/src/backend/utils/adt/format_type.c:137"
  - "postgres/src/backend/utils/adt/format_type.c:162"
  - "postgres/src/backend/utils/adt/jsonfuncs.c:3265"
  - "postgres/src/backend/utils/adt/ruleutils.c:14275"
  - "postgres/src/backend/utils/adt/ruleutils.c:14307"
  - "postgres/src/backend/utils/adt/varlena.c:4174"
  - "postgres/src/backend/utils/adt/varlena.c:4221"
  - "postgres/src/backend/utils/adt/varlena.c:4274"
  - "postgres/src/backend/utils/adt/xml.c:3876"
  - "postgres/src/backend/utils/cache/lsyscache.c:2572"
  - "postgres/src/backend/utils/cache/lsyscache.c:2593"
  - "postgres/src/backend/utils/cache/lsyscache.c:2687"
  - "postgres/src/backend/utils/cache/lsyscache.c:2774"
  - "postgres/src/backend/utils/cache/lsyscache.c:2866"
  - "postgres/src/backend/utils/cache/lsyscache.c:3033"
  - "postgres/src/backend/utils/cache/lsyscache.c:3197"
  - "postgres/src/backend/utils/cache/lsyscache.c:3230"
  - "postgres/src/backend/utils/cache/lsyscache.c:3263"
  - "postgres/src/backend/utils/cache/lsyscache.c:3296"
  - "postgres/src/backend/utils/cache/lsyscache.c:3597"
  - "postgres/src/backend/utils/cache/typcache.c:1136"
  - "postgres/src/pl/plpgsql/src/pl_comp.c:442"
  - "postgres/src/pl/plpgsql/src/pl_comp.c:1646"
  - "postgres/src/pl/plpgsql/src/pl_comp.c:1983"
  - "postgres/src/pl/plpython/plpy_procedure.c:225"
  - "postgres/src/pl/plpython/plpy_procedure.c:312"
  - "postgres/src/pl/tcl/pltcl.c:1622"
  - "postgres/src/pl/tcl/pltcl.c:1670"
reproduced: false
---

# `cache lookup failed for type %u`

## What it means

Internal error. A type's catalog row (`pg_type`) could not be found by OID. The placeholder is the type OID. Code that reaches this expected the type to exist because a value, column, or expression still refers to it.

## When it happens

A concurrent `DROP TYPE` that removed a type still referenced elsewhere, catalog inconsistency, or an extension holding a type OID across a transaction boundary where the type was later dropped. Not triggered by ordinary data.

## How to fix

If it coincides with concurrent DDL on types or domains, retry — the type was dropped. If it recurs for a fixed OID, check `pg_type` for that OID and look for dangling dependencies; treat a genuinely missing catalog row as corruption and restore from backup. Reproducible cases deserve a bug report with the steps.

## Example

*Illustrative* — a type dropped while still referenced.

```text
ERROR:  cache lookup failed for type 16487
```

## Related

- [cache lookup failed for relation](./cache-lookup-failed-for-relation-0e5774.md)
- [cache lookup failed for function](./cache-lookup-failed-for-function.md)

---
message: "cache lookup failed for function %u"
slug: cache-lookup-failed-for-function
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/contrib/postgres_fdw/deparse.c:4093"
  - "postgres/contrib/sepgsql/proc.c:270"
  - "postgres/src/backend/access/index/amvalidate.c:163"
  - "postgres/src/backend/catalog/namespace.c:1770"
  - "postgres/src/backend/catalog/pg_aggregate.c:252"
  - "postgres/src/backend/catalog/pg_aggregate.c:296"
  - "postgres/src/backend/catalog/pg_aggregate.c:341"
  - "postgres/src/backend/catalog/pg_proc.c:788"
  - "postgres/src/backend/catalog/pg_proc.c:834"
  - "postgres/src/backend/catalog/pg_proc.c:878"
  - "postgres/src/backend/commands/functioncmds.c:1327"
  - "postgres/src/backend/commands/functioncmds.c:1391"
  - "postgres/src/backend/commands/functioncmds.c:1620"
  - "postgres/src/backend/commands/functioncmds.c:1906"
  - "postgres/src/backend/commands/functioncmds.c:1932"
  - "postgres/src/backend/commands/functioncmds.c:2239"
  - "postgres/src/backend/commands/opclasscmds.c:1230"
  - "postgres/src/backend/executor/nodeAgg.c:3851"
  - "postgres/src/backend/executor/nodeWindowAgg.c:3039"
  - "postgres/src/backend/optimizer/util/clauses.c:2808"
  - "postgres/src/backend/optimizer/util/clauses.c:4536"
  - "postgres/src/backend/optimizer/util/clauses.c:5899"
  - "postgres/src/backend/optimizer/util/plancat.c:2366"
  - "postgres/src/backend/optimizer/util/plancat.c:2427"
  - "postgres/src/backend/parser/analyze.c:3630"
  - "postgres/src/backend/parser/parse_coerce.c:854"
  - "postgres/src/backend/parser/parse_func.c:1758"
  - "postgres/src/backend/utils/adt/ruleutils.c:14064"
  - "postgres/src/backend/utils/cache/funccache.c:501"
  - "postgres/src/backend/utils/cache/lsyscache.c:1976"
  - "postgres/src/backend/utils/cache/lsyscache.c:1995"
  - "postgres/src/backend/utils/cache/lsyscache.c:2018"
  - "postgres/src/backend/utils/cache/lsyscache.c:2044"
  - "postgres/src/backend/utils/cache/lsyscache.c:2063"
  - "postgres/src/backend/utils/cache/lsyscache.c:2082"
  - "postgres/src/backend/utils/cache/lsyscache.c:2101"
  - "postgres/src/backend/utils/cache/lsyscache.c:2120"
  - "postgres/src/backend/utils/cache/lsyscache.c:2139"
  - "postgres/src/backend/utils/cache/lsyscache.c:2158"
  - "postgres/src/backend/utils/fmgr/fmgr.c:185"
  - "postgres/src/backend/utils/fmgr/fmgr.c:292"
  - "postgres/src/backend/utils/fmgr/fmgr.c:665"
  - "postgres/src/backend/utils/fmgr/funcapi.c:448"
  - "postgres/src/backend/utils/fmgr/funcapi.c:1627"
  - "postgres/src/pl/plpgsql/src/pl_exec.c:2357"
  - "postgres/src/pl/plpgsql/src/pl_handler.c:462"
  - "postgres/src/pl/plpython/plpy_main.c:129"
  - "postgres/src/pl/tcl/pltcl.c:639"
  - "postgres/src/pl/tcl/pltcl.c:1437"
reproduced: false
---

# `cache lookup failed for function %u`

## What it means

Internal error. A function's catalog row (`pg_proc`) could not be found by OID. The placeholder is the function OID. Something referenced the function by OID but the row is gone.

## When it happens

A concurrent `DROP FUNCTION` removing a function still referenced (for example by a cached plan, a default expression, or an extension), or catalog inconsistency. Ordinary data never triggers it.

## How to fix

If it accompanies concurrent DDL, retry — the function was dropped. If it recurs for one OID, look it up in `pg_proc`; a genuinely missing row is catalog corruption and calls for restore from backup. Extensions that cache function OIDs across transactions are a common source — verify they invalidate correctly. Report reproducible cases.

## Example

*Illustrative* — a function dropped while a cached plan still referenced it.

```text
ERROR:  cache lookup failed for function 16502
```

## Related

- [cache lookup failed for type](./cache-lookup-failed-for-type.md)
- [function %s does not exist](./function-does-not-exist-3ae91e.md)

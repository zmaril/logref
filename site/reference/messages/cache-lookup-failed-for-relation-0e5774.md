---
message: "cache lookup failed for relation %u"
slug: cache-lookup-failed-for-relation-0e5774
passthrough: false
api: [elog, ereport]
level: [ERROR, FATAL]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_OBJECT
    code: "42704"
call_sites:
  - "postgres/contrib/sepgsql/dml.c:55"
  - "postgres/contrib/sepgsql/relation.c:672"
  - "postgres/src/backend/catalog/aclchk.c:1819"
  - "postgres/src/backend/catalog/aclchk.c:4438"
  - "postgres/src/backend/catalog/aclchk.c:4598"
  - "postgres/src/backend/catalog/heap.c:1606"
  - "postgres/src/backend/catalog/heap.c:1823"
  - "postgres/src/backend/catalog/heap.c:3179"
  - "postgres/src/backend/catalog/heap.c:4089"
  - "postgres/src/backend/catalog/index.c:1357"
  - "postgres/src/backend/catalog/namespace.c:941"
  - "postgres/src/backend/catalog/objectaddress.c:4365"
  - "postgres/src/backend/catalog/objectaddress.c:4972"
  - "postgres/src/backend/catalog/objectaddress.c:6528"
  - "postgres/src/backend/catalog/partition.c:190"
  - "postgres/src/backend/catalog/pg_constraint.c:953"
  - "postgres/src/backend/catalog/pg_inherits.c:363"
  - "postgres/src/backend/catalog/toasting.c:349"
  - "postgres/src/backend/catalog/toasting.c:369"
  - "postgres/src/backend/commands/indexcmds.c:4742"
  - "postgres/src/backend/commands/matview.c:94"
  - "postgres/src/backend/commands/repack.c:1192"
  - "postgres/src/backend/commands/repack.c:1265"
  - "postgres/src/backend/commands/repack.c:1491"
  - "postgres/src/backend/commands/repack.c:1563"
  - "postgres/src/backend/commands/repack.c:1568"
  - "postgres/src/backend/commands/repack.c:2026"
  - "postgres/src/backend/commands/subscriptioncmds.c:2479"
  - "postgres/src/backend/commands/tablecmds.c:3743"
  - "postgres/src/backend/commands/tablecmds.c:3846"
  - "postgres/src/backend/commands/tablecmds.c:4391"
  - "postgres/src/backend/commands/tablecmds.c:4468"
  - "postgres/src/backend/commands/tablecmds.c:7503"
  - "postgres/src/backend/commands/tablecmds.c:16795"
  - "postgres/src/backend/commands/tablecmds.c:17250"
  - "postgres/src/backend/commands/tablecmds.c:17374"
  - "postgres/src/backend/commands/tablecmds.c:17498"
  - "postgres/src/backend/commands/tablecmds.c:19040"
  - "postgres/src/backend/commands/tablecmds.c:19085"
  - "postgres/src/backend/commands/tablecmds.c:19321"
  - "postgres/src/backend/commands/tablecmds.c:19350"
  - "postgres/src/backend/commands/tablecmds.c:19770"
  - "postgres/src/backend/commands/tablecmds.c:20244"
  - "postgres/src/backend/commands/tablecmds.c:20268"
  - "postgres/src/backend/commands/tablecmds.c:22126"
  - "postgres/src/backend/commands/trigger.c:1033"
  - "postgres/src/backend/commands/vacuum.c:952"
  - "postgres/src/backend/executor/execAmi.c:614"
  - "postgres/src/backend/executor/execCurrent.c:63"
  - "postgres/src/backend/parser/parse_coerce.c:3396"
  - "postgres/src/backend/parser/parse_utilcmd.c:1721"
  - "postgres/src/backend/partitioning/partbounds.c:4310"
  - "postgres/src/backend/partitioning/partbounds.c:5079"
  - "postgres/src/backend/rewrite/rewriteSupport.c:65"
  - "postgres/src/backend/utils/adt/ruleutils.c:1346"
  - "postgres/src/backend/utils/adt/ruleutils.c:13931"
  - "postgres/src/backend/utils/adt/ruleutils.c:13958"
  - "postgres/src/backend/utils/adt/ruleutils.c:14014"
  - "postgres/src/backend/utils/adt/ruleutils.c:14439"
  - "postgres/src/backend/utils/adt/xml.c:3576"
  - "postgres/src/backend/utils/cache/inval.c:1694"
  - "postgres/src/backend/utils/cache/lsyscache.c:2400"
  - "postgres/src/backend/utils/cache/lsyscache.c:2422"
  - "postgres/src/backend/utils/cache/partcache.c:368"
  - "postgres/src/backend/utils/cache/relcache.c:4281"
reproduced: false
---

# `cache lookup failed for relation %u`

## What it means

Internal error. Postgres tried to load a relation (table, index, view, sequence, or similar) from the system catalog by its OID and found nothing. The placeholder is the OID. The relation cache expects the row to exist because something is still referencing it; its absence means the reference is stale or the catalog is inconsistent.

## When it happens

Almost always a race with concurrent DDL — an object was dropped while another session still held a reference to its OID — or genuine catalog corruption. It can also surface from extensions that cache OIDs across transactions, or after an unclean restore that left dangling references.

## How to fix

If it is transient and coincides with a `DROP`/`ALTER` running concurrently, retry the statement; the object is simply gone. If it repeats for a specific object, suspect catalog corruption: check `pg_class` for the OID, verify with `amcheck`, and restore from a known-good backup if the catalog is damaged. Persistent, reproducible cases are worth reporting with the exact steps.

## Example

*Illustrative* — a relation dropped concurrently with a query referencing it.

```text
ERROR:  cache lookup failed for relation 16421
```

## Related

- [cache lookup failed for type](./cache-lookup-failed-for-type.md)
- [cache lookup failed for index](./cache-lookup-failed-for-index.md)

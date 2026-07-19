---
message: "cache lookup failed for index %u"
slug: cache-lookup-failed-for-index
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/contrib/tcn/tcn.c:140"
  - "postgres/src/backend/catalog/index.c:169"
  - "postgres/src/backend/catalog/index.c:1345"
  - "postgres/src/backend/catalog/index.c:2088"
  - "postgres/src/backend/catalog/index.c:2371"
  - "postgres/src/backend/catalog/index.c:3160"
  - "postgres/src/backend/catalog/index.c:3536"
  - "postgres/src/backend/catalog/index.c:3615"
  - "postgres/src/backend/catalog/index.c:3880"
  - "postgres/src/backend/commands/explain.c:4241"
  - "postgres/src/backend/commands/indexcmds.c:274"
  - "postgres/src/backend/commands/indexcmds.c:1581"
  - "postgres/src/backend/commands/repack.c:862"
  - "postgres/src/backend/commands/tablecmds.c:13947"
  - "postgres/src/backend/commands/tablecmds.c:14068"
  - "postgres/src/backend/commands/tablecmds.c:19146"
  - "postgres/src/backend/commands/tablecmds.c:22595"
  - "postgres/src/backend/commands/tablecmds.c:22620"
  - "postgres/src/backend/replication/logical/worker.c:3266"
  - "postgres/src/backend/utils/adt/ruleutils.c:1321"
  - "postgres/src/backend/utils/adt/ruleutils.c:2761"
  - "postgres/src/backend/utils/cache/lsyscache.c:3947"
  - "postgres/src/backend/utils/cache/lsyscache.c:3970"
  - "postgres/src/backend/utils/cache/relcache.c:1463"
  - "postgres/src/backend/utils/cache/relcache.c:2344"
reproduced: false
---

# `cache lookup failed for index %u`

## What it means

Internal error. An index's catalog row (`pg_index`/`pg_class`) could not be found by OID. The placeholder is the index OID. Code expected the index to exist because something still references it.

## When it happens

A concurrent `DROP INDEX` (including the automatic drop of an index behind a constraint), catalog inconsistency, or an extension holding an index OID across a transaction. Not caused by ordinary data.

## How to fix

If it coincides with concurrent index DDL, retry — the index is gone. If it recurs for one OID, look it up in `pg_class`/`pg_index`; a missing row is corruption and warrants restore from backup and an `amcheck` pass. Reproducible cases should be reported.

## Example

*Illustrative* — an index dropped concurrently with a query planning against it.

```text
ERROR:  cache lookup failed for index 16530
```

## Related

- [cache lookup failed for relation](./cache-lookup-failed-for-relation-0e5774.md)
- [index is not valid](./index-is-not-valid.md)

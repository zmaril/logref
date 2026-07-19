---
message: "failed sanity check, parent OID %u of table \"%s\" (OID %u) not found"
slug: failed-sanity-check-parent-oid-of-table-oid-not-found
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/common.c:311"
reproduced: false
---

# `failed sanity check, parent OID %u of table "%s" (OID %u) not found`

## What it means

A `pg_dump` internal sanity check. Building the object graph, it recorded that a table has a parent (an inheritance or partition parent) whose catalog row it then could not find. The placeholders are the parent OID, the table name, and the table OID.

## When it happens

It fires during `pg_dump` when the catalog view it gathered is inconsistent — most often because DDL changed the inheritance or partition structure while the dump was running, or because of catalog corruption.

## How to fix

Avoid concurrent DDL on the tables being dumped; run the dump when the schema is stable. If nothing changed the schema concurrently, the missing parent may indicate catalog inconsistency worth investigating. Re-run the dump once the schema settles.

## Example

*Illustrative* — the message as logged.

```
pg_dump: error: failed sanity check, parent OID 16390 of table "child" (OID 16400) not found
```

## Related

- [failed sanity check, table OID appearing in pg_partitioned_table not found](./failed-sanity-check-table-oid-appearing-in-pg-partitioned-table-not-found.md)
- [failed sanity check, relation with OID not found](./failed-sanity-check-relation-with-oid-not-found.md)

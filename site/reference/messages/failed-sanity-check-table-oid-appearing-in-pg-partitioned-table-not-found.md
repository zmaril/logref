---
message: "failed sanity check, table OID %u appearing in pg_partitioned_table not found"
slug: failed-sanity-check-table-oid-appearing-in-pg-partitioned-table-not-found
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/pg_dump.c:7789"
reproduced: false
---

# `failed sanity check, table OID %u appearing in pg_partitioned_table not found`

## What it means

A `pg_dump` internal sanity check. It found an OID listed in `pg_partitioned_table` (the catalog of partitioned tables) that does not correspond to any table it gathered. The placeholder is the OID.

## When it happens

It fires during `pg_dump` when the partitioned-table catalog is inconsistent with the collected object set — usually from concurrent partition DDL during the dump, or catalog corruption.

## How to fix

Avoid concurrent partition DDL (create/attach/detach/drop) while dumping. Take the dump against a stable schema. If no concurrent changes happened, investigate possible catalog inconsistency. Re-run the dump once partition operations have finished.

## Example

*Illustrative* — the message as logged.

```
pg_dump: error: failed sanity check, table OID 16400 appearing in pg_partitioned_table not found
```

## Related

- [failed sanity check, parent OID of table OID not found](./failed-sanity-check-parent-oid-of-table-oid-not-found.md)
- [failed sanity check, relation with OID not found](./failed-sanity-check-relation-with-oid-not-found.md)

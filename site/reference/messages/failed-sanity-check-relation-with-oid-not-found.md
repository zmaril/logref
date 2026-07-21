---
message: "failed sanity check, relation with OID %u not found"
slug: failed-sanity-check-relation-with-oid-not-found
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/pg_dump.c:5416"
reproduced: false
---

# `failed sanity check, relation with OID %u not found`

## What it means

A `pg_dump` internal sanity check. It referenced a relation by OID while assembling the dump and could not find that relation among the objects it gathered. The placeholder is the OID.

## When it happens

It fires during `pg_dump` when the catalog view is inconsistent with the collected object set — most commonly because a table was dropped or altered concurrently with the dump, or because of catalog corruption.

## How to fix

Run the dump without concurrent DDL on the objects involved; take it when the schema is stable. If nothing changed concurrently, the missing relation may point at catalog inconsistency to investigate. Re-run the dump once the schema is quiescent.

## Example

*Illustrative* — the message as logged.

```
pg_dump: error: failed sanity check, relation with OID 16400 not found
```

## Related

- [failed sanity check, parent OID of table OID not found](./failed-sanity-check-parent-oid-of-table-oid-not-found.md)
- [failed sanity check, table OID appearing in pg_partitioned_table not found](./failed-sanity-check-table-oid-appearing-in-pg-partitioned-table-not-found.md)

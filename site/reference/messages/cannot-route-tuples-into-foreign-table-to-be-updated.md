---
message: "cannot route tuples into foreign table to be updated \"%s\""
slug: cannot-route-tuples-into-foreign-table-to-be-updated
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/contrib/postgres_fdw/postgres_fdw.c:2404"
reproduced: false
---

# `cannot route tuples into foreign table to be updated "%s"`

## What it means

Tuple routing for an update tried to move a row into a `postgres_fdw` foreign-table partition that is the update target. The wrapper cannot accept a routed row into a foreign partition during this update, so the operation is rejected. The placeholder is the foreign-table name.

## When it happens

It occurs during an `UPDATE` on a partitioned table where changing the partition key would route a row into a foreign-table partition, which the wrapper cannot handle as an update target.

## How to fix

Avoid updates that route rows into foreign-table partitions, or delete the row and insert it into the foreign partition explicitly so the wrapper's insert path handles it. Review the partitioning so cross-partition moves do not land on foreign tables.

## Example

*Illustrative* — routing an updated row into a foreign partition.

```text
ERROR:  cannot route tuples into foreign table to be updated "remote_p1"
```

## Related

- [cannot PREPARE a transaction that has operated on postgres_fdw foreign tables](./cannot-prepare-a-transaction-that-has-operated-on-postgres-fdw-foreign-tables.md)
- [cannot insert into foreign table](./cannot-insert-into-foreign-table.md)

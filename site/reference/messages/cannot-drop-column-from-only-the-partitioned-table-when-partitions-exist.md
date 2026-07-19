---
message: "cannot drop column from only the partitioned table when partitions exist"
slug: cannot-drop-column-from-only-the-partitioned-table-when-partitions-exist
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_TABLE_DEFINITION
    code: "42P16"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:9521"
reproduced: false
---

# `cannot drop column from only the partitioned table when partitions exist`

## What it means

An `ALTER TABLE ONLY ... DROP COLUMN` tried to drop a column from just the partitioned parent while partitions exist. Columns must stay consistent across the hierarchy, so dropping from the parent alone would desynchronize the partitions.

## When it happens

It occurs when a `DROP COLUMN` uses `ONLY` on a partitioned table that already has partitions.

## How to fix

Drop `ONLY` so the column is removed from the parent and all partitions together. A partitioned table and its partitions must share the same set of columns.

## Example

*Illustrative* — an ONLY column drop.

```text
ERROR:  cannot drop column from only the partitioned table when partitions exist
```

## Related

- [cannot drop column because it is part of the partition key of relation](./cannot-drop-column-because-it-is-part-of-the-partition-key-of-relation.md)
- [cannot drop inherited column](./cannot-drop-inherited-column.md)

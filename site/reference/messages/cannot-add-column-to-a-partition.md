---
message: "cannot add column to a partition"
slug: cannot-add-column-to-a-partition
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:7389"
reproduced: false
---

# `cannot add column to a partition`

## What it means

An `ALTER TABLE ... ADD COLUMN` was issued directly against a partition. Partitions inherit their column set from the partitioned parent, so columns cannot be added to a partition on its own.

## When it happens

It occurs when running `ALTER TABLE partition ADD COLUMN ...` on a table that is a partition of a partitioned table.

## How to fix

Add the column to the partitioned parent instead. `ALTER TABLE parent ADD COLUMN ...` propagates the new column to every partition, keeping their definitions aligned.

## Example

*Illustrative* — adding a column to a partition.

```sql
ALTER TABLE measurement_y2025 ADD COLUMN note text;
```

## Related

- [cannot add identity to a column of a partition](./cannot-add-identity-to-a-column-of-a-partition.md)
- [cannot add column to typed table](./cannot-add-column-to-typed-table.md)

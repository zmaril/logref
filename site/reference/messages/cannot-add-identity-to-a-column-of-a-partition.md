---
message: "cannot add identity to a column of a partition"
slug: cannot-add-identity-to-a-column-of-a-partition
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_TABLE_DEFINITION
    code: "42P16"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:8400"
reproduced: false
---

# `cannot add identity to a column of a partition`

## What it means

An `ALTER TABLE ... ADD GENERATED ... AS IDENTITY` was issued against a partition. Identity is a property of the partitioned parent's column, not of an individual partition.

## When it happens

It occurs when trying to add an identity specification to a column of a table that is a partition.

## How to fix

Add the identity to the column on the partitioned parent, which applies it across the partition hierarchy. Manage identity at the parent level rather than per partition.

## Example

*Illustrative* — adding identity to a partition column.

```sql
ALTER TABLE measurement_y2025 ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY;
```

## Related

- [cannot add identity to a column of only the partitioned table](./cannot-add-identity-to-a-column-of-only-the-partitioned-table.md)
- [cannot add column to a partition](./cannot-add-column-to-a-partition.md)

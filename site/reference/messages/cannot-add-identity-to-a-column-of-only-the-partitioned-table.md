---
message: "cannot add identity to a column of only the partitioned table"
slug: cannot-add-identity-to-a-column-of-only-the-partitioned-table
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_TABLE_DEFINITION
    code: "42P16"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:8394"
reproduced: false
---

# `cannot add identity to a column of only the partitioned table`

## What it means

An `ALTER TABLE ONLY ... ADD GENERATED ... AS IDENTITY` targeted only the partitioned table, excluding its partitions. Identity must apply to the whole hierarchy, so `ONLY` is not allowed here.

## When it happens

It occurs when using `ALTER TABLE ONLY parent ... ADD GENERATED ... AS IDENTITY` on a partitioned table.

## How to fix

Drop the `ONLY` keyword so the identity is added across the partitioned table and its partitions together. Identity on a partitioned column cannot be limited to the parent alone.

## Example

*Illustrative* — ONLY with an identity addition.

```sql
ALTER TABLE ONLY parent ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY;
```

## Related

- [cannot add identity to a column of a partition](./cannot-add-identity-to-a-column-of-a-partition.md)
- [cannot add no inherit constraint to partitioned table](./cannot-add-no-inherit-constraint-to-partitioned-table.md)

---
message: "cannot drop identity from a column of a partition"
slug: cannot-drop-identity-from-a-column-of-a-partition
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_TABLE_DEFINITION
    code: "42P16"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:8649"
reproduced: false
---

# `cannot drop identity from a column of a partition`

## What it means

An `ALTER TABLE ... ALTER COLUMN ... DROP IDENTITY` targeted a column of a partition directly. Identity is managed on the partitioned parent and inherited by partitions, so it cannot be dropped on an individual partition.

## When it happens

It occurs when running `DROP IDENTITY` against a leaf partition rather than the partitioned table.

## How to fix

Drop identity on the partitioned parent, which propagates to its partitions. Do not manage the identity property on a single partition.

## Example

*Illustrative* — dropping identity on a partition.

```text
ERROR:  cannot drop identity from a column of a partition
```

## Related

- [cannot drop identity from a column of only the partitioned table](./cannot-drop-identity-from-a-column-of-only-the-partitioned-table.md)
- [cannot change identity column of a partition](./cannot-change-identity-column-of-a-partition.md)

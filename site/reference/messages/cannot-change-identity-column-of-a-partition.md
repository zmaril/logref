---
message: "cannot change identity column of a partition"
slug: cannot-change-identity-column-of-a-partition
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_TABLE_DEFINITION
    code: "42P16"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:8532"
reproduced: false
---

# `cannot change identity column of a partition`

## What it means

An `ALTER TABLE ... ALTER COLUMN` tried to add, change, or drop the identity property on a column of a partition directly. Identity is managed on the partitioned parent, and partitions inherit it, so it cannot be altered on an individual partition.

## When it happens

It occurs when running an identity-related `ALTER COLUMN` against a leaf partition rather than the partitioned table.

## How to fix

Manage identity on the partitioned parent table, which propagates to its partitions. Do not alter the identity property on a single partition.

## Example

*Illustrative* — identity change on a partition.

```text
ERROR:  cannot change identity column of a partition
```

## Related

- [cannot change identity column of only the partitioned table](./cannot-change-identity-column-of-only-the-partitioned-table.md)
- [cannot change ownership of identity sequence](./cannot-change-ownership-of-identity-sequence.md)

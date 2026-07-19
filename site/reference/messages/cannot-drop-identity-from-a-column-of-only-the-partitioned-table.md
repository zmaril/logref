---
message: "cannot drop identity from a column of only the partitioned table"
slug: cannot-drop-identity-from-a-column-of-only-the-partitioned-table
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_TABLE_DEFINITION
    code: "42P16"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:8643"
reproduced: false
---

# `cannot drop identity from a column of only the partitioned table`

## What it means

An `ALTER TABLE ONLY ... ALTER COLUMN ... DROP IDENTITY` tried to drop identity from just the partitioned parent without touching its partitions. Identity must stay consistent across the hierarchy, so an `ONLY` drop is rejected.

## When it happens

It occurs when a `DROP IDENTITY` uses `ONLY` on a partitioned table whose partitions would be left out of sync.

## How to fix

Drop `ONLY` so the change covers the parent and all partitions together. Identity settings cannot diverge between a partitioned table and its partitions.

## Example

*Illustrative* — an ONLY identity drop.

```text
ERROR:  cannot drop identity from a column of only the partitioned table
```

## Related

- [cannot drop identity from a column of a partition](./cannot-drop-identity-from-a-column-of-a-partition.md)
- [cannot change identity column of only the partitioned table](./cannot-change-identity-column-of-only-the-partitioned-table.md)

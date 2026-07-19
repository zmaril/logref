---
message: "cannot change identity column of only the partitioned table"
slug: cannot-change-identity-column-of-only-the-partitioned-table
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_TABLE_DEFINITION
    code: "42P16"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:8526"
reproduced: false
---

# `cannot change identity column of only the partitioned table`

## What it means

An `ALTER TABLE ONLY ... ALTER COLUMN` tried to change the identity property on just the partitioned table without touching its partitions. Identity must stay consistent across the whole hierarchy, so an `ONLY` change to the parent alone is rejected.

## When it happens

It occurs when an identity-related `ALTER COLUMN` uses `ONLY` on a partitioned table, which would leave partitions out of sync.

## How to fix

Drop `ONLY` so the change applies to the parent and all partitions together. Identity settings cannot diverge between a partitioned table and its partitions.

## Example

*Illustrative* — an ONLY identity change.

```text
ERROR:  cannot change identity column of only the partitioned table
```

## Related

- [cannot change identity column of a partition](./cannot-change-identity-column-of-a-partition.md)
- [cannot change ownership of identity sequence](./cannot-change-ownership-of-identity-sequence.md)

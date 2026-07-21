---
message: "cannot truncate only a partitioned table"
slug: cannot-truncate-only-a-partitioned-table
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:2016"
reproduced: false
---

# `cannot truncate only a partitioned table`

## What it means

A `TRUNCATE ONLY` was issued on a partitioned table. A partitioned table holds no rows itself; all data lives in its partitions, so restricting truncation to the parent alone has nothing to empty and is rejected.

## When it happens

It occurs on `TRUNCATE ONLY parent` for a table partitioned with `PARTITION BY`.

## How to fix

Drop `ONLY` to truncate the partitioned table and all its partitions, or truncate specific partitions by name if you only want to empty some of them.

## Example

*Illustrative* — TRUNCATE ONLY on a partitioned table.

```sql
TRUNCATE ONLY measurements;
-- ERROR:  cannot truncate only a partitioned table
```

## Related

- [cannot specify storage parameters for a partitioned table](./cannot-specify-storage-parameters-for-a-partitioned-table.md)
- [cannot truncate a table referenced in a foreign key constraint](./cannot-truncate-a-table-referenced-in-a-foreign-key-constraint.md)

---
message: "\"%s\" is a partitioned table"
slug: is-a-partitioned-table
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/contrib/pgrowlocks/pgrowlocks.c:89"
  - "postgres/src/backend/commands/trigger.c:261"
reproduced: false
---

# `"%s" is a partitioned table`

## What it means

An operation that only applies to a regular (leaf) table was invoked on a partitioned table. A partitioned table has no storage of its own, so the requested action is not supported on it. The placeholder is the table name.

## When it happens

It arises from commands that need physical storage or a leaf relation — for example certain `VACUUM`/`CLUSTER` forms, `TRUNCATE ONLY` semantics, or storage-inspection functions — when given the partitioned parent instead of a partition.

## How to fix

Run the operation on the individual partitions, or use a command form that understands partitioned tables. To act on all partitions, iterate over them (query `pg_inherits` or use `\d+` to list them) and apply the operation to each leaf.

## Example

*Illustrative* — a storage operation on a partitioned parent.

```sql
CLUSTER measurements;  -- measurements is partitioned; cluster the partitions
```

## Related

- [is a table](./is-a-table.md)
- [is not a table or materialized view](./is-not-a-table-or-materialized-view.md)

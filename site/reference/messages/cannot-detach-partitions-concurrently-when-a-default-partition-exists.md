---
message: "cannot detach partitions concurrently when a default partition exists"
slug: cannot-detach-partitions-concurrently-when-a-default-partition-exists
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:21730"
reproduced: false
---

# `cannot detach partitions concurrently when a default partition exists`

## What it means

An `ALTER TABLE ... DETACH PARTITION ... CONCURRENTLY` was blocked because the partitioned table has a default partition. Concurrent detach cannot maintain the default partition's constraints safely while a partition is being removed online.

## When it happens

It occurs when running `DETACH PARTITION ... CONCURRENTLY` on a table that has a `DEFAULT` partition.

## How to fix

Detach the partition without `CONCURRENTLY`, or temporarily detach the default partition first and reattach it afterward. The concurrent path is unavailable while a default partition is present.

## Example

*Illustrative* — concurrent detach with a default partition.

```text
ERROR:  cannot detach partitions concurrently when a default partition exists
```

## Related

- [cannot detach partition](./cannot-detach-partition.md)
- [cannot complete detaching partition](./cannot-complete-detaching-partition.md)

---
message: "cannot complete detaching partition \"%s\""
slug: cannot-complete-detaching-partition
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/catalog/pg_inherits.c:598"
reproduced: false
---

# `cannot complete detaching partition "%s"`

## What it means

A `ALTER TABLE ... DETACH PARTITION FINALIZE` could not finish the concurrent detach because the partition is not in the expected in-between state. Concurrent detach happens in two steps, and the finalize step requires the partition to be mid-detach. The placeholder is the partition name.

## When it happens

It occurs when running `DETACH PARTITION ... FINALIZE` on a partition that is not currently in a partially detached state.

## How to fix

Run `FINALIZE` only for a partition whose concurrent detach was started but not completed. If the detach was never started, run the ordinary `DETACH PARTITION` (optionally `CONCURRENTLY`) instead.

## Example

*Illustrative* — finalizing a non-detaching partition.

```text
ERROR:  cannot complete detaching partition "p1"
```

## Related

- [cannot detach partition](./cannot-detach-partition.md)
- [cannot detach partitions concurrently when a default partition exists](./cannot-detach-partitions-concurrently-when-a-default-partition-exists.md)

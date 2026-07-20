---
message: "cannot drop partitioned index \"%s\" concurrently"
slug: cannot-drop-partitioned-index-concurrently
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:1728"
reproduced: false
---

# `cannot drop partitioned index "%s" concurrently`

## What it means

A `DROP INDEX CONCURRENTLY` named an index on a partitioned table — the parent index that spans all partitions. Concurrent drop is not supported for a partitioned index, since it would have to coordinate across every partition. The placeholder is the index name.

## When it happens

It occurs when running `DROP INDEX CONCURRENTLY` on the index of a partitioned table.

## How to fix

Drop the partitioned index without `CONCURRENTLY`, or drop the per-partition indexes concurrently first and then the parent. The parent index cannot be dropped concurrently in one step.

## Example

*Illustrative* — concurrent drop of a partitioned index.

```text
ERROR:  cannot drop partitioned index "p_idx" concurrently
```

## Related

- [cannot create index on partitioned table concurrently](./cannot-create-index-on-partitioned-table-concurrently.md)
- [cannot drop replication slot](./cannot-drop-replication-slot.md)

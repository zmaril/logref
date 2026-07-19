---
message: "cannot create index on partitioned table \"%s\" concurrently"
slug: cannot-create-index-on-partitioned-table-concurrently
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/indexcmds.c:750"
reproduced: false
---

# `cannot create index on partitioned table "%s" concurrently`

## What it means

A `CREATE INDEX CONCURRENTLY` named a partitioned table. Concurrent index builds are not supported on the partitioned parent, because the operation would have to coordinate across all partitions. The placeholder is the table name.

## When it happens

It occurs when running `CREATE INDEX CONCURRENTLY` directly on a partitioned table.

## How to fix

Create the index on the partitioned table without `CONCURRENTLY`, or build indexes concurrently on each partition individually and then attach them. The parent index cannot be built concurrently in one step.

## Example

*Illustrative* — concurrent index on a partitioned table.

```text
ERROR:  cannot create index on partitioned table "p" concurrently
```

## Related

- [cannot create index on relation](./cannot-create-index-on-relation.md)
- [cannot drop partitioned index concurrently](./cannot-drop-partitioned-index-concurrently.md)

---
message: "%s constraint on partitioned table must include all partitioning columns"
slug: constraint-on-partitioned-table-must-include-all-partitioning-columns
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/indexcmds.c:1105"
reproduced: true
---

# `%s constraint on partitioned table must include all partitioning columns`

## What it means

A primary-key, unique, or exclusion constraint on a partitioned table did not include every partitioning column. On a partitioned table such constraints must cover all partition-key columns so uniqueness can be enforced per partition.

## When it happens

It happens on `CREATE TABLE ... PARTITION BY ...` or `ALTER TABLE ... ADD` when a unique/primary-key/exclusion constraint omits one of the partition-key columns.

## How to fix

Add every partitioning column to the constraint's column list. If you need uniqueness on a subset that excludes the partition key, reconsider the partitioning scheme — global uniqueness across partitions on non-key columns is not supported.

## Example

*Reproduced* — this site fired under `reproducers/scenarios/61_pub_sub.sh`; see the reproducer for the triggering workload. It emits:

```text
ERROR:  %s constraint on partitioned table must include all partitioning columns
```

## Related

- [constraint using WITHOUT OVERLAPS needs at least two columns](./constraint-using-without-overlaps-needs-at-least-two-columns.md)
- [column named in partition key does not exist](./column-named-in-partition-key-does-not-exist.md)

---
message: "cannot find partition for split partition row"
slug: cannot-find-partition-for-split-partition-row
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_CHECK_VIOLATION
    code: "23514"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:24156"
reproduced: false
---

# `cannot find partition for split partition row`

## What it means

During an `ALTER TABLE ... SPLIT PARTITION`, a row in the partition being split did not match any of the new partitions. The new partition bounds do not cover every existing row, so the split cannot place that row.

## When it happens

It occurs when the `SPLIT PARTITION` command defines new partitions whose bounds leave a gap, and an existing row falls into that gap.

## How to fix

Adjust the new partition bounds so they cover the full range of data in the partition being split, or add a partition (including a default partition) that catches the leftover rows. Inspect the data range with a query before defining the split.

## Example

*Illustrative* — a row outside the new partition bounds.

```text
ERROR:  cannot find partition for split partition row
```

## Related

- [cannot merge partition together with partition](./cannot-merge-partition-together-with-partition.md)
- [cannot find ancestors of a non-partition result relation](./cannot-find-ancestors-of-a-non-partition-result-relation.md)

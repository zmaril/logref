---
message: "cannot merge partition \"%s\" together with partition \"%s\""
slug: cannot-merge-partition-together-with-partition
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_OBJECT_DEFINITION
    code: "42P17"
call_sites:
  - "postgres/src/backend/partitioning/partbounds.c:5043"
reproduced: false
---

# `cannot merge partition "%s" together with partition "%s"`

## What it means

An `ALTER TABLE ... MERGE PARTITIONS` named two partitions that cannot be combined. Their bounds are not adjacent or otherwise do not form a single contiguous range, so merging them would leave a gap or overlap. The placeholders are the two partition names.

## When it happens

It occurs when the partitions listed to merge are not neighbors in the partition ordering, or their bounds do not join into one valid range.

## How to fix

Merge only adjacent partitions whose bounds form a contiguous range. Check the partition bounds and list them in a set that joins cleanly, or add intermediate partitions so the range is continuous.

## Example

*Illustrative* — merging non-adjacent partitions.

```text
ERROR:  cannot merge partition "p_jan" together with partition "p_mar"
```

## Related

- [cannot merge partitions with conflicting extension dependencies](./cannot-merge-partitions-with-conflicting-extension-dependencies.md)
- [cannot find partition for split partition row](./cannot-find-partition-for-split-partition-row.md)

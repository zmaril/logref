---
message: "invalid pruning combine step argument"
slug: invalid-pruning-combine-step-argument
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/partitioning/partprune.c:3643"
  - "postgres/src/backend/partitioning/partprune.c:3667"
reproduced: false
---

# `invalid pruning combine step argument`

## What it means

Internal error. Partition-pruning execution referenced a combine step whose argument index does not point to a prior step's result. It is a consistency guard over the pruning-step program the planner builds.

## When it happens

It fires while executing runtime partition pruning when the pruning steps are internally inconsistent. Ordinary partitioned-table queries do not surface it; it points to an internal bug in pruning-step generation.

## How to fix

This is a can't-happen guard. As a workaround, disabling partition pruning (`SET enable_partition_pruning = off`) avoids the pruning program. Capture the query and the partitioned table's definition and report a reproducible case.

## Example

*Illustrative* — a pruning combine step with a bad argument.

```text
ERROR:  invalid pruning combine step argument
```

## Related

- [index for not found in partition](./index-for-not-found-in-partition.md)
- [is a partitioned table](./is-a-partitioned-table.md)

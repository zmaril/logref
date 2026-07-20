---
message: "cannot find ancestors of a non-partition result relation"
slug: cannot-find-ancestors-of-a-non-partition-result-relation
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/executor/execMain.c:1503"
reproduced: false
---

# `cannot find ancestors of a non-partition result relation`

## What it means

An internal guard in the executor fired: it tried to walk the partition ancestors of a result relation that is not a partition. Only partitions have ancestor chains, so this request should never be made for a plain table.

## When it happens

It is reached during modify-table setup when tuple-routing code asks for the ancestor chain of a relation the planner did not mark as a partition. It reflects a coding issue rather than a user action.

## How to fix

There is no user-level fix. If it appears, capture the statement and the partitioning layout and report it, since the executor should only request ancestors for genuine partitions.

## Example

*Illustrative* — ancestor lookup on a non-partition.

```text
ERROR:  cannot find ancestors of a non-partition result relation
```

## Related

- [cannot find partition for split partition row](./cannot-find-partition-for-split-partition-row.md)
- [cannot move tuple across partitions when a non-root ancestor of the source is referenced](./cannot-move-tuple-across-partitions-when-a-non-root-ancestor-of-the-source.md)

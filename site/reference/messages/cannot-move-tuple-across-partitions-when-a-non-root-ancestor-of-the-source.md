---
message: "cannot move tuple across partitions when a non-root ancestor of the source partition is directly referenced in a foreign key"
slug: cannot-move-tuple-across-partitions-when-a-non-root-ancestor-of-the-source
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/executor/nodeModifyTable.c:2703"
reproduced: false
---

# `cannot move tuple across partitions when a non-root ancestor of the source partition is directly referenced in a foreign key`

## What it means

An `UPDATE` on a partitioned table would move a row to a different partition, but a non-root ancestor of the source partition is directly referenced by a foreign key. Moving the row across partitions would require deleting and re-inserting it, which the foreign key on the intermediate ancestor forbids.

## When it happens

It occurs in a multi-level partitioned table when an `UPDATE` changes the partition-key value so the row must relocate, and an intermediate (non-root) ancestor partition is the direct target of a foreign-key reference.

## How to fix

Avoid updates that move rows across partitions on such tables, or point the foreign key at the root partitioned table rather than an intermediate ancestor. Alternatively delete the row and insert the new version explicitly so the foreign-key semantics are handled directly.

## Example

*Illustrative* — a cross-partition move blocked by a foreign key.

```text
ERROR:  cannot move tuple across partitions when a non-root ancestor of the source partition is directly referenced in a foreign key
```

## Related

- [cannot find partition for split partition row](./cannot-find-partition-for-split-partition-row.md)
- [cannot find ancestors of a non-partition result relation](./cannot-find-ancestors-of-a-non-partition-result-relation.md)

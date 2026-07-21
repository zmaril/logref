---
message: "cannot alter partition \"%s\" with an incomplete detach"
slug: cannot-alter-partition-with-an-incomplete-detach
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:5019"
reproduced: false
---

# `cannot alter partition "%s" with an incomplete detach`

## What it means

An `ALTER TABLE` targeted a partition that is in the middle of a concurrent detach. The placeholder is the partition. While a `DETACH PARTITION ... CONCURRENTLY` is unfinished, the partition is in a transitional state that blocks other alterations.

## When it happens

It occurs when a `DETACH PARTITION CONCURRENTLY` was interrupted or is still pending finalization, and another `ALTER TABLE` touches the same partition.

## How to fix

Finish or reverse the detach first. Run `ALTER TABLE ... DETACH PARTITION ... FINALIZE` to complete it, or reattach the partition, then perform the intended alteration.

## Example

*Illustrative* — altering a partition mid-detach.

```text
ERROR:  cannot alter partition "p1" with an incomplete detach
```

## Related

- [cannot alter constraint on relation](./cannot-alter-constraint-on-relation.md)
- [cannot add column to a partition](./cannot-add-column-to-a-partition.md)

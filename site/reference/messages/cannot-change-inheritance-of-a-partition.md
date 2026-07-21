---
message: "cannot change inheritance of a partition"
slug: cannot-change-inheritance-of-a-partition
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:17957"
reproduced: false
---

# `cannot change inheritance of a partition`

## What it means

An `ALTER TABLE ... INHERIT` or `NO INHERIT` was applied to a partition. A partition's membership is fixed by the partitioning system, so its inheritance relationship cannot be changed with the classic inheritance commands.

## When it happens

It occurs when running `ALTER TABLE partition INHERIT ...` or `NO INHERIT ...` on a table that is a partition.

## How to fix

Use `ATTACH PARTITION` and `DETACH PARTITION` on the partitioned parent to change membership, not the inheritance commands. Partitions are not managed through classic table inheritance.

## Example

*Illustrative* — changing a partition's inheritance.

```text
ERROR:  cannot change inheritance of a partition
```

## Related

- [cannot change inheritance of typed table](./cannot-change-inheritance-of-typed-table.md)
- [cannot attach inheritance child as partition](./cannot-attach-inheritance-child-as-partition.md)

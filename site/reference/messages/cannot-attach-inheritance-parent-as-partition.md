---
message: "cannot attach inheritance parent as partition"
slug: cannot-attach-inheritance-parent-as-partition
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:21135"
reproduced: false
---

# `cannot attach inheritance parent as partition`

## What it means

An `ALTER TABLE ... ATTACH PARTITION` named a table that is itself the parent of a classic inheritance hierarchy. A table with inheritance children cannot be turned into a partition, because that would mix inheritance and partitioning under one relation.

## When it happens

It occurs when the table being attached has one or more inheritance children created via `INHERITS`.

## How to fix

Remove the inheritance children first (detach them with `NO INHERIT`), then attach the now-childless table as a partition, or attach a different table. Partitioning and classic inheritance cannot overlap on the same relation.

## Example

*Illustrative* — attaching an inheritance parent.

```text
ERROR:  cannot attach inheritance parent as partition
```

## Related

- [cannot attach inheritance child as partition](./cannot-attach-inheritance-child-as-partition.md)
- [cannot change inheritance of typed table](./cannot-change-inheritance-of-typed-table.md)

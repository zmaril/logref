---
message: "cannot attach inheritance child as partition"
slug: cannot-attach-inheritance-child-as-partition
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:21121"
reproduced: false
---

# `cannot attach inheritance child as partition`

## What it means

An `ALTER TABLE ... ATTACH PARTITION` named a table that already inherits from another table through classic table inheritance. A relation cannot be both an inheritance child and a partition, so it cannot be attached while it has an inheritance parent.

## When it happens

It occurs when the table being attached was created with `INHERITS (...)` or was later made an inheritance child.

## How to fix

Detach the table from its inheritance parent with `ALTER TABLE ... NO INHERIT` first, then attach it as a partition. A table participates in one hierarchy at a time.

## Example

*Illustrative* — attaching an inheritance child.

```text
ERROR:  cannot attach inheritance child as partition
```

## Related

- [cannot attach inheritance parent as partition](./cannot-attach-inheritance-parent-as-partition.md)
- [cannot change inheritance of a partition](./cannot-change-inheritance-of-a-partition.md)

---
message: "cannot inherit from partition \"%s\""
slug: cannot-inherit-from-partition
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:2756"
reproduced: false
---

# `cannot inherit from partition "%s"`

## What it means

A `CREATE TABLE ... INHERITS` or `ALTER TABLE ... INHERIT` named a specific partition as the inheritance parent. A partition is bound to its partitioned parent and cannot be inherited from. The placeholder is the partition name.

## When it happens

It occurs when an inheritance clause references a named partition rather than an ordinary table or the partitioned parent.

## How to fix

Inherit from the partitioned parent or an ordinary table. Model shared structure on the parent, not on an individual partition.

## Example

*Illustrative* — inheriting from a named partition.

```text
ERROR:  cannot inherit from partition "orders_2024"
```

## Related

- [cannot inherit from a partition](./cannot-inherit-from-a-partition.md)
- [cannot inherit from conflict log table](./cannot-inherit-from-conflict-log-table.md)

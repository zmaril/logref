---
message: "cannot inherit from a partition"
slug: cannot-inherit-from-a-partition
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:18017"
reproduced: false
---

# `cannot inherit from a partition`

## What it means

A `CREATE TABLE ... INHERITS` or `ALTER TABLE ... INHERIT` tried to make a table inherit from a partition. A partition belongs to its partitioned parent and cannot itself serve as an inheritance parent, so the request is rejected.

## When it happens

It occurs when an inheritance clause names a partition of a partitioned table as the parent to inherit from.

## How to fix

Inherit from the partitioned parent table or from an ordinary table instead of from a partition. If you need shared columns, model them on the parent rather than on one of its partitions.

## Example

*Illustrative* — inheriting from a partition.

```text
ERROR:  cannot inherit from a partition
```

## Related

- [cannot inherit from partition](./cannot-inherit-from-partition.md)
- [cannot inherit from temporary relation](./cannot-inherit-from-temporary-relation.md)

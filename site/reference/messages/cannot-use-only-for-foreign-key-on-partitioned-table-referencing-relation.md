---
message: "cannot use ONLY for foreign key on partitioned table \"%s\" referencing relation \"%s\""
slug: cannot-use-only-for-foreign-key-on-partitioned-table-referencing-relation
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:10244"
reproduced: false
---

# `cannot use ONLY for foreign key on partitioned table "%s" referencing relation "%s"`

## What it means

A foreign key on a partitioned table was defined with `ONLY` on the referenced side. A foreign key from a partitioned table must apply to the whole partition hierarchy of the referenced relation, so restricting it with `ONLY` is not allowed.

## When it happens

It occurs when adding a foreign key on a partitioned table that references another table using the `ONLY` keyword.

## How to fix

Remove `ONLY` so the foreign key covers the full referenced table and its partitions. Reference the partitioned parent without restriction.

## Example

*Illustrative* — ONLY on a partitioned foreign key.

```text
ERROR:  cannot use ONLY for foreign key on partitioned table "child" referencing relation "parent"
```

## Related

- [cannot use a deferrable primary key for referenced table](./cannot-use-a-deferrable-primary-key-for-referenced-table.md)
- [cannot use a deferrable unique constraint for referenced table](./cannot-use-a-deferrable-unique-constraint-for-referenced-table.md)

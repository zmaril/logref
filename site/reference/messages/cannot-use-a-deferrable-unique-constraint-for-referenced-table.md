---
message: "cannot use a deferrable unique constraint for referenced table \"%s\""
slug: cannot-use-a-deferrable-unique-constraint-for-referenced-table
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:14150"
reproduced: false
---

# `cannot use a deferrable unique constraint for referenced table "%s"`

## What it means

A foreign key tried to reference a unique constraint that is declared `DEFERRABLE`. Foreign-key checks need the referenced key to be enforced immediately, so a deferrable unique constraint cannot back the reference.

## When it happens

It occurs when adding a foreign key whose referenced columns are covered only by a `DEFERRABLE` unique constraint.

## How to fix

Reference a non-deferrable unique constraint or primary key. Recreate the unique constraint without `DEFERRABLE`, or point the foreign key at a suitable immediate constraint.

## Example

*Illustrative* — referencing a deferrable unique constraint.

```text
ERROR:  cannot use a deferrable unique constraint for referenced table "parent"
```

## Related

- [cannot use a deferrable primary key for referenced table](./cannot-use-a-deferrable-primary-key-for-referenced-table.md)
- [cannot use ONLY for foreign key on partitioned table referencing relation](./cannot-use-only-for-foreign-key-on-partitioned-table-referencing-relation.md)

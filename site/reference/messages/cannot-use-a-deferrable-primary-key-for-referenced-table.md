---
message: "cannot use a deferrable primary key for referenced table \"%s\""
slug: cannot-use-a-deferrable-primary-key-for-referenced-table
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:13957"
reproduced: false
---

# `cannot use a deferrable primary key for referenced table "%s"`

## What it means

A foreign key tried to reference a primary key that is declared `DEFERRABLE`. Referential integrity checks need the referenced key to be enforced immediately, so a deferrable primary key cannot back a foreign key.

## When it happens

It occurs when adding a foreign key whose referenced table's primary key was created with `DEFERRABLE` (or `INITIALLY DEFERRED`).

## How to fix

Make the referenced primary key non-deferrable, or reference a different unique constraint that is enforced immediately. Recreate the primary key without `DEFERRABLE` if a foreign key must point at it.

## Example

*Illustrative* — referencing a deferrable primary key.

```text
ERROR:  cannot use a deferrable primary key for referenced table "parent"
```

## Related

- [cannot use a deferrable unique constraint for referenced table](./cannot-use-a-deferrable-unique-constraint-for-referenced-table.md)
- [cannot use ONLY for foreign key on partitioned table referencing relation](./cannot-use-only-for-foreign-key-on-partitioned-table-referencing-relation.md)

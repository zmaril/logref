---
message: "column \"%s\" in child table \"%s\" must be marked NOT NULL"
slug: column-in-child-table-must-be-marked-not-null
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATATYPE_MISMATCH
    code: "42804"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:18259"
  - "postgres/src/backend/commands/tablecmds.c:18508"
reproduced: false
---

# `column "%s" in child table "%s" must be marked NOT NULL`

## What it means

A child table's column corresponding to a parent's NOT NULL column is not itself marked NOT NULL. The placeholders are the column and the child table. Inheritance requires the child to be at least as restrictive as the parent on nullability.

## When it happens

Attaching a partition or creating an inheritance child where a column that is NOT NULL in the parent lacks the NOT NULL marking in the child.

## How to fix

Add NOT NULL to the child column (`ALTER TABLE child ALTER COLUMN col SET NOT NULL`) before attaching or creating it. The child must enforce the parent's NOT NULL constraint on the shared column.

## Example

*Illustrative* — a nullable child column under a NOT NULL parent.

```text
ERROR:  column "id" in child table "c" must be marked NOT NULL
```

## Related

- [child table has different type for column](./child-table-has-different-type-for-column.md)
- [column of relation contains null values](./column-of-relation-contains-null-values.md)

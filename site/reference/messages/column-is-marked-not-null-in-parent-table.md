---
message: "column \"%s\" is marked NOT NULL in parent table"
slug: column-is-marked-not-null-in-parent-table
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_TABLE_DEFINITION
    code: "42P16"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:7941"
reproduced: false
---

# `column "%s" is marked NOT NULL in parent table`

## What it means

An attempt to drop a column's `NOT NULL` constraint failed because a parent table marks that inherited column `NOT NULL`. An inherited `NOT NULL` cannot be dropped from the child alone.

## When it happens

It occurs on `ALTER TABLE child ALTER COLUMN ... DROP NOT NULL` when the column inherits its `NOT NULL` marking from a parent table.

## How to fix

Drop the `NOT NULL` on the parent table instead, which propagates to children, or detach the child from inheritance first if it must keep the column nullable independently.

## Example

*Illustrative* — dropping an inherited NOT NULL on a child.

```sql
ALTER TABLE child ALTER COLUMN a DROP NOT NULL;
-- ERROR:  column "a" is marked NOT NULL in parent table
```

## Related

- [column is in a primary key](./column-is-in-a-primary-key.md)
- [column must be added to child tables too](./column-must-be-added-to-child-tables-too.md)

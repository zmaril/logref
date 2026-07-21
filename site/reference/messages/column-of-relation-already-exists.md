---
message: "column \"%s\" of relation \"%s\" already exists"
slug: column-of-relation-already-exists
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DUPLICATE_COLUMN
    code: "42701"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:7827"
reproduced: false
---

# `column "%s" of relation "%s" already exists`

## What it means

An `ALTER TABLE ... ADD COLUMN` tried to add a column whose name is already used by the relation. Column names must be unique within a table.

## When it happens

It happens on `ALTER TABLE ... ADD COLUMN name ...` when a column with that name already exists (possibly inherited from a parent).

## How to fix

Choose a different column name, or use `ADD COLUMN IF NOT EXISTS` to make the statement a no-op when the column is already present. If the column is inherited, adjust the parent instead.

## Example

*Illustrative* — adding a column that already exists.

```sql
CREATE TABLE t (a int);
ALTER TABLE t ADD COLUMN a int;
-- ERROR:  column "a" of relation "t" already exists
```

## Related

- [column name specified more than once](./column-name-specified-more-than-once.md)
- [column of relation already has a default value](./column-of-relation-already-has-a-default-value.md)

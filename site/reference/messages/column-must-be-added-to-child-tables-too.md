---
message: "column must be added to child tables too"
slug: column-must-be-added-to-child-tables-too
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_TABLE_DEFINITION
    code: "42P16"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:7742"
reproduced: false
---

# `column must be added to child tables too`

## What it means

An `ALTER TABLE ... ADD COLUMN ONLY` was attempted on a table that has children, but adding a column to a parent alone would leave the children without it. Inherited columns must exist on the children as well.

## When it happens

It happens on `ALTER TABLE ONLY parent ADD COLUMN ...` when the parent has inheritance children or partitions, so the `ONLY` keyword conflicts with propagating the column.

## How to fix

Run `ALTER TABLE parent ADD COLUMN ...` without `ONLY` so the column is added to all descendants, or add the column to each child explicitly if you truly need per-table control.

## Example

*Illustrative* — ADD COLUMN ONLY on a table with children.

```sql
ALTER TABLE ONLY parent ADD COLUMN c int;
-- ERROR:  column must be added to child tables too
```

## Related

- [column is marked NOT NULL in parent table](./column-is-marked-not-null-in-parent-table.md)
- [constraint must be added to child tables too](./constraint-must-be-altered-in-child-tables-too.md)

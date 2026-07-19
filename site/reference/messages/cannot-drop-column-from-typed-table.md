---
message: "cannot drop column from typed table"
slug: cannot-drop-column-from-typed-table
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:9396"
reproduced: false
---

# `cannot drop column from typed table`

## What it means

An `ALTER TABLE ... DROP COLUMN` targeted a typed table — one created with `OF type_name`. A typed table's columns come from its composite type, so columns cannot be dropped from the table directly.

## When it happens

It occurs when dropping a column from a table created as `CREATE TABLE ... OF some_type`.

## How to fix

Change the underlying composite type with `ALTER TYPE ... DROP ATTRIBUTE`, which updates the typed table, or detach the table from the type. Columns of a typed table follow the type definition.

## Example

*Illustrative* — dropping a column from a typed table.

```text
ERROR:  cannot drop column from typed table
```

## Related

- [cannot drop inherited column](./cannot-drop-inherited-column.md)
- [cannot convert relation containing dropped columns to view](./cannot-convert-relation-containing-dropped-columns-to-view.md)

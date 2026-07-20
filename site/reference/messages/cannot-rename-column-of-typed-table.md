---
message: "cannot rename column of typed table"
slug: cannot-rename-column-of-typed-table
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:3879"
reproduced: false
---

# `cannot rename column of typed table`

## What it means

An `ALTER TABLE ... RENAME COLUMN` targeted a column of a typed table — a table declared `OF some_type`. Its columns come from the underlying composite type, so they must be renamed on the type, not the table.

## When it happens

It occurs when you rename a column on a table created with `CREATE TABLE ... OF type_name`.

## How to fix

Rename the attribute on the underlying composite type with `ALTER TYPE ... RENAME ATTRIBUTE`, which propagates to the typed table. Do not rename typed-table columns directly.

## Example

*Illustrative* — renaming a typed-table column.

```text
ERROR:  cannot rename column of typed table
```

## Related

- [cannot rename inherited column](./cannot-rename-inherited-column.md)
- [cannot rename system column](./cannot-rename-system-column.md)

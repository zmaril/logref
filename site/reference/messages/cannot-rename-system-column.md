---
message: "cannot rename system column \"%s\""
slug: cannot-rename-system-column
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:4038"
reproduced: false
---

# `cannot rename system column "%s"`

## What it means

An `ALTER TABLE ... RENAME COLUMN` targeted a system column such as `ctid`, `xmin`, or `tableoid`. System columns are fixed parts of the row model and cannot be renamed. The placeholder is the column name.

## When it happens

It occurs when a rename-column command names a hidden system column rather than a user column.

## How to fix

Rename only user-defined columns. Leave system columns as they are; they are managed by the engine and cannot be altered.

## Example

*Illustrative* — renaming a system column.

```text
ERROR:  cannot rename system column "ctid"
```

## Related

- [cannot rename column of typed table](./cannot-rename-column-of-typed-table.md)
- [cannot modify statistics on system column](./cannot-modify-statistics-on-system-column.md)

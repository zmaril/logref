---
message: "cannot drop system column \"%s\""
slug: cannot-drop-system-column
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:9473"
reproduced: false
---

# `cannot drop system column "%s"`

## What it means

An `ALTER TABLE ... DROP COLUMN` named a system column such as `ctid`, `xmin`, or `tableoid`. System columns are part of every table's fixed structure and cannot be dropped. The placeholder is the column name.

## When it happens

It occurs when a `DROP COLUMN` names one of a table's hidden system columns.

## How to fix

Drop only user-defined columns. System columns are managed by Postgres and are always present; there is nothing to remove.

## Example

*Illustrative* — dropping a system column.

```text
ERROR:  cannot drop system column "ctid"
```

## Related

- [cannot drop inherited column](./cannot-drop-inherited-column.md)
- [cannot clear statistics on system column](./cannot-clear-statistics-on-system-column.md)

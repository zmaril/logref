---
message: "system-column update is not supported"
slug: system-column-update-is-not-supported
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/contrib/postgres_fdw/postgres_fdw.c:2060"
  - "postgres/contrib/postgres_fdw/postgres_fdw.c:2747"
reproduced: false
---

# `system-column update is not supported`

## What it means

An `UPDATE` tried to assign a new value to a system column (such as `ctid`, `xmin`, `xmax`, `tableoid`). System columns are maintained by the server and cannot be set directly.

## When it happens

It arises from an `UPDATE ... SET system_column = ...` targeting one of the hidden system columns.

## How to fix

Do not assign to system columns; update only user-defined columns. If you were trying to move or identify a row, use its primary key or an ordinary column instead of a system column.

## Example

*Illustrative* — assigning to a system column.

```text
ERROR:  system-column update is not supported
```

## Related

- [tableoid is NULL](./tableoid-is-null.md)
- [resjunk output columns are not implemented](./resjunk-output-columns-are-not-implemented.md)

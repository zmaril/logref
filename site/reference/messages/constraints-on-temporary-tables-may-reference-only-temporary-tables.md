---
message: "constraints on temporary tables may reference only temporary tables"
slug: constraints-on-temporary-tables-may-reference-only-temporary-tables
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_TABLE_DEFINITION
    code: "42P16"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:10300"
reproduced: false
---

# `constraints on temporary tables may reference only temporary tables`

## What it means

A foreign key from a temporary table pointed at a non-temporary table. A temporary table's constraints may reference only temporary tables, because the temp table's lifetime is bound to the session.

## When it happens

It happens on `CREATE TABLE`/`ALTER TABLE` adding a foreign key on a temporary table whose referenced table is permanent or unlogged.

## How to fix

Reference another temporary table, or make the referencing table permanent if it should reference permanent data. Temporary tables cannot enforce references against tables outside their session scope.

## Example

*Illustrative* — a temp FK referencing a permanent table.

```text
ERROR:  constraints on temporary tables may reference only temporary tables
```

## Related

- [constraints on temporary tables must involve temporary tables of this session](./constraints-on-temporary-tables-must-involve-temporary-tables-of-this-session.md)
- [constraints on permanent tables may reference only permanent tables](./constraints-on-permanent-tables-may-reference-only-permanent-tables.md)

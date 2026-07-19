---
message: "constraints on unlogged tables may reference only permanent or unlogged tables"
slug: constraints-on-unlogged-tables-may-reference-only-permanent-or-unlogged-tables
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_TABLE_DEFINITION
    code: "42P16"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:10294"
reproduced: false
---

# `constraints on unlogged tables may reference only permanent or unlogged tables`

## What it means

A foreign key from an unlogged table pointed at a temporary table. An unlogged table's constraints may reference permanent or unlogged tables, but not temporary ones, whose lifetime is too short.

## When it happens

It happens on `CREATE TABLE`/`ALTER TABLE` adding a foreign key on an unlogged table whose referenced table is temporary.

## How to fix

Reference a permanent or unlogged table instead of a temporary one, or reconsider the persistence of the tables involved so their durability is compatible.

## Example

*Illustrative* — an unlogged FK referencing a temp table.

```text
ERROR:  constraints on unlogged tables may reference only permanent or unlogged tables
```

## Related

- [constraints on permanent tables may reference only permanent tables](./constraints-on-permanent-tables-may-reference-only-permanent-tables.md)
- [constraints on temporary tables may reference only temporary tables](./constraints-on-temporary-tables-may-reference-only-temporary-tables.md)

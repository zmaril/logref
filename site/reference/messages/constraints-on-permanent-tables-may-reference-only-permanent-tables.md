---
message: "constraints on permanent tables may reference only permanent tables"
slug: constraints-on-permanent-tables-may-reference-only-permanent-tables
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_TABLE_DEFINITION
    code: "42P16"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:10287"
reproduced: false
---

# `constraints on permanent tables may reference only permanent tables`

## What it means

A foreign key from a permanent table pointed at a table of a less durable persistence (temporary or unlogged). A permanent table's constraints may only reference other permanent tables, so their durability matches.

## When it happens

It happens on `CREATE TABLE`/`ALTER TABLE` adding a foreign key whose referenced table is temporary or unlogged while the referencing table is permanent.

## How to fix

Reference a permanent table instead, or change the referencing table's persistence to match. A permanent table cannot depend on data that may vanish (temp) or is not crash-safe (unlogged).

## Example

*Illustrative* — a permanent FK referencing a temp table.

```text
ERROR:  constraints on permanent tables may reference only permanent tables
```

## Related

- [constraints on unlogged tables may reference only permanent or unlogged tables](./constraints-on-unlogged-tables-may-reference-only-permanent-or-unlogged-tables.md)
- [constraints on temporary tables may reference only temporary tables](./constraints-on-temporary-tables-may-reference-only-temporary-tables.md)

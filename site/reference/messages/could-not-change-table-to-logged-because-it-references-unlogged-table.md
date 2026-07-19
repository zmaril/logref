---
message: "could not change table \"%s\" to logged because it references unlogged table \"%s\""
slug: could-not-change-table-to-logged-because-it-references-unlogged-table
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_TABLE_DEFINITION
    code: "42P16"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:19610"
reproduced: false
---

# `could not change table "%s" to logged because it references unlogged table "%s"`

## What it means

An `ALTER TABLE ... SET LOGGED` was blocked because the table has a foreign key to an unlogged table. A logged (permanent) table cannot reference an unlogged one, so it cannot become logged while that reference exists.

## When it happens

It happens on `ALTER TABLE t SET LOGGED` when `t` has a foreign key pointing at an unlogged table.

## How to fix

Make the referenced table logged first (`ALTER TABLE ref SET LOGGED`), or drop the foreign key, then set the table logged. Ensure the whole reference chain has compatible persistence.

## Example

*Illustrative* — SET LOGGED blocked by an unlogged reference.

```text
ERROR:  could not change table "t" to logged because it references unlogged table "u"
```

## Related

- [could not change table to unlogged because it references logged table](./could-not-change-table-to-unlogged-because-it-references-logged-table.md)
- [constraints on permanent tables may reference only permanent tables](./constraints-on-permanent-tables-may-reference-only-permanent-tables.md)

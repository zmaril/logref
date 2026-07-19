---
message: "cannot change logged status of table \"%s\" because it is temporary"
slug: cannot-change-logged-status-of-table-because-it-is-temporary
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_TABLE_DEFINITION
    code: "42P16"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:19539"
reproduced: false
---

# `cannot change logged status of table "%s" because it is temporary`

## What it means

An `ALTER TABLE ... SET LOGGED` or `SET UNLOGGED` was applied to a temporary table. Temporary tables have their own persistence class and are never WAL-logged, so switching their logged status is not meaningful. The placeholder is the table name.

## When it happens

It occurs when running `SET LOGGED`/`SET UNLOGGED` on a `TEMPORARY` table.

## How to fix

Do not change logged status on temporary tables. If you need a durable, logged table, create a permanent table instead of a temporary one.

## Example

*Illustrative* — SET LOGGED on a temp table.

```text
ERROR:  cannot change logged status of table "t" because it is temporary
```

## Related

- [cannot change table to unlogged because it is part of a publication](./cannot-change-table-to-unlogged-because-it-is-part-of-a-publication.md)
- [cannot change persistence setting twice](./cannot-change-persistence-setting-twice.md)

---
message: "could not change table \"%s\" to unlogged because it references logged table \"%s\""
slug: could-not-change-table-to-unlogged-because-it-references-logged-table
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_TABLE_DEFINITION
    code: "42P16"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:19620"
reproduced: false
---

# `could not change table "%s" to unlogged because it references logged table "%s"`

## What it means

An `ALTER TABLE ... SET UNLOGGED` was blocked because the table has a foreign key to a logged (permanent) table. Making it unlogged would create a reference from unlogged to logged data that is disallowed in this direction.

## When it happens

It happens on `ALTER TABLE t SET UNLOGGED` when `t` references a logged table via a foreign key that the change would violate.

## How to fix

Adjust the reference relationship so persistence is compatible — drop the foreign key, or reconsider whether the table should be unlogged. Ensure the persistence of referencing and referenced tables aligns with the rules.

## Example

*Illustrative* — SET UNLOGGED blocked by a logged reference.

```text
ERROR:  could not change table "t" to unlogged because it references logged table "p"
```

## Related

- [could not change table to logged because it references unlogged table](./could-not-change-table-to-logged-because-it-references-unlogged-table.md)
- [constraints on unlogged tables may reference only permanent or unlogged tables](./constraints-on-unlogged-tables-may-reference-only-permanent-or-unlogged-tables.md)

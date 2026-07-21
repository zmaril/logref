---
message: "cannot inherit from conflict log table \"%s\""
slug: cannot-inherit-from-conflict-log-table
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:2767"
reproduced: false
---

# `cannot inherit from conflict log table "%s"`

## What it means

An inheritance clause named a conflict log table as the parent. The conflict log table is a special system-managed relation and cannot be used as an inheritance parent. The placeholder is the table name.

## When it happens

It occurs when a `CREATE TABLE ... INHERITS` or `ALTER TABLE ... INHERIT` points at a conflict log table used by logical-replication conflict recording.

## How to fix

Do not inherit from the conflict log table. Base your table on an ordinary parent instead, and leave the conflict log table to its system role.

## Example

*Illustrative* — inheriting from a conflict log table.

```text
ERROR:  cannot inherit from conflict log table "pg_conflict_log"
```

## Related

- [cannot inherit from a partition](./cannot-inherit-from-a-partition.md)
- [cannot modify or insert data into conflict log table](./cannot-modify-or-insert-data-into-conflict-log-table.md)

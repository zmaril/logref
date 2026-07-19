---
message: "cannot reference conflict log table \"%s\""
slug: cannot-reference-conflict-log-table
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:10263"
reproduced: false
---

# `cannot reference conflict log table "%s"`

## What it means

A foreign key or similar reference targeted a conflict log table. The conflict log table is a system-managed relation for logical-replication conflict records and cannot be the referenced side of a constraint. The placeholder is the table name.

## When it happens

It occurs when a `FOREIGN KEY` or other constraint names a conflict log table as its reference target.

## How to fix

Reference an ordinary table instead. Do not build constraints against the conflict log table, which exists for observation of replication conflicts.

## Example

*Illustrative* — a foreign key referencing the conflict log table.

```text
ERROR:  cannot reference conflict log table "pg_conflict_log"
```

## Related

- [cannot inherit from conflict log table](./cannot-inherit-from-conflict-log-table.md)
- [cannot rename columns of conflict log table](./cannot-rename-columns-of-conflict-log-table.md)

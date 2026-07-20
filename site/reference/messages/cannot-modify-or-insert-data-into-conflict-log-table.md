---
message: "cannot modify or insert data into conflict log table \"%s\""
slug: cannot-modify-or-insert-data-into-conflict-log-table
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/executor/execMain.c:1212"
reproduced: false
---

# `cannot modify or insert data into conflict log table "%s"`

## What it means

An `INSERT`, `UPDATE`, `DELETE`, or `MERGE` targeted a conflict log table. The conflict log table is system-managed for logical-replication conflict records and does not accept direct user writes. The placeholder is the table name.

## When it happens

It occurs when a user statement tries to write to the conflict log table rather than only reading from it.

## How to fix

Do not write to the conflict log table directly. Read it for diagnostics, and let the replication apply machinery manage its contents.

## Example

*Illustrative* — writing to the conflict log table.

```text
ERROR:  cannot modify or insert data into conflict log table "pg_conflict_log"
```

## Related

- [cannot lock rows in the conflict log table](./cannot-lock-rows-in-the-conflict-log-table.md)
- [cannot inherit from conflict log table](./cannot-inherit-from-conflict-log-table.md)

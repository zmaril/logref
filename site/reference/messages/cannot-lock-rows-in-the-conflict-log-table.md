---
message: "cannot lock rows in the conflict log table \"%s\""
slug: cannot-lock-rows-in-the-conflict-log-table
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/executor/execMain.c:1294"
reproduced: false
---

# `cannot lock rows in the conflict log table "%s"`

## What it means

A row-locking clause was applied to a query over a conflict log table. The conflict log table is a system-managed relation for logical-replication conflict records and does not support user row locking. The placeholder is the table name.

## When it happens

It occurs when a `SELECT ... FOR UPDATE`/`FOR SHARE` reads from the conflict log table.

## How to fix

Read the conflict log table without a row-locking clause. It is intended for observation, not for locking or updating through user queries.

## Example

*Illustrative* — FOR UPDATE on the conflict log table.

```text
ERROR:  cannot lock rows in the conflict log table "pg_conflict_log"
```

## Related

- [cannot modify or insert data into conflict log table](./cannot-modify-or-insert-data-into-conflict-log-table.md)
- [cannot lock rows in relation](./cannot-lock-rows-in-relation.md)

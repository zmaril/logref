---
message: "unexpected table_tuple_lock status: %u"
slug: unexpected-table-tuple-lock-status
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/commands/trigger.c:3471"
  - "postgres/src/backend/executor/execReplication.c:168"
  - "postgres/src/backend/executor/nodeLockRows.c:229"
  - "postgres/src/backend/executor/nodeModifyTable.c:2055"
  - "postgres/src/backend/executor/nodeModifyTable.c:2971"
  - "postgres/src/backend/executor/nodeModifyTable.c:4004"
  - "postgres/src/backend/utils/adt/ri_triggers.c:3321"
reproduced: false
---

# `unexpected table_tuple_lock status: %u`

## What it means

Internal error. A row-locking operation received a status code from the table access method's `tuple_lock` routine that the caller does not handle. The placeholder is the numeric status. It is a guard against an unexpected outcome when locking a specific row.

## When it happens

A bug in row-locking code, an unusual concurrency interaction, or a custom table access method returning an unexpected status. It can surface from `SELECT ... FOR UPDATE`, foreign-key checks, or replication apply. Ordinary locking rarely triggers it.

## How to fix

Treat it as a bug. If a custom table access method is in use, suspect its `tuple_lock` implementation. Capture the workload (the statement and concurrency pattern) and a stack trace and report it. If it recurs on heap tables, note the exact steps for a bug report.

## Example

*Illustrative* — an unexpected lock status during row locking.

```text
ERROR:  unexpected table_tuple_lock status: 5
```

## Related

- [unexpected HeapTupleSatisfiesVacuum result](./unexpected-heaptuplesatisfiesvacuum-result-a1d853.md)
- [could not serialize access due to concurrent update](./could-not-serialize-access-due-to-concurrent-update.md)

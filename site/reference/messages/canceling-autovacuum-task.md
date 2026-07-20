---
message: "canceling autovacuum task"
slug: canceling-autovacuum-task
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_QUERY_CANCELED
    code: "57014"
call_sites:
  - "postgres/src/backend/tcop/postgres.c:3621"
reproduced: false
---

# `canceling autovacuum task`

## What it means

An autovacuum worker was canceled because another session needed a lock the worker was holding. Autovacuum yields to regular work: when a conflicting lock request arrives, the worker's current task is canceled so the user operation can proceed.

## When it happens

It occurs when a statement such as an `ALTER TABLE`, `TRUNCATE`, or `DROP` needs a lock on a table that autovacuum is currently processing.

## How to fix

This is usually normal and self-correcting: autovacuum retries the table later. If it happens repeatedly on the same table, frequent conflicting DDL or long-held locks may be starving autovacuum; reduce lock contention or schedule heavy DDL for quieter periods so vacuuming can keep up.

## Example

*Illustrative* — autovacuum yielding to a lock request.

```text
ERROR:  canceling autovacuum task
```

## Related

- [canceling statement due to lock timeout](./canceling-statement-due-to-lock-timeout.md)
- [cannot acquire lock mode on database objects while recovery is in progress](./cannot-acquire-lock-mode-on-database-objects-while-recovery-is-in-progress.md)

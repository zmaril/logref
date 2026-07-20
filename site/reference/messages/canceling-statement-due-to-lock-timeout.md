---
message: "canceling statement due to lock timeout"
slug: canceling-statement-due-to-lock-timeout
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_LOCK_NOT_AVAILABLE
    code: "55P03"
call_sites:
  - "postgres/src/backend/tcop/postgres.c:3607"
reproduced: false
---

# `canceling statement due to lock timeout`

## What it means

A statement waited for a lock longer than `lock_timeout` allows, so it was canceled. The lock-timeout setting bounds how long a statement will block waiting to acquire a lock.

## When it happens

It occurs when a statement blocks on a lock held by another transaction for longer than `lock_timeout`, for example an `ALTER TABLE` waiting behind a long-running query or an open transaction.

## How to fix

Identify the blocking transaction with `pg_locks` joined to `pg_stat_activity` and resolve it — commit, roll back, or end the session holding the lock. If the timeout is too tight for legitimate waits, raise `lock_timeout`; if you want to fail fast, keep it and retry when contention clears.

## Example

*Illustrative* — a statement giving up on a lock.

```text
ERROR:  canceling statement due to lock timeout
```

## Related

- [canceling statement due to statement timeout](./canceling-statement-due-to-statement-timeout.md)
- [canceling autovacuum task](./canceling-autovacuum-task.md)

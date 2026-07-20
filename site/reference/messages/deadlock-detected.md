---
message: "deadlock detected"
slug: deadlock-detected
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_T_R_DEADLOCK_DETECTED
    code: "40P01"
call_sites:
  - "postgres/src/backend/storage/lmgr/deadlock.c:1133"
reproduced: false
---

# `deadlock detected`

## What it means

The server detected a deadlock: two or more transactions were each waiting for a lock the others held, so none could proceed. To break the cycle, the server cancelled one of them. The one that received this error is the victim. The server reports it as a deadlock.

## When it happens

It happens when transactions acquire locks in conflicting orders — for example one updates row A then row B while another updates B then A — and their waits form a cycle. The deadlock detector notices after a short wait and aborts one transaction.

## How to fix

Retry the aborted transaction; deadlocks are expected under concurrency and are normally handled by retrying. To reduce them, have transactions acquire locks in a consistent order, keep transactions short, and lock rows in a predictable sequence. The `DETAIL` line shows which processes and locks were involved, which helps pinpoint the conflicting order.

## Example

*Illustrative* — two transactions locking rows in opposite order.

```text
ERROR:  deadlock detected
DETAIL:  Process 101 waits for ShareLock on transaction 500; blocked by process 102.
```

## Related

- [deadlock seems to have disappeared](./deadlock-seems-to-have-disappeared.md)
- [cursor is held from a previous transaction](./cursor-is-held-from-a-previous-transaction.md)

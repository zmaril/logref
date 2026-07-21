---
message: "cannot PREPARE a transaction that has executed LISTEN, UNLISTEN, or NOTIFY"
slug: cannot-prepare-a-transaction-that-has-executed-listen-unlisten-or-notify
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/async.c:1164"
reproduced: false
---

# `cannot PREPARE a transaction that has executed LISTEN, UNLISTEN, or NOTIFY`

## What it means

A `PREPARE TRANSACTION` was rejected because the transaction used the asynchronous notification commands `LISTEN`, `UNLISTEN`, or `NOTIFY`. Notification state is tied to the session and cannot be handed off to a prepared transaction that another session may later commit.

## When it happens

It occurs when a session runs `LISTEN`, `UNLISTEN`, or `NOTIFY` and then issues `PREPARE TRANSACTION`.

## How to fix

Keep notification commands out of transactions that use two-phase commit. Send notifications from a separate transaction, or commit the notifying transaction normally rather than preparing it.

## Example

*Illustrative* — PREPARE after NOTIFY.

```text
ERROR:  cannot PREPARE a transaction that has executed LISTEN, UNLISTEN, or NOTIFY
```

## Related

- [cannot PREPARE a transaction that has created a cursor WITH HOLD](./cannot-prepare-a-transaction-that-has-created-a-cursor-with-hold.md)
- [cannot send notifications from a parallel worker](./cannot-send-notifications-from-a-parallel-worker.md)

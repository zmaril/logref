---
message: "cannot execute new commands while WAL sender is in stopping mode"
slug: cannot-execute-new-commands-while-wal-sender-is-in-stopping-mode
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/replication/walsender.c:2117"
reproduced: false
---

# `cannot execute new commands while WAL sender is in stopping mode`

## What it means

A replication connection tried to run a new command after its WAL sender had entered stopping mode. Once shutdown begins, the WAL sender stops accepting new work so it can drain and exit cleanly.

## When it happens

It occurs when a replication client sends a command to a WAL sender that is already shutting down, for example during server shutdown or a smart-shutdown drain.

## How to fix

Reconnect after the server finishes shutting down and restarts, or direct the replication client to a server that is not stopping. This is expected during shutdown and needs no action beyond retrying against a running server.

## Example

*Illustrative* — a command sent to a stopping WAL sender.

```text
ERROR:  cannot execute new commands while WAL sender is in stopping mode
```

## Related

- [cannot execute SQL commands in WAL sender for physical replication](./cannot-execute-sql-commands-in-wal-sender-for-physical-replication.md)
- [cannot execute during recovery](./cannot-execute-during-recovery.md)

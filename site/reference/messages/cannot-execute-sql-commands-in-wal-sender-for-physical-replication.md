---
message: "cannot execute SQL commands in WAL sender for physical replication"
slug: cannot-execute-sql-commands-in-wal-sender-for-physical-replication
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/replication/walsender.c:2171"
reproduced: false
---

# `cannot execute SQL commands in WAL sender for physical replication`

## What it means

A SQL command arrived on a replication connection that was opened for physical replication. Physical-replication connections speak the replication protocol, not general SQL, so the command is rejected.

## When it happens

It occurs when a client opens a physical replication connection (`replication=true`) and then sends an ordinary SQL statement. Only logical-replication connections accept SQL.

## How to fix

Use a normal connection for SQL. Open the replication connection for its protocol commands only, or connect with `replication=database` if you need the logical-replication mode that permits SQL.

## Example

*Illustrative* — SQL sent on a physical replication connection.

```text
ERROR:  cannot execute SQL commands in WAL sender for physical replication
```

## Related

- [cannot execute new commands while WAL sender is in stopping mode](./cannot-execute-new-commands-while-wal-sender-is-in-stopping-mode.md)
- [cannot execute during recovery](./cannot-execute-during-recovery.md)

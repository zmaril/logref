---
message: "canceling the wait for synchronous replication and terminating connection due to administrator command"
slug: canceling-the-wait-for-synchronous-replication-and-terminating-connection-due
passthrough: false
api: [ereport]
level: [WARNING]
sqlstate:
  - symbol: ERRCODE_ADMIN_SHUTDOWN
    code: "57P01"
call_sites:
  - "postgres/src/backend/replication/syncrep.c:304"
  - "postgres/src/backend/replication/syncrep.c:312"
reproduced: false
---

# `canceling the wait for synchronous replication and terminating connection due to administrator command`

## What it means

A backend waiting for synchronous replication acknowledgement is being terminated by an administrator command, so it stops waiting and ends the connection.

## When it happens

It arises when a fast shutdown or a backend-termination request reaches a session that is blocked waiting for a synchronous standby to confirm a commit.

## Is this a problem?

This reports an administrative action, not a fault. The commit's local durability is unaffected, but the client did not receive confirmation of standby acknowledgement; the client should treat the transaction's outcome as unknown and re-check after reconnecting.

## Example

*Illustrative* — terminating a synchronous-replication wait.

```text
WARNING:  canceling the wait for synchronous replication and terminating connection due to administrator command
```

## Related

- [unexpected EOF on standby connection](./unexpected-eof-on-standby-connection.md)
- [recovery has paused](./recovery-has-paused.md)

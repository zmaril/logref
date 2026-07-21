---
message: "error while shutting down streaming COPY: %s"
slug: error-while-shutting-down-streaming-copy
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_CONNECTION_FAILURE
    code: "08006"
call_sites:
  - "postgres/src/backend/replication/libpqwalreceiver/libpqwalreceiver.c:708"
reproduced: false
---

# `error while shutting down streaming COPY: %s`

## What it means

A walreceiver was ending a streaming replication `COPY` stream and the underlying connection reported an error while closing it. The placeholder carries the connection-library message.

## When it happens

It fires on a standby (or a logical-replication subscriber) when the replication connection to the upstream breaks as the stream is being torn down — for example the primary closed the socket, the network dropped, or the upstream terminated the walsender.

## How to fix

Treat this as a broken replication connection. Check network health between standby and primary, look at the primary's log for a walsender exit, and confirm the primary is still running and reachable. Replication normally reconnects on its own; if it does not, verify `primary_conninfo`, authentication, and that a replication slot still exists.

## Example

*Illustrative* — the upstream dropped the connection mid-stream.

```
error while shutting down streaming COPY: server closed the connection unexpectedly
```

## Related

- [exiting from slot synchronization because same name slot already exists on the standby](./exiting-from-slot-synchronization-because-same-name-slot-already-exists-on-the.md)
- [extended query protocol not supported in a replication connection](./extended-query-protocol-not-supported-in-a-replication-connection.md)

---
message: "could not receive database system identifier and timeline ID from the primary server: %s"
slug: could-not-receive-database-system-identifier-and-timeline-id-from-the-primary
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_PROTOCOL_VIOLATION
    code: "08P01"
call_sites:
  - "postgres/src/backend/replication/libpqwalreceiver/libpqwalreceiver.c:437"
reproduced: false
---

# `could not receive database system identifier and timeline ID from the primary server: %s`

## What it means

A standby's WAL receiver connected to the primary but did not get back the database system identifier and current timeline it asked for. The trailing text is the server's reply. The server flags this as a protocol violation.

## When it happens

It fires early in streaming replication when the standby runs `IDENTIFY_SYSTEM` against the primary and the reply is missing or malformed — usually a broken connection, or a peer that is not a compatible Postgres primary.

## How to fix

Confirm the standby's `primary_conninfo` points at a real Postgres primary that accepts replication connections, and that the network path is stable. Check the primary's log for a rejected or dropped replication connection. A version or configuration mismatch on the replication protocol also produces this.

## Example

*Illustrative* — the identify handshake returned nothing usable.

```text
ERROR:  could not receive database system identifier and timeline ID from the primary server: server closed the connection unexpectedly
```

## Related

- [could not receive timeline history file from the primary server](./could-not-receive-timeline-history-file-from-the-primary-server.md)
- [could not start WAL streaming](./could-not-start-wal-streaming.md)

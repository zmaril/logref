---
message: "could not receive data from WAL stream: %s"
slug: could-not-receive-data-from-wal-stream
passthrough: false
api: [ereport, pg_log_error]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_CONNECTION_FAILURE
    code: "08006"
  - symbol: ERRCODE_PROTOCOL_VIOLATION
    code: "08P01"
call_sites:
  - "postgres/src/backend/replication/libpqwalreceiver/libpqwalreceiver.c:817"
  - "postgres/src/backend/replication/libpqwalreceiver/libpqwalreceiver.c:870"
  - "postgres/src/backend/replication/libpqwalreceiver/libpqwalreceiver.c:876"
  - "postgres/src/bin/pg_basebackup/pg_recvlogical.c:441"
  - "postgres/src/bin/pg_basebackup/receivelog.c:973"
reproduced: false
---

# `could not receive data from WAL stream: %s`

## What it means

A WAL receiver (streaming replication standby, or a logical replication apply worker) failed while reading WAL from its upstream connection. The placeholder is the connection-level error text. The replication link was interrupted mid-stream.

## When it happens

The primary/publisher went away, the network dropped, a timeout fired, or the upstream reported a protocol error while streaming WAL to a standby or subscriber.

## How to fix

Read the included error text — it distinguishes a network drop from a server-side problem. Check connectivity and firewall between standby and primary, the primary's health and `max_wal_senders`, and timeout settings (`wal_receiver_timeout`). Streaming normally reconnects automatically; persistent failures point to a network or upstream-availability issue.

## Example

*Illustrative* — a dropped replication connection.

```text
ERROR:  could not receive data from WAL stream: server closed the connection unexpectedly
```

## Related

- [could not establish connection](./could-not-establish-connection.md)
- [could not read COPY data](./could-not-read-copy-data.md)

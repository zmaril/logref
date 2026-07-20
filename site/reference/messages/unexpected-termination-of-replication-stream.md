---
message: "unexpected termination of replication stream: %s"
slug: unexpected-termination-of-replication-stream
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_recvlogical.c:642"
  - "postgres/src/bin/pg_basebackup/receivelog.c:648"
  - "postgres/src/bin/pg_basebackup/receivelog.c:685"
reproduced: false
---

# `unexpected termination of replication stream: %s`

## What it means

A replication client's connection to the stream ended unexpectedly. A streaming or logical replication reader was consuming data when the stream closed without the orderly end it expected. The message carries the underlying detail.

## When it happens

The upstream server closed the connection, the network dropped, the server was shut down or restarted, or an error on the sending side ended the walsender. Tools like pg_recvlogical and pg_basebackup's log receiver report it when their stream is cut.

## How to fix

Read the detail for the specific cause, then address it: check upstream server health and logs, network stability, and whether the server restarted. Most streaming clients can reconnect and resume from the last confirmed position, so ensure the client retries and that the needed WAL or slot is retained upstream.

## Example

*Illustrative* — a replication stream cut short.

```text
ERROR:  unexpected termination of replication stream: server closed the connection
```

## Related

- [requested wal segment has already been removed](./requested-wal-segment-has-already-been-removed.md)
- [logical replication column not found in tuple only column s received](./logical-replication-column-not-found-in-tuple-only-column-s-received.md)

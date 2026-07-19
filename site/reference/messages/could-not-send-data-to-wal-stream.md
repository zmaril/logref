---
message: "could not send data to WAL stream: %s"
slug: could-not-send-data-to-wal-stream
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_CONNECTION_FAILURE
    code: "08006"
call_sites:
  - "postgres/src/backend/replication/libpqwalreceiver/libpqwalreceiver.c:896"
reproduced: false
---

# `could not send data to WAL stream: %s`

## What it means

A WAL receiver could not send data back to the primary over its replication connection. The server flags this as a connection failure and includes the underlying reason. Standbys send feedback (such as flush positions) upstream.

## When it happens

It fires on a standby when the WAL receiver writes to the primary — sending status feedback or a reply — and the send fails, meaning the replication connection has broken.

## How to fix

Check the network path between the standby and the primary and both servers' logs. A dropped connection, a primary restart, or a firewall timeout is the usual cause. The standby will typically reconnect on its own; if it does not, restart replication after fixing the connectivity problem.

## Example

*Illustrative* — feedback to the primary could not be sent.

```text
ERROR:  could not send data to WAL stream: connection reset
```

## Related

- [could not send end-of-streaming message to primary](./could-not-send-end-of-streaming-message-to-primary.md)
- [could not start WAL streaming](./could-not-start-wal-streaming.md)

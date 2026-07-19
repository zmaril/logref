---
message: "could not send end-of-streaming message to primary: %s"
slug: could-not-send-end-of-streaming-message-to-primary
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_CONNECTION_FAILURE
    code: "08006"
call_sites:
  - "postgres/src/backend/replication/libpqwalreceiver/libpqwalreceiver.c:668"
reproduced: false
---

# `could not send end-of-streaming message to primary: %s`

## What it means

A standby's WAL receiver could not tell the primary it is ending WAL streaming. The server flags this as a connection failure and includes the reason. This handshake lets a standby stop streaming cleanly, for example to switch timelines.

## When it happens

It fires when the WAL receiver tries to end streaming — often as part of following a timeline switch — and the message to the primary cannot be sent because the connection is broken.

## How to fix

Check connectivity to the primary and both logs. The standby will normally reconnect and continue; a persistent failure points at a network problem or a primary that is down. Resolve the connectivity issue and let replication resume.

## Example

*Illustrative* — the end-of-streaming message failed.

```text
ERROR:  could not send end-of-streaming message to primary: connection reset
```

## Related

- [could not send data to WAL stream](./could-not-send-data-to-wal-stream.md)
- [could not start WAL streaming](./could-not-start-wal-streaming.md)

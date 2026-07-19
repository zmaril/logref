---
message: "disconnected"
slug: disconnected
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_receivewal.c:918"
  - "postgres/src/bin/pg_basebackup/pg_recvlogical.c:1039"
reproduced: false
---

# `disconnected`

## What it means

A streaming client (`pg_receivewal` or `pg_recvlogical`) lost its connection to the server. The tool reports the disconnect and stops the current stream.

## When it happens

The server closed the connection, restarted, or the network dropped while the tool streamed WAL or logical changes.

## How to fix

Check server availability and network stability. Restart the tool; it resumes from its last confirmed position. Persistent disconnects point at the server or the network path.

## Example

*Illustrative* — the streaming connection dropped.

```text
pg_receivewal: error: disconnected
```

## Related

- [could not send feedback packet](./could-not-send-feedback-packet.md)
- [could not receive data from client](./could-not-receive-data-from-client.md)

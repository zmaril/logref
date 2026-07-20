---
message: "error reading result of streaming command: %s"
slug: error-reading-result-of-streaming-command
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_PROTOCOL_VIOLATION
    code: "08P01"
call_sites:
  - "postgres/src/backend/replication/libpqwalreceiver/libpqwalreceiver.c:719"
reproduced: false
---

# `error reading result of streaming command: %s`

## What it means

The walreceiver failed to read the result of a streaming replication command from the upstream server. The placeholder is the error text. The replication connection returned an error or broke while a command was in flight.

## When it happens

It fires on a standby or logical subscriber while running a replication protocol command (such as starting streaming), when the upstream connection fails or reports an error.

## How to fix

Check both servers' logs for the underlying cause — a network drop, an upstream crash, or a configuration mismatch. Confirm connectivity and the replication user's permissions. The connection is normally retried; if it loops, resolve the upstream error the message reports.

## Example

*Illustrative* — a streaming command result failure.

```text
ERROR:  error reading result of streaming command: ...
```

## Related

- [duplicate STREAM START message](./duplicate-stream-start-message.md)
- [empty COPY message](./empty-copy-message.md)

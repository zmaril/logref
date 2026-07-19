---
message: "duplicate STREAM START message"
slug: duplicate-stream-start-message
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_PROTOCOL_VIOLATION
    code: "08P01"
call_sites:
  - "postgres/src/backend/replication/logical/worker.c:1752"
reproduced: false
---

# `duplicate STREAM START message`

## What it means

A logical-replication apply worker received a second `STREAM START` message without an intervening `STREAM STOP`. The replication protocol interleaves streamed in-progress transactions, and a start must not repeat before its stop. This signals a protocol violation on the stream.

## When it happens

It fires on the subscriber's apply worker when streamed (in-progress) transaction messages arrive out of order, which points at a bug or a corrupted replication stream rather than user SQL.

## How to fix

This is a protocol-level fault, not a user query error. Check that publisher and subscriber are compatible versions. Look for network or WAL-stream corruption. The subscription usually retries; if it loops, capture both servers' logs and versions for the PostgreSQL developers.

## Example

*Illustrative* — the protocol violation as logged.

```text
ERROR:  duplicate STREAM START message
```

## Related

- [end_lsn is not set in commit prepared message](./end-lsn-is-not-set-in-commit-prepared-message.md)
- [error reading result of streaming command](./error-reading-result-of-streaming-command.md)

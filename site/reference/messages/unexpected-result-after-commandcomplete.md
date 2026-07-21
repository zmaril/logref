---
message: "unexpected result after CommandComplete: %s"
slug: unexpected-result-after-commandcomplete
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_PROTOCOL_VIOLATION
    code: "08P01"
call_sites:
  - "postgres/src/backend/replication/libpqwalreceiver/libpqwalreceiver.c:729"
  - "postgres/src/backend/replication/libpqwalreceiver/libpqwalreceiver.c:856"
reproduced: false
---

# `unexpected result after CommandComplete: %s`

## What it means

On a client protocol connection the server received a further result message after a command had already signalled completion, which the protocol does not allow at that point.

## When it happens

It arises from internal libpq-driven paths (parallel query, `postgres_fdw`, replication) when the message stream desynchronizes — often after a connection was disrupted or a lower-level error was mishandled.

## How to fix

Treat it as a symptom of a broken or out-of-step connection. Look for an earlier network error or server termination on that link; if it recurs with a specific driver or foreign server, capture the sequence and report it.

## Example

*Illustrative* — an extra result after completion.

```text
ERROR:  unexpected result after CommandComplete: I
```

## Related

- [unexpected PQresultStatus: %d](./unexpected-pqresultstatus.md)
- [unexpected message type 0x%02X during COPY from stdin](./unexpected-message-type-0x-during-copy-from-stdin.md)

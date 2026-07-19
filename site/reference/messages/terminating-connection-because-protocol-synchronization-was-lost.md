---
message: "terminating connection because protocol synchronization was lost"
slug: terminating-connection-because-protocol-synchronization-was-lost
passthrough: false
api: [ereport]
level: [FATAL]
sqlstate:
  - symbol: ERRCODE_PROTOCOL_VIOLATION
    code: "08P01"
call_sites:
  - "postgres/src/backend/libpq/pqcomm.c:1149"
  - "postgres/src/backend/tcop/postgres.c:4683"
reproduced: false
---

# `terminating connection because protocol synchronization was lost`

## What it means

The server closed a connection because it could no longer make sense of the message stream from the client — the wire protocol got out of sync. Once framing is lost, the server cannot safely continue, so it terminates the session.

## When it happens

It arises from a client/driver bug that sends malformed protocol messages, a mid-message disconnect, encryption/proxy corruption of the stream, or something speaking non-Postgres traffic to the port.

## How to fix

Investigate the client library and any proxy/middlebox in the path. Update or fix the driver, remove stream-altering intermediaries, and ensure only genuine Postgres protocol traffic reaches the port. Reproduce with a minimal client to isolate the offending message.

## Example

*Illustrative* — the server dropping a desynchronized connection.

```text
FATAL:  terminating connection because protocol synchronization was lost
```

## Related

- [SSL error: %s](./ssl-error.md)
- [terminating connection due to unexpected postmaster exit](./terminating-connection-due-to-unexpected-postmaster-exit.md)

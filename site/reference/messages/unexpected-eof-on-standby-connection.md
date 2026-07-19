---
message: "unexpected EOF on standby connection"
slug: unexpected-eof-on-standby-connection
passthrough: false
api: [ereport]
level: [COMMERROR]
sqlstate:
  - symbol: ERRCODE_PROTOCOL_VIOLATION
    code: "08P01"
call_sites:
  - "postgres/src/backend/replication/walsender.c:2370"
  - "postgres/src/backend/replication/walsender.c:2405"
reproduced: false
---

# `unexpected EOF on standby connection`

## What it means

The primary was streaming to a standby (or a client on the replication protocol) and the connection closed without the orderly termination message the protocol expects.

## When it happens

It is logged when a walreceiver or replication client disconnects abruptly — the standby was stopped, the network dropped, or the process was killed mid-stream.

## How to fix

This is a communication-level log entry, not a query error. If the standby restarts and reconnects it is transient. Investigate the network or the standby's health when it repeats, since streaming replication will keep retrying.

## Example

*Illustrative* — a standby dropping its replication connection.

```text
LOG:  unexpected EOF on standby connection
```

## Related

- [unexpected EOF in COPY data](./unexpected-eof-in-copy-data.md)
- [WAL required by replication slot %s has been removed concurrently](./wal-required-by-replication-slot-has-been-removed-concurrently.md)

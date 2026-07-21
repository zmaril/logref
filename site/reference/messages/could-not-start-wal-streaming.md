---
message: "could not start WAL streaming: %s"
slug: could-not-start-wal-streaming
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_PROTOCOL_VIOLATION
    code: "08P01"
call_sites:
  - "postgres/src/backend/replication/libpqwalreceiver/libpqwalreceiver.c:645"
reproduced: true
---

# `could not start WAL streaming: %s`

## What it means

A standby's WAL receiver could not start streaming write-ahead log from the primary. The trailing text is the server's reply. The server flags this as a protocol violation. This is the command that begins continuous replication.

## When it happens

It fires when the standby sends `START_REPLICATION` to the primary and the primary refuses or replies unexpectedly — a requested position the primary no longer has, a slot problem, or a version or configuration mismatch.

## How to fix

Check the primary's log for why it rejected the stream. Common causes are a requested WAL position that has already been recycled (the standby has fallen too far behind), a missing or invalid replication slot, or `max_wal_senders` exhausted on the primary. Address the reported cause; a standby that is too far behind may need rebuilding.

## Example

*Reproduced* — this site fired under `reproducers/scenarios/58_repl_physical.sh`; see the reproducer for the triggering workload. It emits:

```text
ERROR:  could not start WAL streaming: %s
```

## Related

- [could not receive database system identifier and timeline ID from the primary server](./could-not-receive-database-system-identifier-and-timeline-id-from-the-primary.md)
- [could not send data to WAL stream](./could-not-send-data-to-wal-stream.md)

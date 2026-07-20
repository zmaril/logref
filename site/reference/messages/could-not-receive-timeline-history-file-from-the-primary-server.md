---
message: "could not receive timeline history file from the primary server: %s"
slug: could-not-receive-timeline-history-file-from-the-primary-server
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_PROTOCOL_VIOLATION
    code: "08P01"
call_sites:
  - "postgres/src/backend/replication/libpqwalreceiver/libpqwalreceiver.c:756"
reproduced: false
---

# `could not receive timeline history file from the primary server: %s`

## What it means

A standby asked the primary for a timeline history file and did not receive it. Timeline history files describe where the log branched, and a standby needs them to follow the primary across timeline switches. The server flags this as a protocol violation.

## When it happens

It fires during streaming replication when the standby requests a `.history` file for a timeline and the primary's reply is missing or malformed — often a dropped connection or a primary that no longer has that history.

## How to fix

Confirm the connection to the primary is stable and that the primary still has the requested timeline history. If the standby has diverged far from the primary's timeline lineage, it may need to be rebuilt from a fresh base backup. Check both servers' logs for the surrounding replication activity.

## Example

*Illustrative* — the history file was not received.

```text
ERROR:  could not receive timeline history file from the primary server: connection reset
```

## Related

- [could not receive database system identifier and timeline ID from the primary server](./could-not-receive-database-system-identifier-and-timeline-id-from-the-primary.md)
- [could not start WAL streaming](./could-not-start-wal-streaming.md)

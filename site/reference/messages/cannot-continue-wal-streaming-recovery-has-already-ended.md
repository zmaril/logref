---
message: "cannot continue WAL streaming, recovery has already ended"
slug: cannot-continue-wal-streaming-recovery-has-already-ended
passthrough: false
api: [ereport]
level: [FATAL]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/replication/walreceiver.c:448"
reproduced: false
---

# `cannot continue WAL streaming, recovery has already ended`

## What it means

The WAL receiver was asked to continue streaming write-ahead log, but recovery on this server has already ended — the server was promoted or reached the end of its recovery target. With recovery over, there is no consistent point to keep streaming into.

## When it happens

It occurs on a standby around promotion, when a streaming request arrives after the server has finished recovery.

## How to fix

This is expected around promotion and needs no action if the server was intentionally promoted. If it appears unexpectedly, review the promotion trigger and recovery-target settings to confirm the server ended recovery when intended.

## Example

*Illustrative* — streaming after recovery ended.

```text
FATAL:  cannot continue WAL streaming, recovery has already ended
```

## Related

- [cannot create temporary tables during recovery](./cannot-create-temporary-tables-during-recovery.md)
- [cannot connect to invalid database](./cannot-connect-to-invalid-database.md)

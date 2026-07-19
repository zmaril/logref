---
message: "could not write to WAL segment %s at offset %d, length %d: %m"
slug: could-not-write-to-wal-segment-at-offset-length
passthrough: false
api: [ereport]
level: [PANIC]
call_sites:
  - "postgres/src/backend/replication/walreceiver.c:969"
reproduced: false
---

# `could not write to WAL segment %s at offset %d, length %d: %m`

## What it means

A WAL receiver on a standby could not write streamed write-ahead log to a segment file. The placeholders are the segment, the offset, and the length, and the trailing text is the operating-system error. This is reported as a PANIC because the standby cannot safely continue.

## When it happens

It fires on a standby while the WAL receiver writes incoming WAL to `pg_wal`, when the write fails — a full disk or an I/O error on the standby's storage.

## How to fix

Read the OS error. `No space left on device` on the standby's `pg_wal` filesystem must be cleared immediately; an I/O error means the storage is failing. The standby will restart and reconnect; ensure it has room and healthy storage for incoming WAL to prevent repeated panics.

## Example

*Illustrative* — a standby WAL write panicked.

```text
PANIC:  could not write to WAL segment 000000010000000000000031 at offset 8192, length 8192: No space left on device
```

## Related

- [could not write to log file at offset, length](./could-not-write-to-log-file-at-offset-length.md)
- [could not write bytes to WAL file](./could-not-write-bytes-to-wal-file.md)

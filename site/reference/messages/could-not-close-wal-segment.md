---
message: "could not close WAL segment %s: %m"
slug: could-not-close-wal-segment
passthrough: false
api: [ereport]
level: [PANIC]
call_sites:
  - "postgres/src/backend/replication/walreceiver.c:641"
  - "postgres/src/backend/replication/walreceiver.c:1096"
reproduced: false
---

# `could not close WAL segment %s: %m`

## What it means

PANIC-level error. The WAL receiver could not close a WAL segment file. The placeholders are the segment name and the system reason. A failure to close (which flushes and releases the file) during WAL handling is treated as fatal to protect durability.

## When it happens

On a standby's WAL receiver when the underlying storage errors while closing a completed WAL segment — a disk fault, a full or failing filesystem, or an I/O error.

## How to fix

Treat it as a storage-level fault. The process PANICs and restarts; investigate the disk holding `pg_wal` for errors, free space, and hardware health. Fix the storage problem before the standby can reliably continue receiving WAL. Preserve the log detail for diagnosis.

## Example

*Illustrative* — a WAL segment that could not be closed.

```text
PANIC:  could not close WAL segment 000000010000000000000009: Input/output error
```

## Related

- [could not find redo location referenced by checkpoint record at](./could-not-find-redo-location-referenced-by-checkpoint-record-at.md)
- [cannot make new WAL entries during recovery](./cannot-make-new-wal-entries-during-recovery.md)

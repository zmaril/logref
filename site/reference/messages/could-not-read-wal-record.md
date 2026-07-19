---
message: "could not read WAL record"
slug: could-not-read-wal-record
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATA_CORRUPTED
    code: "XX001"
call_sites:
  - "postgres/src/backend/commands/repack_worker.c:427"
reproduced: false
---

# `could not read WAL record`

## What it means

Code that walks the write-ahead log to redo work could not read the next record. This particular site backs an online table-rebuild worker that replays WAL, and the server flags the failure as data corruption.

## When it happens

It fires when the WAL reader hits a record it cannot decode — a bad length, a checksum failure, or a truncated segment — while the worker is following the log.

## How to fix

Treat this as damaged WAL. Preserve the log for analysis, and check the storage under `pg_wal` for I/O errors or silent truncation. Where the operation can be retried from a known-good point, do so after confirming the WAL is intact. The trailing context earlier in the log identifies the exact record.

## Example

*Illustrative* — a WAL record would not decode.

```text
ERROR:  could not read WAL record
```

## Related

- [could not read from WAL segment](./could-not-read-from-wal-segment-offset.md)
- [could not read WAL at LSN](./could-not-read-wal-at-lsn.md)

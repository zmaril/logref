---
message: "could not write to log file \"%s\" at offset %u, length %zu: %m"
slug: could-not-write-to-log-file-at-offset-length
passthrough: false
api: [ereport]
level: [PANIC]
call_sites:
  - "postgres/src/backend/access/transam/xlog.c:2470"
reproduced: false
---

# `could not write to log file "%s" at offset %u, length %zu: %m`

## What it means

The server could not write to a write-ahead log file at a given offset and length. The placeholders are the file, the offset, and the length, and the trailing text is the operating-system error. This is a core WAL write, reported as a PANIC because durability cannot be guaranteed.

## When it happens

It fires when the server flushes WAL to a segment file and the write fails — a full disk, or an I/O error on the storage holding `pg_wal`. A failed WAL write is unrecoverable in place, so the server panics and restarts.

## How to fix

This is a serious storage problem. Read the OS error: `No space left on device` on the `pg_wal` filesystem must be resolved immediately by freeing space, and an I/O error means the storage is failing. The server will restart and recover; ensure `pg_wal` has room and healthy storage to avoid repeated panics.

## Example

*Illustrative* — a WAL write panicked.

```text
PANIC:  could not write to log file "000000010000000000000031" at offset 8192, length 8192: No space left on device
```

## Related

- [could not write to WAL segment at offset, length](./could-not-write-to-wal-segment-at-offset-length.md)
- [could not write to log file](./could-not-write-to-log-file-8d5e1f.md)

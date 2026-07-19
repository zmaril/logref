---
message: "could not read from WAL segment %s, offset %d: %m"
slug: could-not-read-from-wal-segment-offset
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/transam/xlogutils.c:1057"
reproduced: false
---

# `could not read from WAL segment %s, offset %d: %m`

## What it means

The server tried to read a stretch of write-ahead log from a segment file on disk and the read failed. The first placeholder is the segment file, the second the byte offset, and the trailing text is the operating-system error.

## When it happens

It happens when the WAL reader needs an older record — during recovery, logical decoding, or a WAL-inspection function — and the read syscall against the segment fails. Common causes are a removed or truncated segment, or an I/O error on the storage holding `pg_wal`.

## How to fix

Read the OS error. `No such file or directory` means the segment was recycled or archived away; make sure `pg_wal` still holds the range you need, and restore it from the archive if it does not. A hardware error points at failing storage — check the kernel log and the disk's health. If the segment is present but short, it may be corrupt.

## Example

*Illustrative* — the WAL reader could not read a segment.

```text
ERROR:  could not read from WAL segment 000000010000000000000031, offset 8192: Input/output error
```

## Related

- [could not read from WAL segment (short read)](./could-not-read-from-wal-segment-offset-read-of.md)
- [could not read WAL record](./could-not-read-wal-record.md)

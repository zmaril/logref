---
message: "could not read from WAL segment %s, offset %d: read %d of %d"
slug: could-not-read-from-wal-segment-offset-read-of
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATA_CORRUPTED
    code: "XX001"
call_sites:
  - "postgres/src/backend/access/transam/xlogutils.c:1064"
reproduced: false
---

# `could not read from WAL segment %s, offset %d: read %d of %d`

## What it means

A read of a write-ahead log segment returned fewer bytes than requested with no OS error — a short read. The message reports the segment, the offset, and how many bytes actually arrived versus how many were asked for. The server flags this as data corruption.

## When it happens

It fires when the WAL reader reaches the end of a segment sooner than its metadata says it should, which usually means the segment on disk is truncated or damaged rather than a transient I/O fault.

## How to fix

Treat this as a corrupt or truncated WAL segment. If the range is still available from your archive, restore the intact segment. On a standby, re-fetching from the primary or rebuilding the standby is the clean path. Investigate the storage for silent truncation, and keep the damaged file for analysis before overwriting it.

## Example

*Illustrative* — the segment ended earlier than expected.

```text
ERROR:  could not read from WAL segment 000000010000000000000031, offset 8192: read 0 of 8192
```

## Related

- [could not read from WAL segment](./could-not-read-from-wal-segment-offset.md)
- [could not read WAL record](./could-not-read-wal-record.md)

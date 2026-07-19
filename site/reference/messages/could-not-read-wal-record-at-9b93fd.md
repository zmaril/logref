---
message: "could not read WAL record at %X/%08X: %s"
slug: could-not-read-wal-record-at-9b93fd
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_rewind/parsexlog.c:92"
  - "postgres/src/bin/pg_rewind/parsexlog.c:146"
reproduced: false
---

# `could not read WAL record at %X/%08X: %s`

## What it means

`pg_rewind` could not read a WAL record at a position, and captured the reader's detail. The `%X/%08X` is the LSN and the `%s` is the error text. It could not decode the record it needed.

## When it happens

The WAL segment was missing or recycled, the record was corrupt, or an I/O error occurred while `pg_rewind` scanned WAL history.

## How to fix

Read the trailing detail. Retain the WAL spanning the divergence point so `pg_rewind` can read it; if it has been recycled or is damaged, fall back to a new base backup.

## Example

*Illustrative* — a corrupt WAL record during rewind.

```text
pg_rewind: error: could not read WAL record at 0/3000000: invalid record length
```

## Related

- [could not read WAL record at](./could-not-read-wal-record-at-1d145f.md)
- [could not locate backup block with ID in WAL record](./could-not-locate-backup-block-with-id-in-wal-record.md)

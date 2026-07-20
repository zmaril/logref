---
message: "could not read WAL record at %X/%08X"
slug: could-not-read-wal-record-at-1d145f
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_rewind/parsexlog.c:96"
  - "postgres/src/bin/pg_rewind/parsexlog.c:149"
reproduced: false
---

# `could not read WAL record at %X/%08X`

## What it means

`pg_rewind` could not read a WAL record at a position while tracing history. The `%X/%08X` is the LSN. Without the record it cannot compute the divergence point.

## When it happens

The required WAL was missing from the source or target, a segment had been recycled, or the WAL was damaged, while `pg_rewind` read history around the divergence.

## How to fix

Ensure the WAL that spans the divergence point is available on the cluster `pg_rewind` reads (retain it via archiving or a slot). If WAL was recycled, `pg_rewind` may not be possible; use a fresh base backup instead.

## Example

*Illustrative* — required WAL was missing during rewind.

```text
pg_rewind: error: could not read WAL record at 0/3000000
```

## Related

- [could not read WAL record at](./could-not-read-wal-record-at-9b93fd.md)
- [could not open source file](./could-not-open-source-file.md)

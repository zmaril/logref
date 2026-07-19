---
message: "could not write file \"%s\": wrote only %d of %d bytes at offset %lld"
slug: could-not-write-file-wrote-only-of-bytes-at-offset-65a074
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/backup/walsummary.c:307"
reproduced: false
---

# `could not write file "%s": wrote only %d of %d bytes at offset %lld`

## What it means

The WAL-summary writer could not fully write a file. The placeholders are the file, the bytes actually written, the bytes expected, and the offset — a short write. WAL summaries feed incremental backups.

## When it happens

It fires in the background WAL summarizer while it writes a summary file, when the write returns fewer bytes than requested, typically because the filesystem is full.

## How to fix

A short write usually means the disk is full. Free space on the storage holding the WAL-summaries directory. If it recurs with space available, check the storage for I/O errors. Failing summary writes can stall incremental backups.

## Example

*Illustrative* — a summary file write came up short.

```text
ERROR:  could not write file "pg_wal/summaries/0000000100000000000000000100000001000010D0.summary": wrote only 512 of 8192 bytes at offset 0
```

## Related

- [could not read WAL from timeline at](./could-not-read-wal-from-timeline-at-9a0c21.md)
- [could not write to file, wrote N of M](./could-not-write-to-file-wrote-of.md)

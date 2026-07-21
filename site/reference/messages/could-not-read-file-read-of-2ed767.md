---
message: "could not read file \"%s\": read %d of %lld"
slug: could-not-read-file-read-of-2ed767
passthrough: false
api: [ereport, pg_fatal]
level: [ERROR, FATAL]
call_sites:
  - "postgres/src/backend/access/transam/twophase.c:1369"
  - "postgres/src/bin/pg_combinebackup/load_manifest.c:163"
  - "postgres/src/bin/pg_verifybackup/pg_verifybackup.c:457"
reproduced: false
---

# `could not read file "%s": read %d of %lld`

## What it means

A read returned fewer bytes than requested, so the file could not be fully read. The placeholders are the file name, the number of bytes actually read, and the number expected. A short read at a point where the full length was expected means the file is truncated or an I/O error occurred mid-read.

## When it happens

A truncated file (an incomplete WAL segment, a partial two-phase state file, a cut-off data file), a disk/network I/O error, or the file being changed underneath the reader.

## How to fix

Read the byte counts to see how far it got. A truncated WAL or state file usually means the file is incomplete — restore it from the archive/backup. Check storage health if the read errored rather than hit EOF. For two-phase state files, a missing/short file can leave an orphaned prepared transaction to resolve. Investigate the specific file named.

## Example

*Illustrative* — a short read on a state file.

```text
ERROR:  could not read file "pg_twophase/0000001A": read 40 of 8192
```

## Related

- [could not find WAL file](./could-not-find-wal-file.md)
- [could not close file](./could-not-close-file-62a3f1.md)

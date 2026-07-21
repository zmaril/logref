---
message: "could not fsync file \"%s\": %s"
slug: could-not-fsync-file-5db846
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_basebackup/receivelog.c:781"
  - "postgres/src/bin/pg_basebackup/receivelog.c:1036"
reproduced: false
---

# `could not fsync file "%s": %s`

## What it means

A client tool could not flush a file's contents to durable storage with `fsync`. The first `%s` is the file path and the second is the operating-system error. The data may not be safely on disk.

## When it happens

It fires in `pg_basebackup`/`pg_receivewal` while syncing received files, when the filesystem returns an I/O error, the device is full or read-only, or the storage was lost mid-run.

## How to fix

Read the trailing error. Confirm the target device is healthy, writable, and has free space, then rerun. A persistent `fsync` failure usually means failing hardware — do not trust a backup written to it.

## Example

*Illustrative* — the backup device reported an I/O error on flush.

```text
pg_basebackup: error: could not fsync file "base/16384/2619": Input/output error
```

## Related

- [could not synchronize file system for file](./could-not-synchronize-file-system-for-file.md)
- [could not finish writing WAL files](./could-not-finish-writing-wal-files.md)

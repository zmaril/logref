---
message: "could not finish writing WAL files: %m"
slug: could-not-finish-writing-wal-files
passthrough: false
api: [pg_log_error, pg_log_info]
level: [ERROR, INFO]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:597"
  - "postgres/src/bin/pg_basebackup/pg_receivewal.c:600"
reproduced: false
---

# `could not finish writing WAL files: %m`

## What it means

A client tool (`pg_basebackup` or `pg_receivewal`) could not complete writing the WAL segments it was streaming. The `%m` carries the operating-system error from the final flush or close.

## When it happens

The destination filled up, the disk returned an I/O error, or the target filesystem was unmounted or lost while the tool finished the WAL stream at the end of a run.

## How to fix

Read the trailing `%m` for the real cause. Ensure the WAL target directory has free space and stable storage, then rerun. If the underlying medium is failing, move the target to healthy storage.

## Example

*Illustrative* — the WAL destination ran out of room during flush.

```text
pg_basebackup: error: could not finish writing WAL files: No space left on device
```

## Related

- [could not write bytes to log file](./could-not-write-bytes-to-log-file.md)
- [could not fsync file](./could-not-fsync-file-5db846.md)

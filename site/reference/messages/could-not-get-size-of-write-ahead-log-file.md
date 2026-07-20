---
message: "could not get size of write-ahead log file \"%s\": %s"
slug: could-not-get-size-of-write-ahead-log-file
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_basebackup/receivelog.c:122"
reproduced: false
---

# `could not get size of write-ahead log file "%s": %s`

## What it means

While streaming WAL, `pg_basebackup` (or `pg_receivewal`) tried to read the size of a WAL segment on the destination and the operating system call failed. The `%s` value gives the reason. It checks segment sizes to resume or pad partial files.

## When it happens

It happens during a base backup or WAL receive when a segment's size cannot be read from the destination directory — usually a permissions problem, a removed file, or an I/O error on the destination.

## How to fix

Check the destination directory for correct permissions and healthy storage, and remove any damaged partial segment from an interrupted run, then rerun the backup or receive.

## Example

*Illustrative* — a segment whose size could not be read.

```text
pg_basebackup: error: could not get size of write-ahead log file "000000010000000000000005": No such file or directory
```

## Related

- [could not fsync existing write-ahead log file](./could-not-fsync-existing-write-ahead-log-file.md)
- [could not find WAL in archive](./could-not-find-wal-in-archive-1ea321.md)

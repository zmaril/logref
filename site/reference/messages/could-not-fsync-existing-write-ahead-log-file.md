---
message: "could not fsync existing write-ahead log file \"%s\": %s"
slug: could-not-fsync-existing-write-ahead-log-file
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_basebackup/receivelog.c:142"
reproduced: false
---

# `could not fsync existing write-ahead log file "%s": %s`

## What it means

While streaming WAL, `pg_basebackup` (or `pg_receivewal`) tried to flush an already-present WAL segment to disk with `fsync` and it failed. The `%s` value gives the cause. The tool flushes segments so received WAL is durable.

## When it happens

It happens during a base backup or WAL receive when a partially written segment on the target cannot be flushed — commonly a full disk, a permissions problem, or an I/O error on the destination.

## How to fix

Check the destination directory for free space, permissions, and storage health, then rerun the backup or receive. Removing a stale partial segment left by an interrupted run may be needed before the destination will accept the flush.

## Example

*Illustrative* — a failed flush of a received WAL segment.

```text
pg_basebackup: error: could not fsync existing write-ahead log file "000000010000000000000007": No space left on device
```

## Related

- [could not get size of write-ahead log file](./could-not-get-size-of-write-ahead-log-file.md)
- [could not fsync bootstrap write-ahead log file](./could-not-fsync-bootstrap-write-ahead-log-file.md)

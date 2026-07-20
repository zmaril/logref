---
message: "could not fsync bootstrap write-ahead log file: %m"
slug: could-not-fsync-bootstrap-write-ahead-log-file
passthrough: false
api: [ereport]
level: [PANIC]
call_sites:
  - "postgres/src/backend/access/transam/xlog.c:5582"
reproduced: false
---

# `could not fsync bootstrap write-ahead log file: %m`

## What it means

During cluster bootstrap the server tried to flush the first WAL file to disk with `fsync` and the operating system refused. The `%m` reason gives the cause. Bootstrap must durably persist this file before it can continue.

## When it happens

It fires only during `initdb`'s bootstrap phase, while writing the initial WAL segment, when `fsync` fails — usually a full disk, a read-only or faulty filesystem, or storage that does not support flushing.

## How to fix

Make sure the target data directory is on writable, healthy storage with free space, then rerun `initdb`. If the filesystem cannot honor `fsync` at all, move the data directory to storage that can; a cluster that cannot flush WAL is not safe to run.

## Example

*Illustrative* — a failed flush of the bootstrap WAL file.

```text
PANIC:  could not fsync bootstrap write-ahead log file: No space left on device
```

## Related

- [could not fsync existing write-ahead log file](./could-not-fsync-existing-write-ahead-log-file.md)
- [could not get size of write-ahead log file](./could-not-get-size-of-write-ahead-log-file.md)

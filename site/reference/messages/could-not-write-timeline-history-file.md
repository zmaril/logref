---
message: "could not write timeline history file \"%s\": %s"
slug: could-not-write-timeline-history-file
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_basebackup/receivelog.c:304"
reproduced: false
---

# `could not write timeline history file "%s": %s`

## What it means

`pg_receivewal` could not write a timeline history file to its target directory. The placeholder is the file and the trailing text is the underlying error. History files record where the log branched across timelines.

## When it happens

It fires while `pg_receivewal` saves a `.history` file alongside the WAL it streams, when that write fails — a full disk, a permission problem, or an I/O error.

## How to fix

Read the error. Make sure the target directory is writable and has free space. Fix the reported condition and restart streaming; the history file is needed so the archived WAL can be interpreted across timeline switches.

## Example

*Illustrative* — a history file write failed.

```text
pg_receivewal: error: could not write timeline history file "00000002.history": No space left on device
```

## Related

- [could not write bytes to WAL file](./could-not-write-bytes-to-wal-file.md)
- [could not receive timeline history file from the primary server](./could-not-receive-timeline-history-file-from-the-primary-server.md)

---
message: "could not close bootstrap write-ahead log file: %m"
slug: could-not-close-bootstrap-write-ahead-log-file
passthrough: false
api: [ereport]
level: [PANIC]
call_sites:
  - "postgres/src/backend/access/transam/xlog.c:5588"
reproduced: false
---

# `could not close bootstrap write-ahead log file: %m`

## What it means

During cluster bootstrap (`initdb`'s backend phase), the server could not close the initial WAL file. The `%m` reason gives the OS error. Because this happens while laying down the WAL, it is fatal (PANIC).

## When it happens

It fires during `initdb`/bootstrap when closing the bootstrap WAL segment fails, typically due to a filesystem error or full disk in the new data directory.

## How to fix

Ensure the target data directory has space and is on healthy, writable storage. Fix the filesystem problem (disk space, permissions, I/O errors) and re-run `initdb`. A close failure here means the new cluster cannot be trusted, so start over cleanly.

## Example

*Illustrative* — a failed bootstrap WAL close.

```text
PANIC:  could not close bootstrap write-ahead log file: ...
```

## Related

- [concurrent write-ahead log activity while database system is shutting down](./concurrent-write-ahead-log-activity-while-database-system-is-shutting-down.md)
- [could not close data file](./could-not-close-data-file-26fbaa.md)

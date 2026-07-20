---
message: "could not write bootstrap write-ahead log file: %m"
slug: could-not-write-bootstrap-write-ahead-log-file
passthrough: false
api: [ereport]
level: [PANIC]
call_sites:
  - "postgres/src/backend/access/transam/xlog.c:5574"
reproduced: false
---

# `could not write bootstrap write-ahead log file: %m`

## What it means

During cluster bootstrap, the server could not write the initial write-ahead log file. The trailing text is the operating-system error. This runs inside `initdb`, which starts a bootstrap backend to lay down the first WAL. The failure is fatal enough to be reported as a PANIC.

## When it happens

It fires while `initdb` bootstraps a new cluster and the first WAL segment cannot be written — a full or read-only target filesystem, or a permission problem in the new data directory.

## How to fix

Read the OS error. Make sure the target data directory is on writable storage with free space and is owned by the user running `initdb`. `No space left on device` or `Permission denied` are the usual causes. Fix the filesystem condition and rerun `initdb` on a clean directory.

## Example

*Illustrative* — the bootstrap WAL write failed.

```text
PANIC:  could not write bootstrap write-ahead log file: No space left on device
```

## Related

- [could not write to file, wrote N of M](./could-not-write-to-file-wrote-of.md)
- [could not synchronize file](./could-not-synchronize-file.md)

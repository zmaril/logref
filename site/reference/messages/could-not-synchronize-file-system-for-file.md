---
message: "could not synchronize file system for file \"%s\": %m"
slug: could-not-synchronize-file-system-for-file
passthrough: false
api: [ereport, pg_log_error]
level: [ERROR, LOG]
call_sites:
  - "postgres/src/backend/storage/file/fd.c:3564"
  - "postgres/src/common/file_utils.c:75"
reproduced: false
---

# `could not synchronize file system for file "%s": %m`

## What it means

A filesystem-level sync for a file failed. The `%s` is the path and the `%m` is the operating-system error. Postgres could not force the file's directory or data to durable storage.

## When it happens

A `syncfs`/`fsync` on the file or its filesystem returned an error during a checkpoint, a data-directory sync, or a client tool's finalization step — usually an I/O fault or an unsupported operation on the medium.

## How to fix

Read the trailing error and check storage health. A sync failure risks durability; if hardware is faulting, address it before trusting the data. On filesystems that do not support the operation, adjust the sync method where configurable.

## Example

*Illustrative* — a filesystem sync returned an I/O error.

```text
ERROR:  could not synchronize file system for file "base/16384/16390": Input/output error
```

## Related

- [could not fsync file](./could-not-fsync-file-5db846.md)
- [could not seek to end of file](./could-not-seek-to-end-of-file.md)

---
message: "could not close target file \"%s\": %m"
slug: could-not-close-target-file
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_rewind/file_ops.c:84"
reproduced: false
---

# `could not close target file "%s": %m`

## What it means

`pg_rewind` could not close a file it had written in the target data directory. The `%m` reason gives the OS error. Because the close failed, the write may not have flushed, leaving the target directory suspect.

## When it happens

It happens while `pg_rewind` is rewriting the target cluster, when closing an output file fails, usually from a full disk, a permissions problem, or an I/O error on the target storage.

## How to fix

Check the target directory's storage for free space, permissions, and I/O errors. A `pg_rewind` run that failed mid-way leaves the target unusable — resolve the storage problem and rerun the rewind from a known-good starting point.

## Example

*Illustrative* — a failed close while rewinding.

```text
pg_rewind: fatal: could not close target file "pg_wal/000000010000000000000003": No space left on device
```

## Related

- [could not create symbolic link at](./could-not-create-symbolic-link-at.md)
- [could not decide what to do with file](./could-not-decide-what-to-do-with-file.md)

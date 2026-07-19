---
message: "could not close input file: %m"
slug: could-not-close-input-file
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/pg_backup_archiver.c:2368"
reproduced: false
---

# `could not close input file: %m`

## What it means

`pg_restore` could not close the input archive file. The `%m` reason gives the OS error. The close failed at the end of reading the archive.

## When it happens

It happens in `pg_restore` when closing the archive file fails, usually due to a filesystem or media problem.

## How to fix

Check the storage holding the archive for health and permissions. The restore may have read successfully; a close failure indicates an underlying disk/mount issue to resolve.

## Example

*Illustrative* — a failed input-file close in pg_restore.

```text
pg_restore: fatal: could not close input file: ...
```

## Related

- [could not close filter file](./could-not-close-filter-file.md)
- [could not close file](./could-not-close-file-677026.md)

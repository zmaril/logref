---
message: "could not close data file: %m"
slug: could-not-close-data-file-26fbaa
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/pg_backup_directory.c:337"
reproduced: false
---

# `could not close data file: %m`

## What it means

A directory-format `pg_dump`/`pg_restore` could not close a data file. The `%m` reason gives the OS error. The close failed, so the file may be incomplete.

## When it happens

It happens with directory-format archives when closing a per-table data file fails, typically due to a filesystem or disk problem.

## How to fix

Check the archive directory's filesystem for space, permissions, and I/O errors. Resolve the storage issue and regenerate or re-verify the archive; a data file that failed to close is unreliable.

## Example

*Illustrative* — a failed data-file close.

```text
pg_dump: fatal: could not close data file: ...
```

## Related

- [could not close data file](./could-not-close-data-file-da381a.md)
- [could not close large object TOC file](./could-not-close-large-object-toc-file.md)

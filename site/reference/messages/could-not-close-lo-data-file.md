---
message: "could not close LO data file: %m"
slug: could-not-close-lo-data-file
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/pg_backup_directory.c:652"
reproduced: false
---

# `could not close LO data file: %m`

## What it means

A directory-format `pg_dump`/`pg_restore` could not close the large-object (LO) data file. The `%m` reason gives the OS error. The close failed, so the file may be incomplete.

## When it happens

It happens with directory-format archives when closing the large-object data file fails, typically due to a filesystem or disk problem.

## How to fix

Check the archive directory's storage health, free space, and permissions. Fix the underlying issue and regenerate or re-verify the archive; a LO data file that failed to close cannot be trusted.

## Example

*Illustrative* — a failed LO data-file close.

```text
pg_dump: fatal: could not close LO data file: ...
```

## Related

- [could not close large object TOC file](./could-not-close-large-object-toc-file.md)
- [could not close LOs TOC file](./could-not-close-los-toc-file.md)

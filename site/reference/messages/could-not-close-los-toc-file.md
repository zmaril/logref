---
message: "could not close LOs TOC file: %m"
slug: could-not-close-los-toc-file
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/pg_backup_directory.c:671"
reproduced: false
---

# `could not close LOs TOC file: %m`

## What it means

A directory-format `pg_dump`/`pg_restore` could not close the large-objects (LOs) table-of-contents file. The `%m` reason gives the OS error. The close failed, so the file may be incomplete.

## When it happens

It happens with directory-format archives when closing the LOs TOC file fails, typically due to a filesystem or disk problem.

## How to fix

Check the archive directory's storage for space, permissions, and I/O errors. Resolve the issue and regenerate or re-verify the archive; a TOC file that failed to close is unreliable.

## Example

*Illustrative* — a failed LOs TOC close.

```text
pg_dump: fatal: could not close LOs TOC file: ...
```

## Related

- [could not close LO data file](./could-not-close-lo-data-file.md)
- [could not close large object TOC file](./could-not-close-large-object-toc-file.md)

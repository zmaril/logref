---
message: "could not close large object TOC file \"%s\": %m"
slug: could-not-close-large-object-toc-file
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/pg_backup_directory.c:446"
reproduced: false
---

# `could not close large object TOC file "%s": %m`

## What it means

A directory-format `pg_dump`/`pg_restore` could not close the large-object table-of-contents (TOC) file. The `%m` reason gives the OS error. The close failed, so the file may be incomplete.

## When it happens

It happens with directory-format archives when closing the large-object TOC file fails, typically due to a filesystem or disk problem.

## How to fix

Check the archive directory's storage for space, permissions, and errors. Resolve the issue and regenerate or re-verify the archive; a TOC file that failed to close is unreliable.

## Example

*Illustrative* — a failed large-object TOC close.

```text
pg_dump: fatal: could not close large object TOC file "...": ...
```

## Related

- [could not close LO data file](./could-not-close-lo-data-file.md)
- [could not close LOs TOC file](./could-not-close-los-toc-file.md)

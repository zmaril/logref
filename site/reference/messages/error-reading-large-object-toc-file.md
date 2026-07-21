---
message: "error reading large object TOC file \"%s\""
slug: error-reading-large-object-toc-file
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/pg_backup_directory.c:442"
reproduced: false
---

# `error reading large object TOC file "%s"`

## What it means

`pg_restore` failed to read the large-object table-of-contents file (`blobs.toc`) inside a directory-format archive. The placeholder is the file name. The archive's large-object index could not be read.

## When it happens

It fires in `pg_restore` while restoring large objects from a directory-format archive, when the large-object TOC file is missing, unreadable, or malformed.

## How to fix

Ensure the directory-format archive is complete and its large-object TOC file is present and readable. If the file is missing or corrupt, the dump directory is incomplete — regenerate the dump.

## Example

*Illustrative* — an unreadable large-object TOC.

```text
pg_restore: error: error reading large object TOC file "blobs.toc"
```

## Related

- [error reading large object](./error-reading-large-object.md)
- [directory does not appear to be a valid archive (toc.dat does not exist)](./directory-does-not-appear-to-be-a-valid-archive-toc-dat-does-not-exist.md)

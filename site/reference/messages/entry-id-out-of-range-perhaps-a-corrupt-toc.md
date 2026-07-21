---
message: "entry ID %d out of range -- perhaps a corrupt TOC"
slug: entry-id-out-of-range-perhaps-a-corrupt-toc
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/pg_backup_archiver.c:2737"
reproduced: false
---

# `entry ID %d out of range -- perhaps a corrupt TOC`

## What it means

`pg_restore` read a table-of-contents entry whose ID is outside the valid range for the archive. The placeholder is the ID. The archive's TOC is likely corrupt.

## When it happens

It fires in `pg_restore` while parsing a custom- or directory-format archive's table of contents, when an entry references an out-of-range ID.

## How to fix

The archive is damaged. Regenerate the dump from the source database if possible. If the archive was transferred, re-copy it (in binary mode) in case truncation or byte alteration corrupted it.

## Example

*Illustrative* — a corrupt TOC entry.

```text
pg_restore: error: entry ID 99999 out of range -- perhaps a corrupt TOC
```

## Related

- [did not find magic string in file header](./did-not-find-magic-string-in-file-header.md)
- [directory does not appear to be a valid archive (toc.dat does not exist)](./directory-does-not-appear-to-be-a-valid-archive-toc-dat-does-not-exist.md)

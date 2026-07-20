---
message: "could not close TOC file: %m"
slug: could-not-close-toc-file
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/pg_backup_archiver.c:1642"
  - "postgres/src/bin/pg_dump/pg_backup_directory.c:187"
  - "postgres/src/bin/pg_dump/pg_backup_directory.c:563"
reproduced: false
---

# `could not close TOC file: %m`

## What it means

`pg_dump`/`pg_restore` could not close the archive's table-of-contents (TOC) file. The placeholder is the OS error. The TOC records the archive's contents; a failed close may leave it incomplete, so the tool reports it as a fatal condition.

## When it happens

An I/O error at close time on the archive/TOC destination — a full or failing disk, or a filesystem problem — while writing a custom/directory-format dump.

## How to fix

Read the appended OS error. Ensure the output filesystem has space and is healthy, then re-run the dump so the archive is written completely. Do not trust an archive whose TOC close failed; regenerate it. Fix the underlying storage issue if the error persists.

## Example

*Illustrative* — a failed TOC close during dump.

```text
pg_dump: error: could not close TOC file: No space left on device
```

## Related

- [could not close file](./could-not-close-file-62a3f1.md)
- [could not open output file](./could-not-open-output-file-202c64.md)

---
message: "could not open output file: %m"
slug: could-not-open-output-file-202c64
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/pg_backup_archiver.c:1731"
  - "postgres/src/bin/pg_dump/pg_backup_custom.c:157"
  - "postgres/src/fe_utils/astreamer_gzip.c:131"
reproduced: false
---

# `could not open output file: %m`

## What it means

`pg_dump`/`pg_restore` could not open its output file for writing. The placeholder is the OS error. The archive or output could not be created or opened at the destination, so the dump cannot be written.

## When it happens

The destination directory does not exist or is not writable, the disk is full, the path is wrong, or permissions prevent creating the file.

## How to fix

Read the appended OS error. Ensure the target directory exists and is writable by the invoking user, that there is free space, and that the `-f`/`--file` path is correct. Create or fix the destination, then re-run.

## Example

*Illustrative* — an unwritable dump destination.

```text
pg_dump: error: could not open output file: Permission denied
```

## Related

- [could not close TOC file](./could-not-close-toc-file.md)
- [could not close file](./could-not-close-file-62a3f1.md)

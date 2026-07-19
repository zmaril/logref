---
message: "could not close archive file: %m"
slug: could-not-close-archive-file
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/pg_backup_custom.c:775"
  - "postgres/src/bin/pg_dump/pg_backup_custom.c:815"
reproduced: false
---

# `could not close archive file: %m`

## What it means

The `pg_dump`/`pg_restore` archive machinery failed to close its archive file. The placeholder is the system reason. Closing the file — which flushes buffered data — returned an error, so the archive may be incomplete.

## When it happens

Running `pg_dump` to an archive when the output filesystem fills up, the device fails, or an I/O error occurs as the file is finalized.

## How to fix

Check the OS error in the detail. Ensure the destination has enough free space and a healthy device, and re-run the dump. Treat any archive that failed to close as suspect and regenerate it before relying on it for restore.

## Example

*Illustrative* — a dump failing to close its archive.

```text
pg_dump: error: could not close archive file: No space left on device
```

## Related

- [could not close output file](./could-not-close-output-file.md)
- [could not close file](./could-not-close-file-d49639.md)

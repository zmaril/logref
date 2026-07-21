---
message: "could not close output file: %m"
slug: could-not-close-output-file
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/pg_backup_archiver.c:272"
  - "postgres/src/bin/pg_dump/pg_backup_archiver.c:1748"
reproduced: false
---

# `could not close output file: %m`

## What it means

The `pg_dump` archiver failed to close its output file. The placeholder is the system reason. The final close, which flushes buffered output, returned an error, so the dump may be truncated.

## When it happens

Running `pg_dump` when the output device runs out of space or fails as the file is closed, or when writing to a pipe whose reader has gone away.

## How to fix

Read the OS error in the detail, resolve the space or device problem, and re-run the dump. Regenerate any dump whose output file failed to close, since it may be incomplete.

## Example

*Illustrative* — a dump failing to close its output.

```text
pg_dump: error: could not close output file: No space left on device
```

## Related

- [could not close archive file](./could-not-close-archive-file.md)
- [could not close file](./could-not-close-file-d49639.md)

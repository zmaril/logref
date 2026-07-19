---
message: "could not close file: %m"
slug: could-not-close-file-d49639
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_dump/compress_lz4.c:704"
  - "postgres/src/bin/pg_dump/compress_none.c:216"
reproduced: false
---

# `could not close file: %m`

## What it means

A `pg_dump` compression backend failed to close an output file. The placeholder is the system reason. Closing the file flushes remaining buffered data, and that step returned an error, leaving the file possibly incomplete.

## When it happens

Running `pg_dump` with compression (lz4 or uncompressed output) when the destination filesystem fills, the device errors, or an I/O fault occurs while finalizing the file.

## How to fix

Inspect the OS error in the detail, free space or repair the device, and re-run the dump. Do not trust an output file that failed to close; regenerate it before using it.

## Example

*Illustrative* — a compressed dump failing to close.

```text
pg_dump: error: could not close file: No space left on device
```

## Related

- [could not close archive file](./could-not-close-archive-file.md)
- [could not close output file](./could-not-close-output-file.md)

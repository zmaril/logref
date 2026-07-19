---
message: "error during writing: %m"
slug: error-during-writing-929603
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/compress_lz4.c:539"
reproduced: false
---

# `error during writing: %m`

## What it means

`pg_dump` hit an operating-system write error while writing LZ4-compressed output. The placeholder is the OS error string. The write to the destination file failed.

## When it happens

It fires in `pg_dump` while producing an LZ4-compressed archive, when the underlying file write fails — most often a full disk or an I/O error.

## How to fix

Read the OS error. `No space left on device` means the destination filesystem is full; free space and rerun. An I/O error points at failing storage. Confirm the output path is writable with room to spare.

## Example

*Illustrative* — a write error during LZ4 output.

```text
pg_dump: error: error during writing: No space left on device
```

## Related

- [error during writing](./error-during-writing-be913d.md)
- [error reading large object](./error-reading-large-object.md)

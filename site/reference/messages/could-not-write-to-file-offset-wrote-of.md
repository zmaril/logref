---
message: "could not write to file \"%s\", offset %u: wrote %d of %d"
slug: could-not-write-to-file-offset-wrote-of
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_combinebackup/copy_file.c:202"
reproduced: false
---

# `could not write to file "%s", offset %u: wrote %d of %d`

## What it means

`pg_combinebackup` could not fully write to a file while copying data. The placeholders are the file, the offset, and the bytes written versus expected — a short write. The tool reconstructs a full backup from incremental parts.

## When it happens

It fires while `pg_combinebackup` copies a file into the output backup and a write returns short, which usually means the output filesystem is full.

## How to fix

A short write almost always means the disk ran out of space. Free space on the filesystem holding the output directory and rerun. Check the storage for I/O errors if space was not the cause.

## Example

*Illustrative* — a copy write came up short.

```text
pg_combinebackup: error: could not write to file "base/1/1259", offset 4096: wrote 4096 of 8192
```

## Related

- [could not write file, wrote N of M (manifest)](./could-not-write-file-wrote-of-fb0408.md)
- [CRC is incorrect](./crc-is-incorrect.md)

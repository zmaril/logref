---
message: "could not write file \"%s\": wrote %zd of %d"
slug: could-not-write-file-wrote-of-fb0408
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_combinebackup/write_manifest.c:262"
reproduced: false
---

# `could not write file "%s": wrote %zd of %d`

## What it means

`pg_combinebackup` could not fully write its backup manifest file. The placeholders are the file and the bytes written versus expected — a short write with no explicit OS error.

## When it happens

It fires while `pg_combinebackup` writes the manifest describing the reconstructed backup, when the write returns short, which usually means the output filesystem filled up.

## How to fix

A short write almost always means the disk ran out of space. Free space on the filesystem holding the output directory and rerun. If space was not the cause, check the storage for I/O errors.

## Example

*Illustrative* — the manifest write came up short.

```text
pg_combinebackup: error: could not write file "backup_manifest": wrote 4096 of 8192
```

## Related

- [could not write to file, offset: wrote N of M](./could-not-write-to-file-offset-wrote-of.md)
- [CRC is incorrect](./crc-is-incorrect.md)

---
message: "could not read from input file: %s"
slug: could-not-read-from-input-file-3a7c6a
passthrough: false
api: [pg_fatal, pg_log_error]
level: [ERROR, FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/compress_gzip.c:290"
  - "postgres/src/bin/pg_dump/compress_lz4.c:495"
  - "postgres/src/bin/pg_dump/compress_lz4.c:567"
  - "postgres/src/bin/pg_dump/compress_lz4.c:584"
reproduced: false
---

# `could not read from input file: %s`

## What it means

A tool (here `pg_dump`/`pg_restore` reading a gzip-compressed archive) failed to read from its input file. The placeholder is the underlying error text. The read did not return the expected data, often because the file is truncated or corrupted.

## When it happens

Restoring or reading a compressed dump whose file is truncated, corrupted, or cut off mid-stream, or when an I/O error occurs while reading it.

## How to fix

Verify the input file is complete and uncorrupted — compare its size to the source and re-copy it if it crossed a network. If the file is intact, check for storage/I/O errors. If the dump itself is damaged, regenerate it from the source database.

## Example

*Illustrative* — a truncated compressed input.

```text
FATAL:  could not read from input file: unexpected end of file
```

## Related

- [could not decompress data](./could-not-decompress-data.md)
- [could not determine seek position in archive file](./could-not-determine-seek-position-in-archive-file.md)

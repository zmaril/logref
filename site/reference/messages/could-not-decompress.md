---
message: "could not decompress: %s"
slug: could-not-decompress
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/compress_lz4.c:188"
reproduced: false
---

# `could not decompress: %s`

## What it means

`pg_dump`/`pg_restore` could not decompress LZ4-compressed archive data. The `%s` gives the library's reason. The compressed stream could not be expanded.

## When it happens

It happens while reading an LZ4-compressed dump when decompression fails, usually because the archive is truncated or corrupted.

## How to fix

Check that the archive file is complete and undamaged — a truncated download or a bad transfer is the common cause. Re-fetch or regenerate the dump and retry.

## Example

*Illustrative* — LZ4 decompression failing on a damaged archive.

```text
pg_restore: fatal: could not decompress: ...reason...
```

## Related

- [could not decompress file](./could-not-decompress-file.md)
- [could not create zstd decompression context](./could-not-create-zstd-decompression-context.md)

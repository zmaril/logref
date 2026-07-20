---
message: "could not end decompression: %s"
slug: could-not-end-decompression
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_dump/compress_lz4.c:687"
reproduced: false
---

# `could not end decompression: %s`

## What it means

`pg_dump`/`pg_restore` could not cleanly finish an LZ4 decompression stream. The `%s` gives the library's reason. The tail of the compressed data could not be finalized.

## When it happens

It happens while reading an LZ4-compressed archive when closing the decompression stream fails, usually because the archive is truncated or corrupted at the end.

## How to fix

Check that the archive file is complete and undamaged — a truncated file is the common cause. Re-fetch or regenerate the dump and retry.

## Example

*Illustrative* — decompression finalization failing on a damaged archive.

```text
pg_restore: error: could not end decompression: ...reason...
```

## Related

- [could not decompress](./could-not-decompress.md)
- [could not decompress file](./could-not-decompress-file.md)

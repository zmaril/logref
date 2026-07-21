---
message: "could not end compression: %s"
slug: could-not-end-compression
passthrough: false
api: [pg_fatal, pg_log_error]
level: [ERROR, FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/compress_lz4.c:269"
  - "postgres/src/bin/pg_dump/compress_lz4.c:278"
  - "postgres/src/bin/pg_dump/compress_lz4.c:659"
  - "postgres/src/bin/pg_dump/compress_lz4.c:677"
reproduced: false
---

# `could not end compression: %s`

## What it means

A tool (here `pg_dump` with LZ4) failed while finalizing a compression stream — flushing the last buffered bytes and closing the compressor. The placeholder is the compression library's error text. A failure at the end can leave the output incomplete.

## When it happens

Writing a compressed dump when the compression library reports an error on finalization, or when the underlying write fails (out of disk, broken pipe) as the stream is closed.

## How to fix

Read the included error text. If it points to a write failure, check destination disk space and that the output target is healthy. Re-run the dump to a location with sufficient space. A repeated library-level failure may indicate a compression library problem worth reporting.

## Example

*Illustrative* — a compression stream failing to finalize.

```text
FATAL:  could not end compression: write error
```

## Related

- [could not decompress data](./could-not-decompress-data.md)
- [invalid compression specification](./invalid-compression-specification.md)

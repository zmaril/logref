---
message: "could not compress data: %s"
slug: could-not-compress-data
passthrough: false
api: [elog, pg_fatal]
level: [ERROR, FATAL]
call_sites:
  - "postgres/src/backend/backup/basebackup_gzip.c:205"
  - "postgres/src/backend/backup/basebackup_gzip.c:256"
  - "postgres/src/backend/backup/basebackup_lz4.c:211"
  - "postgres/src/backend/backup/basebackup_zstd.c:221"
  - "postgres/src/backend/backup/basebackup_zstd.c:264"
  - "postgres/src/bin/pg_dump/compress_gzip.c:122"
  - "postgres/src/bin/pg_dump/compress_lz4.c:235"
  - "postgres/src/bin/pg_dump/compress_zstd.c:109"
  - "postgres/src/fe_utils/astreamer_lz4.c:191"
  - "postgres/src/fe_utils/astreamer_zstd.c:182"
  - "postgres/src/fe_utils/astreamer_zstd.c:224"
reproduced: false
---

# `could not compress data: %s`

## What it means

A compression library returned an error while compressing a stream. The placeholder is the library's error text. The method (gzip/lz4/zstd) is available in this build, but the call itself failed at runtime.

## When it happens

Compressing a base backup, WAL, or dump output when the compression library hits an internal error — often out-of-memory for the compressor's working buffers, an invalid compression level, or a library bug. It is a runtime failure, distinct from the method being uncompiled.

## How to fix

Read the library error text. If it is memory-related, ensure the host has headroom and consider a lower compression level (high levels need more memory). Verify the compression level and options are valid for the method. If the library itself is faulty, update it. Retrying at a lower level often succeeds.

## Example

*Illustrative* — a compressor failing at runtime.

```text
ERROR:  could not compress data: (null)
```

## Related

- [this build does not support compression with %s](./this-build-does-not-support-compression-with.md)
- [could not initialize compression library](./could-not-initialize-compression-library-d6693c.md)

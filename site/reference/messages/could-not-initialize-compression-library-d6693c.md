---
message: "could not initialize compression library"
slug: could-not-initialize-compression-library-d6693c
passthrough: false
api: [ereport, pg_fatal]
level: [ERROR, FATAL]
sqlstate:
  - symbol: ERRCODE_INTERNAL_ERROR
    code: "XX000"
call_sites:
  - "postgres/src/backend/backup/basebackup_gzip.c:145"
  - "postgres/src/bin/pg_dump/compress_zstd.c:79"
  - "postgres/src/bin/pg_dump/compress_zstd.c:232"
  - "postgres/src/bin/pg_dump/compress_zstd.c:281"
  - "postgres/src/bin/pg_dump/compress_zstd.c:369"
  - "postgres/src/fe_utils/astreamer_gzip.c:271"
reproduced: false
---

# `could not initialize compression library`

## What it means

A compression library could not be initialized before use. Unlike a build that lacks the method entirely, here the method is compiled in but the library's setup call failed at runtime. The `INTERNAL_ERROR` class marks it as an unexpected internal failure.

## When it happens

Setting up gzip/zstd (and similar) compression for a base backup or dump when the library's init fails — typically out-of-memory for the compressor's state, an invalid parameter passed to init, or a library/environment problem.

## How to fix

Check for memory pressure (compression init allocates working state) and ensure valid compression options/levels. If the host is low on memory, free some or lower the compression level. If the library or its version is faulty, update it. Retry with default options to isolate whether a specific parameter caused the init to fail.

## Example

*Illustrative* — a compressor failing to initialize.

```text
ERROR:  could not initialize compression library
```

## Related

- [this build does not support compression with %s](./this-build-does-not-support-compression-with.md)
- [could not compress data](./could-not-compress-data.md)

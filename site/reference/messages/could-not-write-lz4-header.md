---
message: "could not write lz4 header: %s"
slug: could-not-write-lz4-header
passthrough: false
api: [elog, pg_fatal]
level: [ERROR, FATAL]
call_sites:
  - "postgres/src/backend/backup/basebackup_lz4.c:151"
  - "postgres/src/fe_utils/astreamer_lz4.c:142"
reproduced: false
---

# `could not write lz4 header: %s`

## What it means

An LZ4 compressor could not write its frame header. The `%s` is the LZ4 error. Compression could not begin, so the output stream was not started.

## When it happens

It fires at the start of LZ4 compression for a base backup or dump, when the LZ4 library rejected the header write — an internal LZ4 state error or a bad configuration.

## How to fix

Check the LZ4 options passed to the backup or dump and the linked liblz4 version. Retry with valid settings; if it recurs with defaults, capture the tool, version, and command and report it.

## Example

*Illustrative* — LZ4 header write failed at stream start.

```text
ERROR:  could not write lz4 header: generic error code
```

## Related

- [could not free LZ4 decompression context](./could-not-free-lz4-decompression-context.md)
- [could not set zstd compression level to](./could-not-set-zstd-compression-level-to.md)

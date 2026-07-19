---
message: "could not create lz4 compression context: %s"
slug: could-not-create-lz4-compression-context
passthrough: false
api: [elog, pg_fatal]
level: [ERROR, FATAL]
call_sites:
  - "postgres/src/backend/backup/basebackup_lz4.c:141"
  - "postgres/src/fe_utils/astreamer_lz4.c:97"
reproduced: false
---

# `could not create lz4 compression context: %s`

## What it means

Code that compresses data with LZ4 (base backup streaming, or a frontend stream) could not allocate or initialize an LZ4 compression context. The placeholder is the library reason. The LZ4 library failed to create the state needed to compress.

## When it happens

Taking a base backup or streaming with LZ4 compression when the system is out of memory, or the LZ4 library reports an initialization failure.

## How to fix

Check the library error in the message and system memory availability. Ensure the server and client are built against a working LZ4 library, and free memory if the host is under pressure. Retry once resources are available.

## Example

*Illustrative* — an LZ4 context that could not be created.

```text
ERROR:  could not create lz4 compression context: error 1
```

## Related

- [could not create lz4 decompression context](./could-not-create-lz4-decompression-context.md)
- [could not end lz4 compression](./could-not-end-lz4-compression.md)

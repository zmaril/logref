---
message: "could not create LZ4 decompression context: %s"
slug: could-not-create-lz4-decompression-context
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_receivewal.c:390"
  - "postgres/src/bin/pg_dump/compress_lz4.c:166"
reproduced: false
---

# `could not create LZ4 decompression context: %s`

## What it means

A tool that reads LZ4-compressed data (`pg_receivewal`, `pg_dump`/`pg_restore`) could not allocate or initialize an LZ4 decompression context. The placeholder is the library reason. The LZ4 library failed to create the decode state.

## When it happens

Restoring or receiving LZ4-compressed streams when the system is out of memory, or the LZ4 library reports an initialization failure.

## How to fix

Check the library error and system memory. Confirm the tool is built against a functioning LZ4 library and free memory if the host is constrained. Retry the operation once resources allow.

## Example

*Illustrative* — an LZ4 decode context that could not be created.

```text
FATAL:  could not create LZ4 decompression context: error 1
```

## Related

- [could not create lz4 compression context](./could-not-create-lz4-compression-context.md)
- [could not create zstd compression context](./could-not-create-zstd-compression-context.md)

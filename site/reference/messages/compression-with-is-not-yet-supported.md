---
message: "compression with %s is not yet supported"
slug: compression-with-is-not-yet-supported
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_receivewal.c:816"
reproduced: false
---

# `compression with %s is not yet supported`

## What it means

`pg_receivewal` was asked to use a compression method that this build or code path does not support for WAL streaming. The requested method cannot be applied here.

## When it happens

It happens with `pg_receivewal --compress=method` when the named method is not available for received WAL (for example a method the binary was not built with, or one not implemented for this stream).

## How to fix

Choose a supported compression method, or stream WAL uncompressed. Confirm which methods your build supports; if you need a specific one, use a build that includes it.

## Example

*Illustrative* — an unsupported WAL compression method.

```text
pg_receivewal: error: compression with lz4 is not yet supported
```

## Related

- [compression detail cannot be specified unless compression is enabled](./compression-detail-cannot-be-specified-unless-compression-is-enabled.md)
- [compressor active](./compressor-active.md)

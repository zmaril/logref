---
message: "could not create zstd decompression context"
slug: could-not-create-zstd-decompression-context
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/fe_utils/astreamer_zstd.c:276"
reproduced: false
---

# `could not create zstd decompression context`

## What it means

A frontend tool could not initialize a zstd decompression context. Without it a zstd-compressed dump or backup stream cannot be read.

## When it happens

It happens when a tool reads zstd-compressed data and the zstd library fails to allocate a decompression context, usually under memory pressure.

## How to fix

Free memory on the host and retry. Persistent failures with ample memory point at a problem with the zstd library the tool is linked against.

## Example

*Illustrative* — zstd context allocation failing.

```text
fatal: could not create zstd decompression context
```

## Related

- [could not decompress](./could-not-decompress.md)
- [could not decompress file](./could-not-decompress-file.md)

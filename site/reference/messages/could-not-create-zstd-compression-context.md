---
message: "could not create zstd compression context"
slug: could-not-create-zstd-compression-context
passthrough: false
api: [elog, pg_fatal]
level: [ERROR, FATAL]
call_sites:
  - "postgres/src/backend/backup/basebackup_zstd.c:97"
  - "postgres/src/fe_utils/astreamer_zstd.c:89"
reproduced: false
---

# `could not create zstd compression context`

## What it means

Code that compresses with zstd (base backup streaming, or a frontend stream) could not allocate a zstd compression context. The zstd library failed to create the state needed to compress, typically from memory pressure.

## When it happens

Taking a base backup or streaming with zstd compression when the system is out of memory, or the zstd library reports an initialization failure.

## How to fix

Check system memory and ensure the server and client are built against a working zstd library. Free memory if the host is under pressure and retry. Persistent failures warrant inspecting the zstd build.

## Example

*Illustrative* — a zstd context that could not be created.

```text
ERROR:  could not create zstd compression context
```

## Related

- [could not enable long-distance mode](./could-not-enable-long-distance-mode.md)
- [could not create lz4 compression context](./could-not-create-lz4-compression-context.md)

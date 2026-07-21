---
message: "could not set zstd compression level to %d: %s"
slug: could-not-set-zstd-compression-level-to
passthrough: false
api: [elog, pg_fatal]
level: [ERROR, FATAL]
call_sites:
  - "postgres/src/backend/backup/basebackup_zstd.c:102"
  - "postgres/src/fe_utils/astreamer_zstd.c:95"
reproduced: false
---

# `could not set zstd compression level to %d: %s`

## What it means

A Zstandard compressor could not set the requested compression level. The `%d` is the level and the `%s` is the zstd error. The compression could not be configured.

## When it happens

A base backup or dump requested a `zstd` level the linked libzstd rejects — out of the supported range for that library version.

## How to fix

Use a level within the range your libzstd supports (commonly 1 through 22). Lower the level or check the library version, then retry.

## Example

*Illustrative* — a zstd level out of range.

```text
ERROR:  could not set zstd compression level to 30: Parameter is out of bound
```

## Related

- [could not set compression worker count to](./could-not-set-compression-worker-count-to.md)
- [could not write lz4 header](./could-not-write-lz4-header.md)

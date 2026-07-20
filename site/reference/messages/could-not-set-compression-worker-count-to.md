---
message: "could not set compression worker count to %d: %s"
slug: could-not-set-compression-worker-count-to
passthrough: false
api: [ereport, pg_fatal]
level: [ERROR, FATAL]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/backup/basebackup_zstd.c:115"
  - "postgres/src/fe_utils/astreamer_zstd.c:109"
reproduced: false
---

# `could not set compression worker count to %d: %s`

## What it means

A Zstandard compressor could not set its worker-thread count. The `%d` is the requested count and the `%s` is the zstd error. Parallel compression could not be configured as asked.

## When it happens

A base backup or `pg_dump` requested `zstd` with a `workers` value the library could not honor — often because the linked libzstd was built without multithreading, or the count is out of range.

## How to fix

Use a `workers` value the library supports, or drop the worker count to use single-threaded zstd. If you need parallel zstd, link against a libzstd built with multithreading.

## Example

*Illustrative* — zstd multithreading was unavailable.

```text
ERROR:  could not set compression worker count to 4: Unsupported parameter
```

## Related

- [could not set zstd compression level to](./could-not-set-zstd-compression-level-to.md)
- [could not uncompress data](./could-not-uncompress-data.md)

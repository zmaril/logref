---
message: "could not enable long-distance mode: %s"
slug: could-not-enable-long-distance-mode
passthrough: false
api: [ereport, pg_fatal]
level: [ERROR, FATAL]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/backup/basebackup_zstd.c:127"
  - "postgres/src/fe_utils/astreamer_zstd.c:119"
reproduced: false
---

# `could not enable long-distance mode: %s`

## What it means

Code compressing with zstd tried to enable long-distance matching and the zstd library rejected it. The placeholder is the library reason. Long-distance mode is a zstd option that the library declined to set.

## When it happens

Taking a base backup or streaming with zstd and a long-distance-mode option when the linked zstd version does not support it, or the library reports a parameter error.

## How to fix

Check the library reason. Use a zstd build that supports long-distance matching, or drop the long-distance option from the compression settings. Align the requested zstd options with the library version in use.

## Example

*Illustrative* — long-distance mode rejected by zstd.

```text
ERROR:  could not enable long-distance mode: Unsupported parameter
```

## Related

- [could not create zstd compression context](./could-not-create-zstd-compression-context.md)
- [could not end lz4 compression](./could-not-end-lz4-compression.md)

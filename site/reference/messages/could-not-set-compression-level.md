---
message: "could not set compression level %d: %s"
slug: could-not-set-compression-level
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/fe_utils/astreamer_gzip.c:135"
reproduced: false
---

# `could not set compression level %d: %s`

## What it means

A front-end tool could not set the requested compression level on its output stream. The placeholder is the level and the trailing text is the compression library's error. This backs gzip output in tools like `pg_basebackup`.

## When it happens

It fires when a tool initializes compressed output and the library rejects the level, usually because the level is outside the range the method accepts.

## How to fix

Give a compression level within the method's valid range — for gzip, roughly 1 through 9. Check the tool's compression option (for example `--compress`) and correct the level. If you did not set one explicitly, the trailing library error identifies the problem.

## Example

*Illustrative* — an out-of-range gzip level.

```text
pg_basebackup: error: could not set compression level 15: invalid parameter
```

## Related

- [could not set compression parameter](./could-not-set-compression-parameter.md)
- [could not write to compressed file](./could-not-write-to-compressed-file.md)

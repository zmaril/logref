---
message: "could not set compression parameter \"%s\": %s"
slug: could-not-set-compression-parameter
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/compress_zstd.c:67"
reproduced: false
---

# `could not set compression parameter "%s": %s`

## What it means

`pg_dump` could not set a zstd compression parameter for its output. The placeholder is the parameter name and the trailing text is the library's error. zstd accepts tuning parameters such as the compression level and worker count.

## When it happens

It fires when you request zstd compression with a parameter the library rejects — an unknown parameter name or a value out of range.

## How to fix

Check the compression specification you passed (for example `--compress=zstd:level=22,workers=4`). Use parameter names and values that this zstd build supports; the trailing error names the problem. Correct the specification and rerun the dump.

## Example

*Illustrative* — an unsupported zstd parameter.

```text
pg_dump: error: could not set compression parameter "workers": Unsupported parameter
```

## Related

- [could not set compression level](./could-not-set-compression-level.md)
- [could not write to compressed file](./could-not-write-to-compressed-file.md)

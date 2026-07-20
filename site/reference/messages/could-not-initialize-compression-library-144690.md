---
message: "could not initialize compression library: %s"
slug: could-not-initialize-compression-library-144690
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/compress_gzip.c:78"
  - "postgres/src/bin/pg_dump/compress_gzip.c:192"
  - "postgres/src/fe_utils/astreamer_lz4.c:297"
reproduced: false
---

# `could not initialize compression library: %s`

## What it means

A tool (here `pg_dump`'s gzip path) could not initialize its compression library. The placeholder is the library error. Compressed dump output requires setting up the codec's stream state; a failed initialization means compression cannot start.

## When it happens

A library-level problem — a missing or mismatched compression library, an invalid compression level, or memory pressure at stream-setup time.

## How to fix

Read the appended library error. Confirm the compression library (zlib/gzip, or lz4/zstd for those codecs) is installed and matches the tool's build, and that the requested compression level is valid. Free memory if the failure is allocation-related, then re-run. Falling back to no compression isolates whether the codec is the problem.

## Example

*Illustrative* — a compression library that would not initialize.

```text
pg_dump: error: could not initialize compression library: ...
```

## Related

- [unrecognized compression algorithm](./unrecognized-compression-algorithm.md)
- [could not generate restrict key](./could-not-generate-restrict-key.md)

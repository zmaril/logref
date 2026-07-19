---
message: "could not decompress data: %s"
slug: could-not-decompress-data
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/compress_zstd.c:195"
  - "postgres/src/bin/pg_dump/compress_zstd.c:334"
  - "postgres/src/fe_utils/astreamer_gzip.c:322"
  - "postgres/src/fe_utils/astreamer_lz4.c:358"
  - "postgres/src/fe_utils/astreamer_zstd.c:330"
reproduced: false
---

# `could not decompress data: %s`

## What it means

A tool (here `pg_dump`/`pg_restore` reading a compressed archive) failed to decompress a block of data. The placeholder is the compression library's error text. The compressed stream did not decode, which usually means it is truncated or corrupted.

## When it happens

Restoring or reading a compressed dump whose file was truncated, partially written, corrupted in transit, or is not actually in the compression format the tool expects.

## How to fix

Verify the archive file is complete and uncorrupted — compare its size against the source, re-copy it if it crossed a network, and confirm the compression method matches. If the original dump is intact, re-transfer it; if the dump itself is damaged, regenerate it from the source database.

## Example

*Illustrative* — a corrupt compressed dump.

```text
FATAL:  could not decompress data: Zstd decompression failed
```

## Related

- [could not read from input file](./could-not-read-from-input-file-3a7c6a.md)
- [invalid compression specification](./invalid-compression-specification.md)

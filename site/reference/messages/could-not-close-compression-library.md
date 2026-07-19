---
message: "could not close compression library: %s"
slug: could-not-close-compression-library
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/compress_gzip.c:230"
reproduced: false
---

# `could not close compression library: %s`

## What it means

`pg_dump` could not cleanly shut down its gzip compression library at the end of a stream. The `%s` reason gives the error. The compression state could not be finalized.

## When it happens

It happens in `pg_dump`'s gzip output when finalizing the compression library fails, often alongside an earlier write error.

## How to fix

Check for an earlier failure (disk full, I/O error) that left the stream in a bad state, and fix the destination storage. Regenerate the dump; a compression library that failed to close means the output is suspect.

## Example

*Illustrative* — a failed compression-library close.

```text
pg_dump: fatal: could not close compression library: ...
```

## Related

- [could not close compression stream](./could-not-close-compression-stream.md)
- [could not close compressed file](./could-not-close-compressed-file.md)

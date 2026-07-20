---
message: "could not close compression stream: %s"
slug: could-not-close-compression-stream
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/compress_gzip.c:102"
reproduced: false
---

# `could not close compression stream: %s`

## What it means

`pg_dump` could not cleanly finalize its compression stream. The `%s` reason gives the error. The stream did not close properly, so the output may be incomplete.

## When it happens

It happens in `pg_dump` compressed output when finishing the compression stream fails, commonly after a prior write error or storage problem.

## How to fix

Investigate the destination storage (space, I/O health) and any earlier write error. Fix the underlying issue and regenerate the dump; a compression stream that failed to close cannot be trusted.

## Example

*Illustrative* — a failed compression-stream close.

```text
pg_dump: fatal: could not close compression stream: ...
```

## Related

- [could not close compression library](./could-not-close-compression-library.md)
- [could not close compressed file](./could-not-close-compressed-file.md)

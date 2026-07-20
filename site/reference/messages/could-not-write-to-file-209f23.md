---
message: "could not write to file: %s"
slug: could-not-write-to-file-209f23
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/compress_gzip.c:307"
  - "postgres/src/bin/pg_dump/compress_zstd.c:377"
reproduced: false
---

# `could not write to file: %s`

## What it means

`pg_dump`/`pg_restore` could not write to an output file while producing a gzip- or zstd-compressed archive. The `%s` is the compression-library error. The archive write failed.

## When it happens

The output filesystem was full or errored, or the compression library reported a write fault, while the tool wrote a compressed archive member.

## How to fix

Read the trailing error. Ensure the output location has space and is writable, then rerun. Discard the partial archive before retrying.

## Example

*Illustrative* — a compressed-archive write failed.

```text
pg_dump: error: could not write to file: No space left on device
```

## Related

- [could not write to file](./could-not-write-to-file-ecc639.md)
- [could not uncompress data](./could-not-uncompress-data.md)

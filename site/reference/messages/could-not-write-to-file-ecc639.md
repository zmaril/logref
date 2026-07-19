---
message: "could not write to file: %m"
slug: could-not-write-to-file-ecc639
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/compress_none.c:169"
  - "postgres/src/bin/pg_dump/compress_zstd.c:387"
reproduced: false
---

# `could not write to file: %m`

## What it means

`pg_dump`/`pg_restore` could not write to an output file. The `%m` is the operating-system error. It fires for uncompressed output or the zstd path when the raw write fails.

## When it happens

The output filesystem was full, read-only, or returned an I/O error while the tool wrote the archive.

## How to fix

Read the trailing error. Free space or fix permissions on the output target, then rerun. Remove the incomplete archive first.

## Example

*Illustrative* — an output write failed.

```text
pg_dump: error: could not write to file: No space left on device
```

## Related

- [could not write to file](./could-not-write-to-file-209f23.md)
- [could not write file: wrote only of bytes at offset](./could-not-write-file-wrote-only-of-bytes-at-offset-e8dd33.md)

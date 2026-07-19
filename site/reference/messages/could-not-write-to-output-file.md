---
message: "could not write to output file: %m"
slug: could-not-write-to-output-file
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_dump/compress_lz4.c:647"
  - "postgres/src/bin/pg_dump/compress_lz4.c:670"
reproduced: false
---

# `could not write to output file: %m`

## What it means

`pg_dump`/`pg_restore` could not write to an LZ4-compressed output file. The `%m` is the operating-system error. The compressed output stream write failed.

## When it happens

The output filesystem filled up or errored while the tool wrote an LZ4 archive member.

## How to fix

Read the trailing error. Ensure the output target has space and is writable, then rerun after discarding the partial file.

## Example

*Illustrative* — an LZ4 output write failed.

```text
pg_dump: error: could not write to output file: No space left on device
```

## Related

- [could not write to file](./could-not-write-to-file-209f23.md)
- [could not write COPY data](./could-not-write-copy-data.md)

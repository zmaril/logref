---
message: "could not free LZ4 decompression context: %s"
slug: could-not-free-lz4-decompression-context
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_receivewal.c:443"
  - "postgres/src/bin/pg_dump/compress_lz4.c:201"
reproduced: false
---

# `could not free LZ4 decompression context: %s`

## What it means

A client tool could not release the LZ4 decompression context after reading a compressed stream. The `%s` is the LZ4 library's error string. It signals an internal error inside the LZ4 state, not a data problem in your backup.

## When it happens

It fires in `pg_receivewal` or `pg_dump`/`pg_restore` while tearing down LZ4 decompression, typically following an earlier decode error or a corrupt LZ4 frame.

## How to fix

Look for an earlier LZ4 or read error in the same run — that is usually the real fault. Verify the compressed input is intact and that the client and server LZ4 versions are compatible, then retry.

## Example

*Illustrative* — LZ4 teardown failed after a decode error.

```text
pg_receivewal: error: could not free LZ4 decompression context: ERROR_frameDecoding_failed
```

## Related

- [could not uncompress data](./could-not-uncompress-data.md)
- [could not write lz4 header](./could-not-write-lz4-header.md)

---
message: "could not uncompress data: %s"
slug: could-not-uncompress-data
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/compress_gzip.c:208"
  - "postgres/src/bin/pg_dump/compress_gzip.c:223"
reproduced: false
---

# `could not uncompress data: %s`

## What it means

`pg_dump`/`pg_restore` could not decompress data in a gzip-compressed archive. The `%s` is the zlib error. The compressed block could not be inflated.

## When it happens

The archive was truncated or corrupted, was not actually gzip data, or was damaged in transfer, while the tool read a compressed archive member.

## How to fix

Confirm the archive is intact and complete — re-copy it if it was transferred partially — and that it matches the format the tool expects. Re-create the dump if the source archive is genuinely damaged.

## Example

*Illustrative* — a corrupt compressed archive.

```text
pg_restore: error: could not uncompress data: invalid distance too far back
```

## Related

- [could not free LZ4 decompression context](./could-not-free-lz4-decompression-context.md)
- [could not read file](./could-not-read-file-read-of-a9ed38.md)

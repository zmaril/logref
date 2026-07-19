---
message: "could not write block %u in file \"%s\": wrote %d of %d"
slug: could-not-write-block-in-file-wrote-of
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_checksums/pg_checksums.c:265"
reproduced: false
---

# `could not write block %u in file "%s": wrote %d of %d`

## What it means

`pg_checksums` wrote fewer bytes than a full block while updating a file, with no OS error — a short write. The placeholders are the block number, the file, and the bytes written versus expected.

## When it happens

It fires during `pg_checksums` when a block write returns short, which usually means the filesystem ran out of space partway through the write.

## How to fix

A short write almost always means the disk filled up. Free space on the filesystem holding the data directory and rerun `pg_checksums`. Confirm the server is shut down so the tool has exclusive access, and check the storage for errors if space was not the cause.

## Example

*Illustrative* — a block write came up short.

```text
pg_checksums: error: could not write block 42 in file "base/1/1259": wrote 4096 of 8192
```

## Related

- [could not write block in file](./could-not-write-block-in-file.md)
- [could not write blocks in file](./could-not-write-blocks-in-file.md)

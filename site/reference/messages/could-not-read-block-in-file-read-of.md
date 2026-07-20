---
message: "could not read block %u in file \"%s\": read %d of %d"
slug: could-not-read-block-in-file-read-of
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_checksums/pg_checksums.c:209"
reproduced: false
---

# `could not read block %u in file "%s": read %d of %d`

## What it means

`pg_checksums` read a data block but received fewer bytes than a full block. The `%d` values give the bytes read against the block size. A short read means the file is truncated or damaged at that block.

## When it happens

It happens while `pg_checksums` scans a data directory, when a block read returns too few bytes — usually a truncated relation file or an I/O problem, sometimes running against a cluster that was not cleanly shut down.

## How to fix

Run `pg_checksums` only on a cleanly shut-down cluster with intact files. A short read on a stopped, healthy cluster indicates a truncated or corrupt file; investigate the storage and restore the affected relation from a backup if needed.

## Example

*Illustrative* — a short block read.

```text
pg_checksums: error: could not read block 100 in file "base/16384/16400": read 4096 of 8192
```

## Related

- [could not read block in file](./could-not-read-block-in-file.md)
- [could not read file: read of](./could-not-read-file-read-of-4dc01a.md)

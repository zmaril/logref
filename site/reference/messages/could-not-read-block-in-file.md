---
message: "could not read block %u in file \"%s\": %m"
slug: could-not-read-block-in-file
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_checksums/pg_checksums.c:206"
reproduced: false
---

# `could not read block %u in file "%s": %m`

## What it means

`pg_checksums` tried to read a data block from a relation file and the read failed. The `%m` reason gives the cause. It reads every block to verify or rewrite its checksum.

## When it happens

It happens while `pg_checksums` scans a data directory, when a block cannot be read — usually an I/O error, a truncated file, or a permissions problem on the data directory.

## How to fix

Run `pg_checksums` only against a cleanly shut-down cluster with intact files, and investigate the storage if a read fails — an I/O error here points at failing hardware or a damaged file. Fix the storage and rerun on a consistent copy.

## Example

*Illustrative* — a data block could not be read.

```text
pg_checksums: error: could not read block 100 in file "base/16384/16400": Input/output error
```

## Related

- [could not read block in file: read of](./could-not-read-block-in-file-read-of.md)
- [could not read file: read of](./could-not-read-file-read-of-04d09e.md)

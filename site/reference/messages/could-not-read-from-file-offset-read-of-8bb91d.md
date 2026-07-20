---
message: "could not read from file \"%s\", offset %lld: read %d of %d"
slug: could-not-read-from-file-offset-read-of-8bb91d
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_combinebackup/reconstruct.c:791"
reproduced: false
---

# `could not read from file "%s", offset %lld: read %d of %d`

## What it means

`pg_combinebackup` read from a file at a large offset but received fewer bytes than expected. The values give the bytes read against the amount requested. A short read means the source file is truncated at that offset.

## When it happens

It happens while reconstructing a backup, when a read of a backup file at an offset returns too few bytes — usually a truncated, corrupted, or incompletely transferred backup file.

## How to fix

Make sure every backup passed to `pg_combinebackup` is complete and intact and that the storage holding them is healthy. Re-taking or re-transferring the affected backup resolves a truncated file.

## Example

*Illustrative* — a short read at a large offset.

```text
pg_combinebackup: fatal: could not read from file "/backups/inc1/base/16384/16400", offset 1073741824: read 4096 of 8192
```

## Related

- [could not read from file, offset: read of](./could-not-read-from-file-offset-read-of-2c49fa.md)
- [could not read file: read of](./could-not-read-file-read-of-04d09e.md)

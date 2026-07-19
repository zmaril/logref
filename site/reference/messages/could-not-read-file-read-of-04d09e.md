---
message: "could not read file \"%s\": read %d of %u"
slug: could-not-read-file-read-of-04d09e
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_combinebackup/reconstruct.c:544"
reproduced: false
---

# `could not read file "%s": read %d of %u`

## What it means

`pg_combinebackup` read from a backup file but received fewer bytes than expected while reconstructing a full backup. The values give the bytes read against the amount requested. A short read means the source file is truncated or damaged.

## When it happens

It happens while combining incremental backups, when a read of a backup file returns too few bytes — usually a truncated, corrupted, or incompletely transferred backup file.

## How to fix

Make sure every backup passed to `pg_combinebackup` is complete and intact, and that the storage holding them is healthy. Re-taking or re-transferring the affected backup resolves a truncated file.

## Example

*Illustrative* — a short read while reconstructing a backup.

```text
pg_combinebackup: fatal: could not read file "/backups/inc1/base/16384/16400": read 2048 of 8192
```

## Related

- [could not read file: read of](./could-not-read-file-read-of-b21beb.md)
- [could not read from file, offset: read of](./could-not-read-from-file-offset-read-of-8bb91d.md)

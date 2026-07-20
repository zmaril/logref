---
message: "could not read file \"%s\": read %zd of %lld"
slug: could-not-read-file-read-of-b21beb
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_combinebackup/pg_combinebackup.c:1371"
reproduced: false
---

# `could not read file "%s": read %zd of %lld`

## What it means

`pg_combinebackup` read from a large file but received fewer bytes than expected. The values give the bytes read against the amount requested. A short read means the source file is truncated or damaged.

## When it happens

It happens while combining backups, when a read of a large backup file returns too few bytes — usually a truncated, corrupted, or incompletely transferred file.

## How to fix

Make sure every backup passed to `pg_combinebackup` is complete and intact and that the storage holding them is healthy. Re-taking or re-transferring the affected backup resolves a truncated file.

## Example

*Illustrative* — a short read from a large backup file.

```text
pg_combinebackup: fatal: could not read file "/backups/full/base/16384/16400": read 65536 of 131072
```

## Related

- [could not read file: read of](./could-not-read-file-read-of-04d09e.md)
- [could not parse TLI for](./could-not-parse-tli-for.md)

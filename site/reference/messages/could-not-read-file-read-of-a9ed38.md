---
message: "could not read file \"%s\": read %lld of %lld"
slug: could-not-read-file-read-of-a9ed38
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_combinebackup/load_manifest.c:201"
  - "postgres/src/bin/pg_verifybackup/pg_verifybackup.c:495"
reproduced: false
---

# `could not read file "%s": read %lld of %lld`

## What it means

A backup tool (`pg_combinebackup` or `pg_verifybackup`) read fewer bytes from a file than expected. The first `%s` is the path and the counts are bytes read versus wanted. The file is shorter than the manifest or header says.

## When it happens

A backup file was truncated, incomplete, or corrupted, or an I/O error cut the read short while combining or verifying a backup.

## How to fix

Confirm the backup is complete and intact — re-copy it if it was transferred partially. Re-run the source backup if the file is genuinely short. Check storage for I/O faults.

## Example

*Illustrative* — a truncated backup file.

```text
pg_verifybackup: error: could not read file "base/1/1259": read 4096 of 8192
```

## Related

- [could not read from filter file](./could-not-read-from-filter-file.md)
- [could not write file: wrote of](./could-not-write-file-wrote-of-c8a991.md)

---
message: "could not update checksum of file \"%s\""
slug: could-not-update-checksum-of-file
passthrough: false
api: [elog, pg_fatal]
level: [ERROR, FATAL]
call_sites:
  - "postgres/src/backend/backup/basebackup.c:1108"
  - "postgres/src/bin/pg_combinebackup/backup_label.c:166"
  - "postgres/src/bin/pg_combinebackup/copy_file.c:160"
  - "postgres/src/bin/pg_combinebackup/copy_file.c:207"
  - "postgres/src/bin/pg_combinebackup/reconstruct.c:726"
  - "postgres/src/bin/pg_combinebackup/reconstruct.c:772"
  - "postgres/src/bin/pg_combinebackup/write_manifest.c:270"
reproduced: false
---

# `could not update checksum of file "%s"`

## What it means

During a backup or file reconstruction, Postgres could not update a file's running checksum. The placeholder is the file. Backup code computes checksums as it reads/writes files; a failure here means the checksum step could not complete, casting doubt on the backup's integrity.

## When it happens

`pg_basebackup`, incremental backup reconstruction (`pg_combinebackup`), or backup-manifest generation, when reading a file for checksumming fails or the file changed unexpectedly mid-read. It can accompany I/O errors or concurrent modification.

## How to fix

Investigate the named file and the storage under it — an I/O error during the read is the usual cause. Re-run the backup; if it recurs for the same file, check disk health and whether something is modifying data files outside Postgres. Do not trust a backup that could not complete its checksums; produce a clean one before relying on it.

## Example

*Illustrative* — a checksum step failing during base backup.

```text
ERROR:  could not update checksum of file "base/16384/2619"
```

## Related

- [could not read file](./could-not-read-file-54f73a.md)
- [could not write file](./could-not-write-file.md)

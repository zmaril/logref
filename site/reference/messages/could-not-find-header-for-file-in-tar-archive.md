---
message: "could not find header for file \"%s\" in tar archive"
slug: could-not-find-header-for-file-in-tar-archive
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/pg_backup_tar.c:1072"
  - "postgres/src/bin/pg_dump/pg_backup_tar.c:1103"
reproduced: false
---

# `could not find header for file "%s" in tar archive`

## What it means

The `pg_dump`/`pg_restore` tar-format reader could not find the tar header for a file it expected. The placeholder is the file name. The archive's structure does not contain an entry the restore needs.

## When it happens

Restoring from a tar-format dump that is truncated, corrupted, or was assembled incorrectly, so a member file's header is missing.

## How to fix

Confirm the tar archive is complete and undamaged; regenerate the dump if it may be truncated. Restore from a verified, intact archive. If the dump is sound, capture the file name and archive and report it.

## Example

*Illustrative* — a missing tar member during restore.

```text
pg_restore: error: could not find header for file "toc.dat" in tar archive
```

## Related

- [could not find entry for ID](./could-not-find-entry-for-id.md)
- [could not find](./could-not-find.md)

---
message: "corrupt tar header found in %s (expected %d, computed %d) file position %lld"
slug: corrupt-tar-header-found-in-expected-computed-file-position
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/pg_backup_tar.c:1176"
reproduced: false
---

# `corrupt tar header found in %s (expected %d, computed %d) file position %lld`

## What it means

`pg_dump`/`pg_restore` reading a tar-format archive found a tar header whose checksum or position does not match what it computed. The archive's tar structure is inconsistent, so it stops.

## When it happens

It happens with tar-format dumps when the archive file is truncated, altered, or corrupted between dump and restore.

## How to fix

Use an intact copy of the archive. Re-create the dump if the file is damaged, and verify transfers (checksums) to avoid corruption. A tar archive with a bad header cannot be restored reliably.

## Example

*Illustrative* — a bad tar header during restore.

```text
pg_restore: error: corrupt tar header found in ... (expected 123, computed 456) file position 10240
```

## Related

- [COPY stream ended before last file was finished](./copy-stream-ended-before-last-file-was-finished.md)
- [could not close data file](./could-not-close-data-file-da381a.md)

---
message: "error during file seek: %m"
slug: error-during-file-seek
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/pg_backup_archiver.c:2679"
  - "postgres/src/bin/pg_dump/pg_backup_custom.c:440"
  - "postgres/src/bin/pg_dump/pg_backup_custom.c:506"
  - "postgres/src/bin/pg_dump/pg_backup_custom.c:642"
  - "postgres/src/bin/pg_dump/pg_backup_custom.c:878"
  - "postgres/src/bin/pg_dump/pg_backup_tar.c:1004"
  - "postgres/src/bin/pg_dump/pg_backup_tar.c:1009"
reproduced: false
---

# `error during file seek: %m`

## What it means

A client tool failed to reposition within a file it was reading or writing. The `%m` is the OS error. Archive formats (custom and tar `pg_dump`/`pg_restore`) seek within the archive to read table-of-contents entries and data blocks; a seek failure stops that.

## When it happens

`pg_restore` or `pg_dump` on a custom/tar archive whose underlying file cannot be sought — a non-seekable stream (a pipe), a truncated archive, or failing storage. Restoring from stdin (a pipe) is a classic cause because pipes are not seekable.

## How to fix

Restore from a regular file, not a pipe — custom/tar formats need a seekable input, so `pg_restore archive.dump` works where `cat archive.dump | pg_restore` does not. If the file is on disk, check for truncation and storage errors. Use the plain SQL format if you must stream through a pipe.

## Example

*Illustrative* — restoring a custom-format dump from a pipe.

```sh
cat db.dump | pg_restore -d mydb
```

Produces:

```text
pg_restore: error: error during file seek: Illegal seek
```

## Related

- [could not open output file](./could-not-open-output-file-6b393d.md)
- [could not read from input file: %m](./could-not-read-from-input-file-c5612a.md)

---
message: "could not open output file \"%s\": %m"
slug: could-not-open-output-file-6b393d
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/pg_backup_archiver.c:1729"
  - "postgres/src/bin/pg_dump/pg_backup_custom.c:151"
  - "postgres/src/bin/pg_dump/pg_backup_directory.c:301"
  - "postgres/src/bin/pg_dump/pg_backup_directory.c:550"
  - "postgres/src/bin/pg_dump/pg_backup_directory.c:616"
  - "postgres/src/bin/pg_dump/pg_backup_directory.c:634"
  - "postgres/src/bin/pg_dump/pg_dumpall.c:558"
reproduced: false
---

# `could not open output file "%s": %m`

## What it means

A client tool could not open its output file for writing. The path is the first placeholder and `%m` the OS error. Tools like `pg_dump` and `pg_dumpall` write to a destination file, and creating/opening it failed.

## When it happens

`pg_dump -f file`, `pg_dumpall > file` via `--file`, or a directory-format dump where the output path is not writable. Common `%m`: `Permission denied`, `No such file or directory` (a parent directory is missing), or `Is a directory`.

## How to fix

Read `%m`. `Permission denied` — pick a writable destination or fix directory permissions for the user running the tool. `No such file or directory` — create the parent directory first. `Is a directory` — the path names an existing directory; choose a file path (or use directory format intentionally). Then rerun.

## Example

*Illustrative* — dumping to an unwritable path.

```sh
pg_dump -f /var/backups/db.sql mydb
```

Produces:

```text
pg_dump: error: could not open output file "/var/backups/db.sql": Permission denied
```

## Related

- [could not open file](./could-not-open-file-420e05.md)
- [error during file seek](./error-during-file-seek.md)

---
message: "could not open input file \"%s\": %m"
slug: could-not-open-input-file-bea6ca
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/pg_backup_archiver.c:2301"
  - "postgres/src/bin/pg_dump/pg_backup_custom.c:168"
  - "postgres/src/bin/pg_dump/pg_backup_custom.c:820"
  - "postgres/src/bin/pg_dump/pg_backup_directory.c:172"
  - "postgres/src/bin/pg_dump/pg_backup_directory.c:358"
reproduced: false
---

# `could not open input file "%s": %m`

## What it means

A tool (here `pg_dump`/`pg_restore`) tried to open an input file and the OS `open()` failed. The placeholder is the path and `%m` the OS error. Because it fires at `FATAL`, the tool stops.

## When it happens

Restoring from a dump file or reading a tool's input when the path is wrong, the file was removed or never created, or its permissions do not allow the invoking user to read it.

## How to fix

Read the `%m` text. For `No such file or directory`, check the path and that the dump exists. For `Permission denied`, ensure the OS user running the tool can read the file. Use an absolute path if the working directory is uncertain.

## Example

*Illustrative* — a missing restore input file.

```text
FATAL:  could not open input file "db.dump": No such file or directory
```

## Related

- [could not open file for writing](./could-not-open-file-for-writing.md)
- [could not access file](./could-not-access-file.md)

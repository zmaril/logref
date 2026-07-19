---
message: "could not read input file: %m"
slug: could-not-read-input-file
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/pg_backup_archiver.c:2314"
reproduced: false
---

# `could not read input file: %m`

## What it means

`pg_dump` or `pg_restore` failed to read the archive it was given as input. The trailing text is the operating-system error from the failed read.

## When it happens

It happens during a restore or a dump-format conversion when the tool reads back an archive file and the read fails — a truncated file, a permission problem, or an I/O error on the storage.

## How to fix

Check the OS error. `Permission denied` means the user running the tool cannot read the file. An I/O error points at the storage or a partially transferred archive; verify the archive's size and integrity, and re-copy it if it was moved between hosts. Confirm you are pointing the tool at a complete, uncorrupted archive.

## Example

*Illustrative* — restoring from an unreadable archive.

```text
pg_restore: error: could not read input file: Input/output error
```

## Related

- [could not read server file](./could-not-read-server-file.md)
- [could not set seek position in archive file](./could-not-set-seek-position-in-archive-file.md)

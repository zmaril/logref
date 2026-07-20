---
message: "expected format (%d) differs from format found in file (%d)"
slug: expected-format-differs-from-format-found-in-file
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/pg_backup_archiver.c:4240"
reproduced: false
---

# `expected format (%d) differs from format found in file (%d)`

## What it means

`pg_restore` (or the dump archiver) opened an archive file whose recorded format did not match the format it was told to read. The placeholders are the expected and found format codes.

## When it happens

It fires when the archive header does not match the `--format` given to `pg_restore`, or when the file is not a valid custom/directory/tar archive at all — for example pointing `pg_restore` at a plain-text SQL dump, or a truncated or corrupted archive.

## How to fix

Let `pg_restore` auto-detect the format by omitting `--format`, or pass the format the archive was actually written in. A plain-text dump (made without `-Fc`/`-Fd`/`-Ft`) is restored with `psql`, not `pg_restore`. If the format should match, the archive file may be truncated or corrupted; re-create it.

## Example

*Illustrative* — restoring a plain SQL dump with pg_restore.

```
pg_restore: error: expected format (1) differs from format found in file (0)
```

## Related

- [expected check constraint on table but found](./expected-check-constraint-on-table-but-found.md)
- [error: %s() failed: error code %d](./failed-error-code-565002.md)

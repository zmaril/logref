---
message: "could not open file \"%s\" for writing: %m"
slug: could-not-open-file-for-writing
passthrough: false
api: [ereport, pg_fatal]
level: [ERROR, FATAL]
call_sites:
  - "postgres/src/backend/commands/copyto.c:1204"
  - "postgres/src/bin/initdb/initdb.c:743"
  - "postgres/src/bin/initdb/initdb.c:1051"
  - "postgres/src/bin/initdb/initdb.c:1071"
reproduced: true
---

# `could not open file "%s" for writing: %m`

## What it means

The server or a tool asked the OS to open a file for writing and `open()` failed. The placeholder is the path and `%m` the OS error. It covers `COPY ... TO file`, export paths, and similar write targets.

## When it happens

Writing to a server-side file (`COPY TO`, `pg_dump` output, log/state files) when the directory does not exist, is not writable by the server user, the filesystem is full or read-only, or the path is invalid.

## How to fix

Read the `%m` text. For `Permission denied`, the server operating-system user must own/have write access to the target directory. For `No such file or directory`, create the parent directory. `No space left on device` means free disk space. Remember server-side `COPY TO` writes as the server user, not the client.

## Example

*Reproduced* — captured from `reproducers/scenarios/24_txn_copy_cursor.sql`.

```sql
COPY repro.parent TO '/nonexistent_dir/x.csv';
```

Produces:

```text
ERROR:  could not open file "/nonexistent_dir/x.csv" for writing: No such file or directory
```

## Related

- [could not open log file](./could-not-open-log-file-bcff37.md)
- [could not write init file](./could-not-write-init-file.md)

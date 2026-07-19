---
message: "could not delete file \"%s\": %m"
slug: could-not-delete-file
passthrough: false
api: [ereport, pg_fatal]
level: [FATAL, LOG]
call_sites:
  - "postgres/src/backend/storage/file/fd.c:2032"
  - "postgres/src/bin/pg_resetwal/pg_resetwal.c:1033"
  - "postgres/src/bin/pg_resetwal/pg_resetwal.c:1071"
  - "postgres/src/bin/pg_resetwal/pg_resetwal.c:1108"
reproduced: false
---

# `could not delete file "%s": %m`

## What it means

The server tried to remove a file with `unlink()` and the operating system refused. The placeholder is the path and `%m` the OS error. Postgres deletes obsolete relation segments, temporary files, and WAL/backup files as part of normal operation.

## When it happens

Cleaning up a temporary file, an old relation segment after `DROP`/`TRUNCATE`, or a WAL/backup artifact, when permissions are wrong, the file is held open by another process (notably on Windows), or storage errors.

## How to fix

Read the `%m` text. Ensure the data directory is writable by the server user. On Windows, `Permission denied` often means another process still has the file open. Storage errors point at disk problems. At `LOG` the server continues and may retry cleanup; persistent failures can leak files and warrant investigation.

## Example

*Illustrative* — a cleanup unlink failing.

```text
LOG:  could not delete file "base/pgsql_tmp/pgsql_tmp12345.0": Permission denied
```

## Related

- [could not truncate file](./could-not-truncate-file.md)
- [could not open file for writing](./could-not-open-file-for-writing.md)

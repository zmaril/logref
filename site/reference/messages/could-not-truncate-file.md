---
message: "could not truncate file \"%s\": %m"
slug: could-not-truncate-file
passthrough: false
api: [ereport]
level: [ERROR, LOG, WARNING]
call_sites:
  - "postgres/contrib/pg_stat_statements/pg_stat_statements.c:2562"
  - "postgres/contrib/pg_stat_statements/pg_stat_statements.c:2775"
  - "postgres/src/backend/storage/file/buffile.c:967"
  - "postgres/src/backend/storage/smgr/md.c:364"
  - "postgres/src/backend/storage/smgr/md.c:1340"
reproduced: false
---

# `could not truncate file "%s": %m`

## What it means

The server tried to shrink a file to a shorter length with `ftruncate()`/truncate and the OS refused. The placeholder is the path and `%m` the OS error. Postgres truncates relation segments, temporary files, and some stat files.

## When it happens

Truncating a relation file (after `TRUNCATE`, `VACUUM` shrinking, or dropping), a temporary file, or a query-stats file, when the storage errors, the file is unexpectedly read-only, or the filesystem misbehaves.

## How to fix

Read the `%m` text. `Input/output error` points at failing storage — check disk health. Ensure the data directory is writable by the server user and not on a read-only mount. At `WARNING`/`LOG` the operation may continue with the file un-shrunk; at `ERROR` the statement fails and should be retried after fixing storage.

## Example

*Illustrative* — a truncate failing on bad storage.

```text
WARNING:  could not truncate file "base/16384/16401": Input/output error
```

## Related

- [could not delete file](./could-not-delete-file.md)
- [could not open file for writing](./could-not-open-file-for-writing.md)

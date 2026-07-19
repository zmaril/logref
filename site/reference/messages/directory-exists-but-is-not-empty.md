---
message: "directory \"%s\" exists but is not empty"
slug: directory-exists-but-is-not-empty
passthrough: false
api: [ereport, pg_fatal, pg_log_error]
level: [ERROR, FATAL]
sqlstate:
  - symbol: ERRCODE_DUPLICATE_FILE
    code: "58P02"
call_sites:
  - "postgres/src/backend/backup/basebackup_server.c:113"
  - "postgres/src/bin/initdb/initdb.c:2960"
  - "postgres/src/bin/initdb/initdb.c:3032"
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:778"
  - "postgres/src/bin/pg_combinebackup/pg_combinebackup.c:763"
  - "postgres/src/bin/pg_waldump/pg_waldump.c:140"
reproduced: false
---

# `directory "%s" exists but is not empty`

## What it means

A tool needed to write into a directory that must be empty, but it already contains files. The placeholder is the directory. `initdb`, `pg_basebackup`, and `pg_combinebackup` refuse to write into a non-empty target to avoid clobbering existing data.

## When it happens

`initdb -D dir` on a directory that already has contents, `pg_basebackup -D dir` to a non-empty destination, or `pg_combinebackup` output to an occupied path. Often the directory holds a previous cluster or a leftover partial run.

## How to fix

Use an empty (or non-existent) target directory, or clear the existing one if its contents are disposable — but be certain first, since it may hold a real cluster or backup. For `pg_basebackup`, choose a fresh destination. Remove leftover files from an aborted previous run before retrying.

## Example

*Illustrative* — initdb into a populated directory.

```sh
initdb -D /data/pg
```

Produces:

```text
initdb: error: directory "/data/pg" exists but is not empty
```

## Related

- [could not create directory](./could-not-create-directory.md)
- [directory path for new cluster is too long](./directory-path-for-new-cluster-is-too-long.md)

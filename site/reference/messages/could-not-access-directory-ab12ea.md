---
message: "could not access directory \"%s\": %m"
slug: could-not-access-directory-ab12ea
passthrough: false
api: [ereport, pg_fatal]
level: [ERROR, FATAL]
call_sites:
  - "postgres/src/backend/backup/basebackup_server.c:121"
  - "postgres/src/backend/utils/init/postinit.c:1209"
  - "postgres/src/bin/initdb/initdb.c:2972"
  - "postgres/src/bin/initdb/initdb.c:3042"
  - "postgres/src/bin/initdb/initdb.c:3476"
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:784"
  - "postgres/src/bin/pg_basebackup/pg_createsubscriber.c:463"
  - "postgres/src/bin/pg_combinebackup/pg_combinebackup.c:766"
  - "postgres/src/bin/pg_waldump/pg_waldump.c:144"
reproduced: false
---

# `could not access directory "%s": %m`

## What it means

Accessing a directory failed — Postgres could not open, stat, or enter it. The path is the first placeholder and `%m` the OS error. This general form is used where the specific operation (open vs stat) is less important than that the directory is unreachable.

## When it happens

Validating a data directory, tablespace, or backup destination at startup or during a backup/restore. Common `%m`: `Permission denied` (a path component is not searchable by the server user), `No such file or directory`, or `Not a directory` (a path component is a file).

## How to fix

Read `%m`. `Permission denied` — ensure the directory and all parent components are owned/traversable by the `postgres` user. `No such file or directory` — create or correct the path. `Not a directory` — a component in the path is actually a file; fix the path. Then retry.

## Example

*Illustrative* — a backup destination the server cannot enter.

```text
ERROR:  could not access directory "/backups/pg": Permission denied
```

## Related

- [could not open directory](./could-not-open-directory.md)
- [could not stat file](./could-not-stat-file.md)

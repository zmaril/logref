---
message: "could not read symbolic link \"%s\": %m"
slug: could-not-read-symbolic-link
passthrough: false
api: [ereport, pg_fatal]
level: [ERROR, FATAL, WARNING]
call_sites:
  - "postgres/src/backend/access/transam/xlog.c:9675"
  - "postgres/src/backend/backup/basebackup.c:1417"
  - "postgres/src/backend/catalog/pg_tablespace.c:78"
  - "postgres/src/bin/pg_combinebackup/pg_combinebackup.c:1278"
  - "postgres/src/bin/pg_rewind/file_ops.c:464"
reproduced: false
---

# `could not read symbolic link "%s": %m`

## What it means

The server tried to read the target of a symbolic link and the OS `readlink()` failed. The placeholder is the link path and `%m` the OS error. Postgres uses symlinks under `pg_tblspc` to point at tablespace locations, so this often concerns a tablespace link.

## When it happens

Reading tablespace symlinks during startup, base backup, or WAL replay when a link is missing, points nowhere, was replaced by a regular file, or lives on a filesystem that does not support symlinks.

## How to fix

Read the `%m` text and inspect the named path under `pg_tblspc`. Ensure the symlink exists and points at the correct tablespace directory, and that the data directory is on a filesystem that supports symlinks (avoid some network/Windows filesystems for tablespaces). Recreate a broken link to the right location.

## Example

*Illustrative* — a broken tablespace symlink.

```text
WARNING:  could not read symbolic link "pg_tblspc/16385": No such file or directory
```

## Related

- [could not create symbolic link](./could-not-create-symbolic-link.md)
- [could not access file](./could-not-access-file.md)

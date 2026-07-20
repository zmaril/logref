---
message: "could not create symbolic link \"%s\": %m"
slug: could-not-create-symbolic-link
passthrough: false
api: [ereport, pg_fatal]
level: [ERROR, FATAL]
call_sites:
  - "postgres/src/backend/access/transam/xlogrecovery.c:633"
  - "postgres/src/backend/commands/tablespace.c:670"
  - "postgres/src/bin/initdb/initdb.c:3046"
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:2859"
reproduced: false
---

# `could not create symbolic link "%s": %m`

## What it means

The server or a tool called `symlink()` and the operating system refused. The placeholder is the link path and `%m` the OS error. Postgres creates symlinks under `pg_tblspc` for tablespaces and during recovery; a failure here blocks that.

## When it happens

Creating a tablespace, replaying WAL that records a tablespace, or restoring, when the target directory is not writable, a link of that name already exists, or the filesystem does not support symlinks.

## How to fix

Read the `%m` text. Ensure the data directory (and `pg_tblspc`) is writable by the server user and on a filesystem that supports symbolic links (avoid some network/Windows filesystems for tablespaces). Remove a conflicting stale link if `File exists`, and confirm the tablespace target path is valid.

## Example

*Illustrative* — a tablespace symlink that cannot be created.

```text
FATAL:  could not create symbolic link "pg_tblspc/16385": Permission denied
```

## Related

- [could not read symbolic link](./could-not-read-symbolic-link.md)
- [could not change permissions of](./could-not-change-permissions-of.md)

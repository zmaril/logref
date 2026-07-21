---
message: "could not change permissions of directory \"%s\": %m"
slug: could-not-change-permissions-of-directory
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/initdb/initdb.c:2948"
  - "postgres/src/bin/initdb/initdb.c:3020"
  - "postgres/src/bin/pg_dump/dumputils.c:961"
reproduced: false
---

# `could not change permissions of directory "%s": %m`

## What it means

A tool (here `initdb`) could not change the permissions of a directory it created or manages. The placeholders are the directory path and the OS error. The data directory must have specific, restrictive permissions; if `chmod` fails, the tool cannot guarantee the required security posture and stops.

## When it happens

The process lacks permission to change the directory's mode, the filesystem does not support the operation (some network or FAT-style filesystems), or the path is not owned by the running user.

## How to fix

Read the appended OS error. Ensure the data directory is owned by the user running the tool and lives on a filesystem that supports Unix permissions. Fix ownership (`chown`) and run the tool as the owning user; avoid placing the data directory on filesystems that cannot honor `chmod` semantics.

## Example

*Illustrative* — a failed chmod on the data directory.

```text
initdb: error: could not change permissions of directory "/data": Operation not permitted
```

## Related

- [could not determine current directory](./could-not-determine-current-directory.md)
- [could not write lock file](./could-not-write-lock-file.md)

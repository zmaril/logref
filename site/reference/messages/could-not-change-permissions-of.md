---
message: "could not change permissions of \"%s\": %m"
slug: could-not-change-permissions-of
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/initdb/initdb.c:1464"
  - "postgres/src/bin/initdb/initdb.c:1478"
  - "postgres/src/bin/initdb/initdb.c:1542"
  - "postgres/src/bin/initdb/initdb.c:1553"
  - "postgres/src/bin/initdb/initdb.c:1561"
reproduced: false
---

# `could not change permissions of "%s": %m`

## What it means

A tool (here `initdb`) called `chmod` on a file or directory and the operating system refused. The placeholder is the path and `%m` the OS error. It fails at `FATAL`, aborting the operation.

## When it happens

Initializing or setting up a data directory on a filesystem or under ownership that does not permit changing modes — a wrong owner, a read-only mount, or a filesystem (some network mounts) that does not support Unix permissions.

## How to fix

Read the `%m` text. Ensure the operating-system user running the tool owns the target path, and that the filesystem supports and allows permission changes. Avoid data directories on filesystems (like some NFS/SMB mounts) that cannot represent Unix permission bits.

## Example

*Illustrative* — a chmod refused during initdb.

```text
FATAL:  could not change permissions of "/data": Operation not permitted
```

## Related

- [could not read permissions of directory](./could-not-read-permissions-of-directory.md)
- [could not create symbolic link](./could-not-create-symbolic-link.md)

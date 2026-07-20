---
message: "could not create lock file \"%s\": %m"
slug: could-not-create-lock-file
passthrough: false
api: [ereport]
level: [FATAL]
call_sites:
  - "postgres/src/backend/utils/init/miscinit.c:1233"
reproduced: false
---

# `could not create lock file "%s": %m`

## What it means

The server could not create a lock file it uses to guard a resource such as the data directory or a socket. The `%m` reason gives the OS error. The lock file protects against two servers using the same resource.

## When it happens

It happens at startup when creating a `postmaster.pid`-style lock file fails, usually from a permissions problem or a full filesystem in the data or socket directory.

## How to fix

Check permissions and free space on the directory named in the message. Make sure the server user owns and can write to it, and that no leftover file blocks creation. Fix the filesystem problem and restart.

## Example

*Illustrative* — a lock file that cannot be created.

```text
FATAL:  could not create lock file "/tmp/.s.PGSQL.5432.lock": Permission denied
```

## Related

- [could not create any Unix-domain sockets](./could-not-create-any-unix-domain-sockets.md)
- [could not create server file](./could-not-create-server-file.md)

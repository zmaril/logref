---
message: "could not stat data directory \"%s\": %m"
slug: could-not-stat-data-directory
passthrough: false
api: [ereport]
level: [FATAL]
call_sites:
  - "postgres/src/backend/port/posix_sema.c:209"
  - "postgres/src/backend/port/sysv_sema.c:345"
  - "postgres/src/backend/port/sysv_shmem.c:717"
reproduced: false
---

# `could not stat data directory "%s": %m`

## What it means

The server could not `stat()` the data directory. The placeholders are the path and the OS error. Startup and some subsystems need to examine the data directory; if that call fails, the directory is missing, inaccessible, or on a broken filesystem.

## When it happens

The `-D`/`PGDATA` path is wrong, the directory was removed or unmounted, or permissions prevent access — for example a data directory on a network mount that became unavailable.

## How to fix

Read the appended OS error. Confirm the data directory path is correct and the directory exists, is mounted, and is accessible to the server's OS user. Fix the mount/permissions or correct the `-D`/`PGDATA` value, then start the server.

## Example

*Illustrative* — an inaccessible data directory.

```text
FATAL:  could not stat data directory "/data": No such file or directory
```

## Related

- [no data directory specified](./no-data-directory-specified.md)
- [data directory is of wrong version](./data-directory-is-of-wrong-version.md)

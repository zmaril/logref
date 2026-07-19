---
message: "could not write lock file \"%s\": %m"
slug: could-not-write-lock-file
passthrough: false
api: [ereport]
level: [FATAL]
call_sites:
  - "postgres/src/backend/utils/init/miscinit.c:1409"
  - "postgres/src/backend/utils/init/miscinit.c:1423"
  - "postgres/src/backend/utils/init/miscinit.c:1434"
reproduced: false
---

# `could not write lock file "%s": %m`

## What it means

The server could not write a lock file. The placeholders are the file path and the OS error. Postgres writes lock files (such as `postmaster.pid`) to record cluster state; if the write fails, it cannot safely record that state and treats it as fatal.

## When it happens

The disk is full, the data directory is not writable, permissions are wrong, or the filesystem errored — typically at startup while creating `postmaster.pid` or a socket lock file.

## How to fix

Read the appended OS error. Ensure the data directory (and any socket directory) is writable by the server's OS user and has free space, and fix permissions/ownership if needed. Clear a stale lock file only if you are certain no server is running. Then start the server.

## Example

*Illustrative* — an unwritable lock file at startup.

```text
FATAL:  could not write lock file "postmaster.pid": No space left on device
```

## Related

- [could not change permissions of directory](./could-not-change-permissions-of-directory.md)
- [could not stat data directory](./could-not-stat-data-directory.md)

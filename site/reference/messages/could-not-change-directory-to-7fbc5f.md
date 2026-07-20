---
message: "could not change directory to \"%s\": %m"
slug: could-not-change-directory-to-7fbc5f
passthrough: false
api: [ereport, pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/backend/utils/init/miscinit.c:415"
  - "postgres/src/bin/pg_resetwal/pg_resetwal.c:407"
reproduced: false
---

# `could not change directory to "%s": %m`

## What it means

A server or utility process could not change its working directory to the given path. The placeholder is the path and the system reason. The directory does not exist, is not accessible, or permissions deny entry.

## When it happens

Starting the server or a tool such as `pg_resetwal` when the target data directory is missing, has wrong ownership or permissions, or lives on an unmounted or unavailable filesystem.

## How to fix

Confirm the path exists and the OS user running Postgres owns it and can enter it (`chdir` requires execute permission on the directory). Check that the filesystem is mounted and healthy. Correct the ownership or path and retry.

## Example

*Illustrative* — an inaccessible data directory.

```text
FATAL:  could not change directory to "/var/lib/pgsql/data": Permission denied
```

## Related

- [could not create missing directory](./could-not-create-missing-directory.md)
- [component in parameter is not an absolute path](./component-in-parameter-is-not-an-absolute-path.md)

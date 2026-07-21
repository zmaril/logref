---
message: "could not access file \"%s\": %m"
slug: could-not-access-file
passthrough: false
api: [ereport, pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/transam/twophase.c:2574"
  - "postgres/src/backend/storage/file/fd.c:513"
  - "postgres/src/backend/utils/fmgr/dfmgr.c:212"
  - "postgres/src/bin/initdb/initdb.c:1022"
reproduced: true
---

# `could not access file "%s": %m`

## What it means

A `stat()`/access check on a file failed. The placeholder is the path and `%m` the OS error. The server or tool was probing whether a file exists or is reachable and the operating system returned an error.

## When it happens

Checking for a two-phase state file, a WAL file, a library, or another expected path when it is missing, on an unreachable mount, or blocked by permissions on a parent directory.

## How to fix

Read the `%m` text. `No such file or directory` means the path is absent — verify it was not removed and that any parent directories exist. `Permission denied` on access usually means a parent directory lacks execute/search permission for the server user. Fix the path or permissions.

## Example

*Reproduced* — captured from `reproducers/scenarios/22_system_admin_funcs.sql`.

```sql
SELECT pg_create_logical_replication_slot('badslot', 'nonexistent_plugin');
```

Produces:

```text
ERROR:  could not access file "nonexistent_plugin": No such file or directory
```

## Related

- [could not open input file](./could-not-open-input-file-bea6ca.md)
- [could not read permissions of directory](./could-not-read-permissions-of-directory.md)

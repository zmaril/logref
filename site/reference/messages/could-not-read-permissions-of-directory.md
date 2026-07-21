---
message: "could not read permissions of directory \"%s\": %m"
slug: could-not-read-permissions-of-directory
passthrough: false
api: [ereport, pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/backend/utils/init/miscinit.c:311"
  - "postgres/src/bin/pg_resetwal/pg_resetwal.c:401"
  - "postgres/src/bin/pg_rewind/pg_rewind.c:294"
  - "postgres/src/bin/pg_upgrade/pg_upgrade.c:117"
reproduced: false
---

# `could not read permissions of directory "%s": %m`

## What it means

The server called `stat()` on its data directory to check the directory's permission bits and the call failed. The placeholder is the path and `%m` the OS error. At startup Postgres verifies the data directory has safe permissions, and it cannot do that if it cannot read them.

## When it happens

Starting the server when the data directory is missing, on an unreachable mount, or when a parent directory denies access to the server user.

## How to fix

Read the `%m` text. Ensure the data directory exists, is mounted, and is owned by the server user with the expected permissions (`0700` or `0750`). Check that every parent directory grants search (execute) permission to the server user. Fix ownership/permissions, then start again.

## Example

*Illustrative* — an unreadable data directory at startup.

```text
FATAL:  could not read permissions of directory "/data": Permission denied
```

## Related

- [could not change permissions of](./could-not-change-permissions-of.md)
- [could not access file](./could-not-access-file.md)

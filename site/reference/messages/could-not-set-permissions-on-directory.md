---
message: "could not set permissions on directory \"%s\": %m"
slug: could-not-set-permissions-on-directory
passthrough: false
api: [ereport, pg_fatal]
level: [ERROR, FATAL]
call_sites:
  - "postgres/src/backend/commands/tablespace.c:623"
  - "postgres/src/fe_utils/astreamer_file.c:343"
reproduced: false
---

# `could not set permissions on directory "%s": %m`

## What it means

Permissions could not be set on a directory. The `%s` is the path and the `%m` is the operating-system error. On the server this is a tablespace directory; in client tools it is a backup output directory.

## When it happens

The process lacked ownership or rights to `chmod` the directory, or the target filesystem does not support the requested mode, while creating a tablespace or writing a backup.

## How to fix

Read the trailing error. Ensure the server or tool user owns the directory and that the filesystem supports the mode. Fix ownership or choose a suitable target, then retry.

## Example

*Illustrative* — chmod on a tablespace directory failed.

```text
ERROR:  could not set permissions on directory "/mnt/space/pg": Operation not permitted
```

## Related

- [could not set permissions on file](./could-not-set-permissions-on-file.md)
- [exists but is not a directory](./exists-but-is-not-a-directory.md)

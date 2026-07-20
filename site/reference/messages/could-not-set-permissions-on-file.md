---
message: "could not set permissions on file \"%s\": %m"
slug: could-not-set-permissions-on-file
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_waldump/archive_waldump.c:626"
  - "postgres/src/fe_utils/astreamer_file.c:382"
reproduced: false
---

# `could not set permissions on file "%s": %m`

## What it means

Permissions could not be set on a file. The `%s` is the path and the `%m` is the operating-system error. It fires in client tools writing backup or WAL output that must have restrictive modes.

## When it happens

The tool could not `chmod` a file it wrote — wrong ownership, or a filesystem that does not honor the mode — during `pg_basebackup`, `pg_waldump` archive extraction, or a stream write.

## How to fix

Ensure the tool user owns the target and the destination filesystem supports the requested permissions. Choose a target that preserves modes (avoid some network filesystems), then retry.

## Example

*Illustrative* — chmod on a backup file failed.

```text
pg_basebackup: error: could not set permissions on file "backup/base.tar": Operation not permitted
```

## Related

- [could not set permissions on directory](./could-not-set-permissions-on-directory.md)
- [could not fsync file](./could-not-fsync-file-5db846.md)

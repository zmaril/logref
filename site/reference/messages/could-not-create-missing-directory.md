---
message: "could not create missing directory \"%s\": %m"
slug: could-not-create-missing-directory
passthrough: false
api: [ereport]
level: [FATAL]
call_sites:
  - "postgres/src/backend/access/transam/xlog.c:4178"
  - "postgres/src/backend/access/transam/xlog.c:4199"
reproduced: false
---

# `could not create missing directory "%s": %m`

## What it means

During startup, the server tried to create a required directory under the data directory and failed. The placeholders are the path and the system reason. A directory Postgres expects (for example under `pg_wal` or `pg_tblspc`) was absent and could not be recreated.

## When it happens

Starting a cluster whose data directory is missing an expected subdirectory, on a filesystem with wrong permissions, out of space, or read-only, so the directory cannot be made.

## How to fix

Check the OS error in the detail. Ensure the data directory is intact, owned by the Postgres OS user, writable, and has free space. If subdirectories were deleted, restore them from a backup rather than guessing at their contents. Fix permissions or space and restart.

## Example

*Illustrative* — a missing directory that could not be created.

```text
FATAL:  could not create missing directory "pg_tblspc/16400": Permission denied
```

## Related

- [could not change directory to](./could-not-change-directory-to-7fbc5f.md)
- [could not create symbolic link from to](./could-not-create-symbolic-link-from-to.md)

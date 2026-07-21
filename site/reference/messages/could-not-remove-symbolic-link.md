---
message: "could not remove symbolic link \"%s\": %m"
slug: could-not-remove-symbolic-link
passthrough: false
api: [ereport, pg_fatal]
level: [ERROR, FATAL]
level_runtime_chosen: true
call_sites:
  - "postgres/src/backend/commands/tablespace.c:833"
  - "postgres/src/backend/commands/tablespace.c:919"
  - "postgres/src/bin/pg_rewind/file_ops.c:303"
reproduced: false
---

# `could not remove symbolic link "%s": %m`

## What it means

The server or a tool could not remove a symbolic link. The placeholders are the link path and the OS error. Tablespace management and directory cleanup remove symlinks (for example under `pg_tblspc`); a failed unlink can leave a stale link that interferes with later operations.

## When it happens

Permissions prevent removing the link, the filesystem errored, or the link's parent directory is not writable — often during `DROP TABLESPACE` or cleanup of a tablespace directory.

## How to fix

Read the appended OS error. Ensure the server OS user owns and can write the directory holding the link, and that no external process holds or protects it. Fix permissions and remove any stale link manually if a `DROP TABLESPACE` left one behind, then retry. Persistent failures point to a filesystem/permissions issue to resolve at the OS level.

## Example

*Illustrative* — a symlink that could not be removed.

```text
ERROR:  could not remove symbolic link "pg_tblspc/16500": Permission denied
```

## Related

- [symbolic link target is too long](./symbolic-link-target-is-too-long.md)
- [could not change permissions of directory](./could-not-change-permissions-of-directory.md)

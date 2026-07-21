---
message: "could not create symbolic link from \"%s\" to \"%s\": %m"
slug: could-not-create-symbolic-link-from-to
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_combinebackup/pg_combinebackup.c:404"
  - "postgres/src/fe_utils/astreamer_file.c:362"
reproduced: false
---

# `could not create symbolic link from "%s" to "%s": %m`

## What it means

A backup-combining or file-streaming tool (`pg_combinebackup`, frontend file streamer) could not create a symbolic link. The placeholders are the source, target, and system reason. Tablespace links are recreated with symlinks, and this one failed.

## When it happens

Assembling a backup that contains tablespace symlinks when the destination filesystem does not support symlinks, permissions deny link creation, or the target path is invalid.

## How to fix

Check the OS error in the detail. Ensure the destination filesystem supports symbolic links and that the tool has permission to create them, and that the referenced target path is valid. Correct the filesystem or permission problem and retry.

## Example

*Illustrative* — a symlink that could not be created.

```text
FATAL:  could not create symbolic link from "pg_tblspc/16400" to "/mnt/space": Permission denied
```

## Related

- [could not create missing directory](./could-not-create-missing-directory.md)
- [could not clone file to](./could-not-clone-file-to.md)

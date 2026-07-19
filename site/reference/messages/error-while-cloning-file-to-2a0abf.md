---
message: "error while cloning file \"%s\" to \"%s\": %s"
slug: error-while-cloning-file-to-2a0abf
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_combinebackup/copy_file.c:251"
reproduced: false
---

# `error while cloning file "%s" to "%s": %s`

## What it means

`pg_combinebackup` failed to clone a file with a library-reported error. The placeholders are the source and destination paths and the error string. The reflink/clone of a backup file did not complete.

## When it happens

It fires in `pg_combinebackup` while reconstructing a backup in clone mode, when cloning a file fails for a reason reported as a string rather than an errno.

## How to fix

Check the reported error and the destination filesystem. Clone (reflink) requires a filesystem that supports it (such as Btrfs or XFS with reflink); on unsupported filesystems, use copy mode instead. Ensure the destination has space and is healthy.

## Example

*Illustrative* — a clone failure during combine.

```text
pg_combinebackup: error: error while cloning file "a" to "b": ...
```

## Related

- [error while cloning file to](./error-while-cloning-file-to-503a98.md)
- [error while cloning relation could not create file](./error-while-cloning-relation-could-not-create-file.md)

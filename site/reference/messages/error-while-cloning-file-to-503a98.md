---
message: "error while cloning file \"%s\" to \"%s\": %m"
slug: error-while-cloning-file-to-503a98
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_combinebackup/copy_file.c:232"
reproduced: false
---

# `error while cloning file "%s" to "%s": %m`

## What it means

`pg_combinebackup` failed to clone a file with an operating-system error. The placeholders are the source and destination paths and the OS error. The reflink/clone of a backup file did not complete.

## When it happens

It fires in `pg_combinebackup` while reconstructing a backup in clone mode, when cloning a file hits an errno such as a permission problem, a full disk, or an unsupported operation.

## How to fix

Read the OS error. `Operation not supported` means the filesystem does not support cloning — use copy mode instead. `No space left on device` means free the destination filesystem. Fix the specific cause and rerun.

## Example

*Illustrative* — a clone failure during combine.

```text
pg_combinebackup: error: error while cloning file "a" to "b": Operation not supported
```

## Related

- [error while cloning file to](./error-while-cloning-file-to-2a0abf.md)
- [error while cloning relation could not create file](./error-while-cloning-relation-could-not-create-file.md)

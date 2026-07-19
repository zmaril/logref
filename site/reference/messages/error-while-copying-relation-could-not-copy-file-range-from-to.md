---
message: "error while copying relation \"%s.%s\": could not copy file range from \"%s\" to \"%s\": %m"
slug: error-while-copying-relation-could-not-copy-file-range-from-to
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_upgrade/file.c:168"
reproduced: false
---

# `error while copying relation "%s.%s": could not copy file range from "%s" to "%s": %m`

## What it means

During `pg_upgrade` in copy mode using the `copy_file_range` optimization, copying a relation's file failed. The placeholders are the schema-qualified relation, the source and target files, and the OS error.

## When it happens

It fires in `pg_upgrade` while transferring relation files with `copy_file_range`, when the syscall fails — an unsupported operation, a cross-filesystem copy, or an I/O error.

## How to fix

Read the OS error. `Operation not supported` or a cross-device error means `copy_file_range` cannot be used here — `pg_upgrade` normally falls back, but you can force a plain copy by not requesting the efficient mode. `No space left on device` means free the target. Fix the cause and rerun.

## Example

*Illustrative* — a copy_file_range failure.

```text
pg_upgrade: error: error while copying relation "public.t": could not copy file range from "/old/..." to "/new/...": Invalid cross-device link
```

## Related

- [error while cloning relation to](./error-while-cloning-relation-to-87b802.md)
- [error while checking for file existence to](./error-while-checking-for-file-existence-to.md)

---
message: "could not copy file range between old and new data directories: %m"
slug: could-not-copy-file-range-between-old-and-new-data-directories
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_upgrade/file.c:260"
reproduced: false
---

# `could not copy file range between old and new data directories: %m`

## What it means

During `pg_upgrade`, a `copy_file_range` operation between the old and new data directories failed. The `%m` reason gives the OS error. This is the fast in-kernel copy path used to move relation files.

## When it happens

It happens in `pg_upgrade`'s copy or clone phase when the kernel's range-copy call fails, for example from a full destination filesystem or an I/O error.

## How to fix

Check free space and health of the new data directory's filesystem. If the filesystem does not support `copy_file_range` well, choose a different transfer mode (`--copy` instead of `--clone`, or the reverse) and rerun.

## Example

*Illustrative* — a range copy failing during upgrade.

```text
could not copy file range between old and new data directories: No space left on device
```

## Related

- [could not copy file to](./could-not-copy-file-to.md)
- [could not create hard link between old and new data directories (link mode)](./could-not-create-hard-link-between-old-and-new-data-directories-in-link-mode.md)

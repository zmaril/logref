---
message: "could not create hard link between old and new data directories: %m\nIn swap mode the old and new data directories must be on the same file system."
slug: could-not-create-hard-link-between-old-and-new-data-directories-in-swap-mode
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_upgrade/file.c:288"
reproduced: false
---

# `could not create hard link between old and new data directories: %m
In swap mode the old and new data directories must be on the same file system.`

## What it means

In `pg_upgrade`'s swap mode, creating a hard link between a file in the old data directory and its counterpart in the new one failed. The `%m` reason gives the OS error, and the message reminds you both directories must share one filesystem.

## When it happens

It happens during a `pg_upgrade` swap-mode run when the two data directories are on different filesystems, or when the filesystem does not support hard links.

## How to fix

Place the old and new data directories on the same filesystem for swap mode, or choose a different transfer mode. Confirm the filesystem supports hard links.

## Example

*Illustrative* — swap mode across two filesystems.

```text
could not create hard link between old and new data directories: Invalid cross-device link
In swap mode the old and new data directories must be on the same file system.
```

## Related

- [could not create hard link between old and new data directories (link mode)](./could-not-create-hard-link-between-old-and-new-data-directories-in-link-mode.md)
- [could not copy file range between old and new data directories](./could-not-copy-file-range-between-old-and-new-data-directories.md)

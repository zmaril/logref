---
message: "could not create hard link between old and new data directories: %m\nIn link mode the old and new data directories must be on the same file system."
slug: could-not-create-hard-link-between-old-and-new-data-directories-in-link-mode
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_upgrade/file.c:285"
reproduced: false
---

# `could not create hard link between old and new data directories: %m
In link mode the old and new data directories must be on the same file system.`

## What it means

In `pg_upgrade`'s link mode, creating a hard link between a file in the old data directory and its counterpart in the new one failed. The `%m` reason gives the OS error, and the message reminds you both directories must share one filesystem.

## When it happens

It happens during a `pg_upgrade --link` run when the two data directories are on different filesystems, or when the filesystem does not support hard links.

## How to fix

Place the old and new data directories on the same filesystem for link mode, or switch to `--copy`/`--clone` if they must stay separate. Check that the filesystem supports hard links.

## Example

*Illustrative* — link mode across two filesystems.

```text
could not create hard link between old and new data directories: Invalid cross-device link
In link mode the old and new data directories must be on the same file system.
```

## Related

- [could not create hard link between old and new data directories (swap mode)](./could-not-create-hard-link-between-old-and-new-data-directories-in-swap-mode.md)
- [could not create link from to](./could-not-create-link-from-to.md)

---
message: "could not create link from \"%s\" to \"%s\": %m"
slug: could-not-create-link-from-to
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_combinebackup/copy_file.c:333"
reproduced: false
---

# `could not create link from "%s" to "%s": %m`

## What it means

`pg_combinebackup` could not create a hard link from a source backup file to the reconstructed output directory. The `%m` reason gives the OS error.

## When it happens

It happens while combining backups in a mode that uses hard links, when the source and output are on different filesystems or the filesystem does not support hard links.

## How to fix

Place the source and output on the same filesystem for link-based reconstruction, or use a copy-based mode. Confirm the filesystem supports hard links.

## Example

*Illustrative* — a hard link across filesystems during backup combination.

```text
pg_combinebackup: fatal: could not create link from "a" to "b": Invalid cross-device link
```

## Related

- [could not copy file to](./could-not-copy-file-to.md)
- [could not create hard link between old and new data directories (link mode)](./could-not-create-hard-link-between-old-and-new-data-directories-in-link-mode.md)

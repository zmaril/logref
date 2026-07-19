---
message: "could not stat file or directory \"%s\": %m"
slug: could-not-stat-file-or-directory
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/backup/basebackup.c:1157"
  - "postgres/src/backend/backup/basebackup.c:1358"
reproduced: false
---

# `could not stat file or directory "%s": %m`

## What it means

A `stat` on a file or directory failed during a base backup. The `%s` is the path and the `%m` is the operating-system error. The server could not read the entry's attributes while walking the data directory.

## When it happens

An entry vanished between listing and stat, a permission problem blocked access, or an I/O error occurred while `BASE_BACKUP` enumerated files.

## How to fix

Read the trailing error. Transient disappearance of temp files during a live backup is usually harmless and retried; a persistent permission or I/O error needs the directory and storage checked.

## Example

*Illustrative* — an entry disappeared during backup enumeration.

```text
ERROR:  could not stat file or directory "base/16384/t3_16390": No such file or directory
```

## Related

- [could not stat directory](./could-not-stat-directory.md)
- [could not initialize checksum of file](./could-not-initialize-checksum-of-file.md)

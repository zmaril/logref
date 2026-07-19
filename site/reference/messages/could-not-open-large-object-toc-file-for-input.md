---
message: "could not open large object TOC file \"%s\" for input: %m"
slug: could-not-open-large-object-toc-file-for-input
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/pg_backup_directory.c:422"
reproduced: false
---

# `could not open large object TOC file "%s" for input: %m`

## What it means

`pg_restore` reading a directory-format archive tried to open the large-object table-of-contents file and the operating system refused. The `%m` reason gives the cause. This file lists the large objects in the archive.

## When it happens

It happens during a directory-format restore when the large-object TOC file inside the archive directory is missing or unreadable — usually a damaged or incomplete archive, or a permissions problem.

## How to fix

Confirm the archive directory is complete and readable, including its large-object TOC file, then rerun the restore. A missing file usually means the archive was not produced or transferred completely.

## Example

*Illustrative* — the large-object TOC file could not be opened.

```text
pg_restore: fatal: could not open large object TOC file "dump/blobs.toc" for input: No such file or directory
```

## Related

- [could not open TOC file](./could-not-open-toc-file.md)
- [could not open TOC file for input](./could-not-open-toc-file-for-input-bafa4b.md)

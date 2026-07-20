---
message: "could not open TOC file \"%s\": %m"
slug: could-not-open-toc-file
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/pg_backup_archiver.c:1584"
reproduced: false
---

# `could not open TOC file "%s": %m`

## What it means

`pg_restore` tried to open the table-of-contents file of a custom- or directory-format archive and the operating system refused. The `%m` reason gives the cause. The TOC records what the archive contains.

## When it happens

It happens at the start of a restore when the archive's TOC file is missing or unreadable — usually a wrong archive path, an incomplete transfer, or a permissions problem.

## How to fix

Confirm the archive path is correct and readable by the invoking user and that the archive is complete, then rerun the restore. The `%m` reason names the specific problem.

## Example

*Illustrative* — the archive TOC file could not be opened.

```text
pg_restore: fatal: could not open TOC file "dump.custom": No such file or directory
```

## Related

- [could not open TOC file for input](./could-not-open-toc-file-for-input-bafa4b.md)
- [could not open large object TOC file for input](./could-not-open-large-object-toc-file-for-input.md)

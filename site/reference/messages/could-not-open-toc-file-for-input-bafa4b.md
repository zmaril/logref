---
message: "could not open TOC file \"%s\" for input: %m"
slug: could-not-open-toc-file-for-input-bafa4b
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/pg_backup_tar.c:202"
reproduced: false
---

# `could not open TOC file "%s" for input: %m`

## What it means

`pg_restore` reading a tar-format archive tried to open the named table-of-contents file and the operating system refused. The `%m` reason gives the cause. The TOC records what the tar archive contains.

## When it happens

It happens during a tar-format restore when the archive's TOC file is missing or unreadable — usually a wrong path, an incomplete archive, or a permissions problem.

## How to fix

Confirm the archive path is correct and readable and that the tar archive is complete, then rerun the restore. The `%m` reason names the specific problem.

## Example

*Illustrative* — the tar TOC file could not be opened.

```text
pg_restore: fatal: could not open TOC file "dump.tar" for input: No such file or directory
```

## Related

- [could not open TOC file for input](./could-not-open-toc-file-for-input-1ff02a.md)
- [could not open TOC file](./could-not-open-toc-file.md)

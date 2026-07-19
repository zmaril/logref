---
message: "could not open TOC file \"%s\" for output: %m"
slug: could-not-open-toc-file-for-output-87ac3c
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/pg_backup_tar.c:168"
reproduced: false
---

# `could not open TOC file "%s" for output: %m`

## What it means

`pg_dump` writing a tar-format archive tried to create the named table-of-contents file and the operating system refused. The `%m` reason gives the cause. The TOC records what the tar archive contains.

## When it happens

It happens during a tar-format dump when the TOC file cannot be created at the target path — usually a destination directory that does not exist or is not writable.

## How to fix

Point the dump at a writable destination whose directory exists, and confirm the invoking user can create files there, then rerun. The `%m` reason names the specific problem.

## Example

*Illustrative* — the tar TOC file could not be created.

```text
pg_dump: fatal: could not open TOC file "dump.tar" for output: Permission denied
```

## Related

- [could not open TOC file for output](./could-not-open-toc-file-for-output-50df44.md)
- [could not open TOC file for input](./could-not-open-toc-file-for-input-bafa4b.md)

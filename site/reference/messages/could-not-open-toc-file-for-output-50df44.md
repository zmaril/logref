---
message: "could not open TOC file for output: %m"
slug: could-not-open-toc-file-for-output-50df44
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/pg_backup_tar.c:175"
reproduced: false
---

# `could not open TOC file for output: %m`

## What it means

`pg_dump` writing a tar-format archive to a stream tried to open its table-of-contents stream for writing and could not. The `%m` reason gives the cause. This variant applies when no file name is available because output goes to a stream.

## When it happens

It happens during a tar-format dump that writes to standard output, when the TOC stream cannot be opened for writing — usually a broken pipe or a non-seekable destination.

## How to fix

Write the dump to a named file with `-f` so the tool can create and seek its TOC, rather than streaming a tar-format archive to a destination that cannot be reopened. A regular file avoids the problem.

## Example

*Illustrative* — the TOC stream could not be opened for output.

```text
pg_dump: fatal: could not open TOC file for output: Bad file descriptor
```

## Related

- [could not open TOC file for output](./could-not-open-toc-file-for-output-87ac3c.md)
- [could not open TOC file for input](./could-not-open-toc-file-for-input-1ff02a.md)
